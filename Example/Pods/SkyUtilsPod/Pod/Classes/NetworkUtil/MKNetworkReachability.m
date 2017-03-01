//
//  MKNetworkReachability.m
//  Pods
//
//  Created by Mark Yang on 12/3/15.
//
//

#import "MKNetworkReachability.h"
#import <objc/message.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

static MKNetworkReachabilityStatus MKReachabilityStatusFromFlags(SCNetworkReachabilityFlags flags, BOOL alllowWWAN)
{
    if (0 == (flags & kSCNetworkReachabilityFlagsReachable)) {
        return MKNetworkReachabilityStatusNone;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
        (flags & kSCNetworkReachabilityFlagsTransientConnection)) {
        return MKNetworkReachabilityStatusNone;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) && alllowWWAN) {
        return MKNetworkReachabilityStatusWWAN;
    }
    
    return MKNetworkReachabilityStatusWiFi;
}

static void MKNetworkReachabilityCallback(SCNetworkReachabilityRef target,
                                          SCNetworkReachabilityFlags flags,
                                          void *info)
{
    MKNetworkReachability *self = ((__bridge MKNetworkReachability *)info);
    if (self.notifyBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.notifyBlock(self);
        });
    }
}

#pragma mark -

@interface MKNetworkReachability ()

@property (nonatomic, assign) SCNetworkReachabilityRef ref;
@property (nonatomic, assign) BOOL                     scheduled;
@property (nonatomic, assign) BOOL                     allowWWAN;
@property (nonatomic, strong) CTTelephonyNetworkInfo   *networkInfo;

@end

#pragma mark -

@implementation MKNetworkReachability

#pragma mark -
#pragma mark Setter and Getter

- (void)setScheduled:(BOOL)scheduled
{
    if (_scheduled == scheduled) {
        return;
    }
    
    _scheduled = scheduled;
    if (scheduled) {
        SCNetworkReachabilityContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
        SCNetworkReachabilitySetCallback(_ref, MKNetworkReachabilityCallback, &context);
        SCNetworkReachabilitySetDispatchQueue(_ref, [self.class sharedQueue]);
    }
    else {
        SCNetworkReachabilitySetDispatchQueue(_ref, NULL);
    }
}//

- (SCNetworkReachabilityFlags)flags
{
    SCNetworkReachabilityFlags flags = 0;
    SCNetworkReachabilityGetFlags(_ref, &flags);
    
    return flags;
}//

- (MKNetworkReachabilityStatus)status
{
    return MKReachabilityStatusFromFlags(self.flags, self.allowWWAN);
}//

- (MKNetworkWWANStatus)wwanStatus
{
    // should be iOS7.0+, so judgement it.
    if (nil == _networkInfo) {
        return MKNetworkWWANStatusNone;
    }
    NSString *status = _networkInfo.currentRadioAccessTechnology;
    // no carrier info, be no WWAN
    if (!status) {
        return MKNetworkWWANStatusNone;
    }
    
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{CTRadioAccessTechnologyGPRS:@(MKNetworkWWANStatus2G),       // 2.5G     171Kbps
                CTRadioAccessTechnologyEdge:@(MKNetworkWWANStatus2G),       // 2.75G    384Kbps
                CTRadioAccessTechnologyWCDMA:@(MKNetworkWWANStatus3G),      // 3G       3.6Mbps/384Kbps
                CTRadioAccessTechnologyHSDPA:@(MKNetworkWWANStatus3G),      // 3.5G     14.4Mbps/384Kbps
                CTRadioAccessTechnologyHSUPA:@(MKNetworkWWANStatus3G),      // 3.75G    14.5Mbps/5.76Kbps
                CTRadioAccessTechnologyCDMA1x:@(MKNetworkWWANStatus3G),     // 2.5G
                CTRadioAccessTechnologyCDMAEVDORev0:@(MKNetworkWWANStatus3G),
                CTRadioAccessTechnologyCDMAEVDORevA:@(MKNetworkWWANStatus3G),
                CTRadioAccessTechnologyCDMAEVDORevB:@(MKNetworkWWANStatus3G),
                CTRadioAccessTechnologyeHRPD:@(MKNetworkWWANStatus3G),
                CTRadioAccessTechnologyLTE:@(MKNetworkWWANStatus4G)};       // LTE: 3.9G 150M/75M LTE-Advanced:4G 300M/150M
    });
    NSNumber *num = dic[status];
    if (num) {
        return num.unsignedIntegerValue;
    }
    else {
        return MKNetworkWWANStatusNone;
    }
}//

- (BOOL)isReachable
{
    return self.status != MKNetworkReachabilityStatusNone;
}//

- (void)setNotifyBlock:(void (^)(MKNetworkReachability *))notifyBlock
{
    _notifyBlock = [notifyBlock copy];
    self.scheduled = (_notifyBlock != nil);
}//

#pragma mark -

+ (dispatch_queue_t)sharedQueue
{
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.skyutilpod.readability", DISPATCH_QUEUE_SERIAL);
    });
    
    return queue;
}//

#pragma mark -

- (void)dealloc
{
    self.notifyBlock = nil;     // must be self.xxx
    self.scheduled = NO;
    CFRelease(self.ref);
}//

- (instancetype)init
{
    struct sockaddr_in zero_addr;
    bzero(&zero_addr, sizeof(zero_addr));
    zero_addr.sin_len = sizeof(zero_addr);
    zero_addr.sin_family = AF_INET;
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zero_addr);
    
    return [self initWithRef:ref];
}//

- (instancetype)initWithRef:(SCNetworkReachabilityRef)ref
{
    if (!ref) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _ref = ref;
        _allowWWAN = YES;
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
            _networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        }
    }
    
    return self;
}//

#pragma mark -

+ (instancetype)reachability
{
    return [[self alloc] init];
}//

+ (instancetype)reachabilityForLocalWiFi
{
    struct sockaddr_in localWiFiAddress;
    bzero(&localWiFiAddress, sizeof(localWiFiAddress));
    localWiFiAddress.sin_len = sizeof(localWiFiAddress);
    localWiFiAddress.sin_family = AF_INET;
    localWiFiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    MKNetworkReachability *one = [self reachabilityWithAddress:&localWiFiAddress];
    one.allowWWAN = NO;
    
    return one;
}//

+ (instancetype)reachabilityWithHostname:(NSString *)hostname
{
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);
    
    return [[self alloc] initWithRef:ref];
}//

+ (instancetype)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress
{
   SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)hostAddress);
    
    return [[self alloc] initWithRef:ref];
}//

@end
