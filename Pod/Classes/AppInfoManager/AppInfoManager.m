//
//  AppInfoManager.m
//  HelloTeacher
//
//  Created by Mark Yang on 10/10/14.
//  Copyright (c) 2014 Missionsky. All rights reserved.
//

#import "AppInfoManager.h"

#define UserDefault [NSUserDefaults standardUserDefaults]

//NSString const  *SkyComponentsAppID = @"448841815";
const static NSString *kAppInfoURL = @"http://itunes.apple.com/lookup?id=";
const static NSString *kFirstLaunchKey = @"SkyComponentsIsFirstLaunchKey";

#pragma mark -

@interface AppInfoManager () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *conAppStore;
@property (nonatomic, strong) NSMutableData   *dataAppStore;

#pragma mark -

/**
 *	@brief	App在AppStore上的APP_ID(例#define SkyComponentsAppID)
            获取方式为App于AppStore的Link, 如：
            https://itunes.apple.com/cn/app/accela-inspector/id492840294?l=en&mt=8,
            后id后的数字(492840294)
 *
 *	@return	N/A
 *
 *	Created by Mark on 2016-03-17 10:26
 */
- (void)sendAppStoreVersionRequestWithAppID:(NSString *)appID;

@end

#pragma mark -

@implementation AppInfoManager

+ (BOOL)isFirstLaunch
{
    BOOL isFirst = ![UserDefault boolForKey:(NSString *)kFirstLaunchKey];
    if (isFirst) {
        [UserDefault setBool:YES forKey:(NSString *)kFirstLaunchKey];
        [NSUserDefaults resetStandardUserDefaults];
        return YES;
    }
    
    return NO;             // 暂时定为第一次启动
}//

+ (BOOL)hasAdData
{
    // 在Cache目录的判断, 测试默认有广告数据先
    return NO;
    return YES;
}//

- (void)setRequestErrorBlock:(RequestAppVersionInfoErrorBlock)aRequestErrorBlock
{
    _requestErrorBlock = nil;
    _requestErrorBlock = [aRequestErrorBlock copy];
    
    return;
}//

- (void)setRequestFinishBlock:(RequestAppVersionInfoDidFinishBlock)aRequestFinishBlock
{
    _requestFinishBlock = nil;
    _requestFinishBlock = [aRequestFinishBlock copy];
    
    return;
}//

#pragma mark -

+ (AppInfoManager *)sharedManager
{
    static AppInfoManager *__sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedManager = [[AppInfoManager alloc] init];
    });
    
    return __sharedManager;
}//

#pragma mark -

- (NSString *)appName
{
    NSString *strAppName = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
    
    return strAppName;
}//

- (NSString *)currentAppVersion
{
//    NSString *strCurAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSString *strCurAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    return strCurAppVersion;
}//

- (void)requestAppVersionInfoInAppStoreWithAppID:(NSString *)appID
{
    // 使用delegate callback, 先清理block
    _requestErrorBlock = nil;
    _requestFinishBlock = nil;
    [self sendAppStoreVersionRequestWithAppID:appID];
    
    return;
}//

- (void)requestAppVersionInfoInAppStoreWithAppID:(NSString *)appID
                                  withErrorBlock:(RequestAppVersionInfoErrorBlock)aErrorBlock
                                 withFinishBlock:(RequestAppVersionInfoDidFinishBlock)aFinishBlock
{
    // 使用block callback, 先清理delegate
    _delegate = nil;
    [self setRequestErrorBlock:aErrorBlock];
    [self setRequestFinishBlock:aFinishBlock];
    [self sendAppStoreVersionRequestWithAppID:appID];
    
    return;
}//

#pragma mark -
#pragma mark Private Methods

- (void)sendAppStoreVersionRequestWithAppID:(NSString *)appID
{
    if (appID.length < 1) {
        NSLog(@"======获取AppInfo时AppID不能为空======");
        
        return;
    }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", kAppInfoURL, appID];
    NSURL *url = [[NSURL alloc] initWithString:strUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setTimeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    if (nil != _conAppStore) {
        [_conAppStore cancel];
    }
    _conAppStore= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [_conAppStore start];
    
    return;
}//

#pragma mark -
#pragma mark NSURLConnectionDataDelegate

// 请求失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error Info : %@", error.userInfo[NSLocalizedDescriptionKey]);
    if (_delegate && [_delegate respondsToSelector:@selector(requestAppVersionInfoError:)]) {
        [_delegate requestAppVersionInfoError:error];
    }
    if (_requestErrorBlock) {
        _requestErrorBlock(error);
    }
    
    return;
}//

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Response Receive");
    if (nil != _dataAppStore) {
        _dataAppStore = nil;
    }
    _dataAppStore = [[NSMutableData alloc] init];
    
    return;
}//

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Receiving Data");
    [_dataAppStore appendData:data];
    
    return;
}//

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Connection Finish");
    NSError *error = nil;
    NSDictionary *dicInfo = [NSJSONSerialization JSONObjectWithData:_dataAppStore
                                                            options:NSJSONReadingMutableContainers
                                                              error:&error];
    if (_delegate && [_delegate respondsToSelector:@selector(requestAppVersionInfoDidFinish:withError:)]) {
        [_delegate requestAppVersionInfoDidFinish:dicInfo withError:error];
    }
    
    if (_requestFinishBlock) {
        _requestFinishBlock(dicInfo, error);
    }
//    if (nil == error) {
//        NSLog(@"App Info In Store : %@", dicInfo);
//    }
//    else {
//        NSLog(@"解析数据失败");
//    }
    
    return;
}//


@end
