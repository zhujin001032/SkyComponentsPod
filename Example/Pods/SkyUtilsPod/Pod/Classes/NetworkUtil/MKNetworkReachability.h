//
//  MKNetworkReachability.h
//  Pods
//
//  Reference from YYKit-YYReachability
//
//  Created by Mark Yang on 12/3/15.
//
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

typedef NS_ENUM(NSUInteger, MKNetworkReachabilityStatus) {
    MKNetworkReachabilityStatusNone = 0,      // not reachable
    MKNetworkReachabilityStatusWWAN,          // WWAN (2G/3G/4G)
    MKNetworkReachabilityStatusWiFi,          // WiFi
};

typedef NS_ENUM(NSUInteger, MKNetworkWWANStatus) {
    MKNetworkWWANStatusNone = 0,        // not reachable via WWAN
    MKNetworkWWANStatus2G,              // 2G (GPRS/EDGE)           10-100Kbps
    MKNetworkWWANStatus3G,              // 3G (WCDMA/HSPDA/...)     1-10Mbps
    MKNetworkWWANStatus4G,              // 4G (eHRPD/LTE)           100Mbps
};

#pragma mark -

@interface MKNetworkReachability : NSObject

@property (nonatomic, assign, readonly) SCNetworkReachabilityFlags  flags;
@property (nonatomic, assign, readonly) MKNetworkReachabilityStatus status;
@property (nonatomic, assign, readonly) MKNetworkWWANStatus         wwanStatus NS_AVAILABLE_IOS(7_0);
@property (nonatomic, assign, readonly, getter=isReachable) BOOL    reachable;

@property (nonatomic, copy) void (^notifyBlock)(MKNetworkReachability *reachability);

#pragma mark -

+ (instancetype)reachability;
+ (instancetype)reachabilityForLocalWiFi;
+ (instancetype)reachabilityWithHostname:(NSString *)hostname;
+ (instancetype)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress;

@end
