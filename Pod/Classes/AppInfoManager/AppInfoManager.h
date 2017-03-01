//
//  AppInfoManager.h
//  SkyComponentsPod
//
//  Created by Mark Yang on 10/10/14.
//  Copyright (c) 2014 Missionsky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestAppVersionInfoErrorBlock)(NSError *aError);
typedef void (^RequestAppVersionInfoDidFinishBlock)(NSDictionary *aDicInfo, NSError *aError);

#pragma mark -

@protocol AppInfoManagerDelegate <NSObject>

@optional
- (void)requestAppVersionInfoError:(NSError *)aError;
- (void)requestAppVersionInfoDidFinish:(NSDictionary *)aDicInfo withError:(NSError *)aError;

@end

#pragma mark -

@interface AppInfoManager : NSObject

@property (nonatomic, weak) id<AppInfoManagerDelegate>          delegate;
@property (nonatomic, copy) RequestAppVersionInfoErrorBlock     requestErrorBlock;
@property (nonatomic, copy) RequestAppVersionInfoDidFinishBlock requestFinishBlock;

#pragma mark -

/**
 *	@brief	程序是否安装后第一次启动
 *
 *	@return	程序第一次启动标识
 *
 *	Created by Mark on 2014-10-13 20:24
 */
+ (BOOL)isFirstLaunch;

/**
 *	@brief	是否有广告数据(适用于启动程序后的请秒全屏广告)
 *
 *	@return	广告数据存在标识
 *
 *	Created by Mark on 2014-11-04 17:35
 */
+ (BOOL)hasAdData;

#pragma mark -

/**
 *	@brief	创建单例对象
 *
 *	@return	AppInfoManager对象
 *
 *	Created by Mark on 2014-10-10 22:51
 */
+ (AppInfoManager *)sharedManager;

#pragma mark -

/**
 *	@brief	当前程序名
 *
 *	@return 当前程序名
 *
 *	Created by Mark on 2014-10-10 22:53
 */
- (NSString *)appName;

/**
 *	@brief	当前程序版本
 *
 *	@return App当前程序版本信息字符串
 *
 *	Created by Mark on 2014-10-10 22:36
 */
- (NSString *)currentAppVersion;

/**
 *	@brief  获取AppStore上的App版本信息(需在.m文件配置的AppID信息，开发者你懂的!), 
            外部信息回传用delegate, 需实现AppInfoManagerDelegate方法.
            App在AppStore上的APP_ID(例#define SkyComponentsAppID), 命名为SkyComponentsAppID
            获取方式为App于AppStore的Link, 如：
            https://itunes.apple.com/cn/app/accela-inspector/id492840294?l=en&mt=8,
            后id后的数字(492840294)
 *
 *  @param  appID           AppID
 *
 *	@return N/A
 *
 *	Created by Mark on 2014-10-10 22:59
 */
- (void)requestAppVersionInfoInAppStoreWithAppID:(NSString *)appID;

/**
 *	@brief  获取AppStore上的App版本信息(需在.m文件配置的AppID信息，开发者你懂的!), 外部信息回传用Block(Error,Finish)
            App在AppStore上的APP_ID(例#define SkyComponentsAppID), 命名为SkyComponentsAppID
            获取方式为App于AppStore的Link, 如：
            https://itunes.apple.com/cn/app/accela-inspector/id492840294?l=en&mt=8,
            后id后的数字(492840294)
 *
 *  @param  appID           AppID
 *	@param 	aErrorBlock 	错误处理的Block代码段
 *	@param 	aFinishBlock 	完成处理的Block代码段
 *
 *	@return	N/A
 *
 *	Created by Mark on 2014-10-11 09:04
 */
- (void)requestAppVersionInfoInAppStoreWithAppID:(NSString *)appID
                                  withErrorBlock:(RequestAppVersionInfoErrorBlock)aErrorBlock
                                 withFinishBlock:(RequestAppVersionInfoDidFinishBlock)aFinishBlock;

@end
