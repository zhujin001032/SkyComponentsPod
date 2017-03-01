//
//  SkyAppDelegate.m
//  SkyComponentsPod
//
//  Created by CocoaPods on 06/16/2015.
//  Copyright (c) 2014 Jason.He. All rights reserved.
//

#import "SkyAppDelegate.h"
#import "RootViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>
#import "SkyNotificationViewController.h"
#import "SVProgressHUD.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

static NSString *shareSDKAppKey = @"11416120e95c4";
static NSString *shareSDKAppSecret = @"297b8b4bb18059376b7c98586e328ba9";
static NSString *shareSDKAppKeyForShare = @"113b2a087af5c";
static NSString *shareSDKAppSecretForShre = @"95a43515930e89295796695fc8f3ce1d";


@interface SkyAppDelegate ()

@property (nonatomic, strong) RootViewController        *rootController;
@property (nonatomic, strong) UINavigationController    *rootNavController;
@property (nonatomic, strong) BMKMapManager             *mapManager;


@end

#pragma mark -

@implementation SkyAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //操作统计
    [self tracking];
    _rootController = [[RootViewController alloc] initWithStyle:UITableViewStyleGrouped];
    _rootNavController = [[UINavigationController alloc] initWithRootViewController:_rootController];
    [self.window setRootViewController:_rootNavController];
   
    //通知
//    [self configNotification];
    [self registerNotification];
    //短信
    [SMSSDK registerApp:shareSDKAppKey withSecret:shareSDKAppSecret];
    [SMSSDK enableAppContactFriends:NO];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    /**
     *  @author Jason He, 16-04-05
     *
     *  @brief ShareSDk 分享 登录
     */
    
    [self configShareSDK];
    
    [self baiduMap];
    
    return YES;
}

#pragma mark - 第三方操作统计
- (void)tracking
{
    // For Tracking演示 & 第三方操作统计
    // Add UMeng Analytics
    ReportPolicy policy = BATCH;
#if DEBUG
    policy = REALTIME;
#endif
    // 修改最新的UMeng使用方法
    // Modify by Mark 2016-05-23
//    [MobClick startWithAppkey:UMENG_KEY
//                 reportPolicy:policy
//                    channelId:CHANNEL_ID];
    UMAnalyticsConfig *umConfig = [UMAnalyticsConfig sharedInstance];
    [umConfig setAppKey:UMENG_KEY];
    [umConfig setEPolicy:policy];
    [umConfig setChannelId:CHANNEL_ID];
    [MobClick startWithConfigure:umConfig];
    // End Modify
    // 集成测试注册设备数据，用于注册统计的测试设备
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    // End Add
}

#pragma mark - 百度地图
- (void)baiduMap{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"HDGb8drOjPu1CuLVZx65YNDBWmX2lQGU" generalDelegate:self];
    if (!ret) {
        NSLog(@"baiduMap manager start failed!");
    }

}

#pragma mark - ShareSDK 分享-登录
- (void)configShareSDK
{
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp: shareSDKAppKeyForShare
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeFacebook),
                            @(SSDKPlatformTypeWhatsApp),
                            @(SSDKPlatformTypeSMS)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;

             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeFacebook:
                 //设置Facebook应用信息，其中authType设置为只用SSO形式授权
                 //暂时借用 wgc  com.wgchao.dg //@"1588426398110629" @"190087ca4d7803420d3e1db763ff4d47"
                 [appInfo SSDKSetupFacebookByApiKey:@"1037282806350368"
                                          appSecret:@"85e6efb0e6ddcfbf026308fc3aaf8a3a"
                                           authType:SSDKAuthTypeBoth];
                 
                 break;
             default:
                 break;
         }
     }];
}

-(void)onResp:(BaseResp *)resp
{
    NSLog(@"The response of wechat.");
}


#pragma mark - 配置通知设置
- (void)configNotification{
    float sysVersion=[[UIDevice currentDevice]systemVersion].floatValue;
    if (sysVersion>=8.0) {
        UIUserNotificationType type=UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}
#pragma mark - 配置通知设置（包含快捷操作）

- (void)registerNotification{
    float sysVersion=[[UIDevice currentDevice]systemVersion].floatValue;
    if (sysVersion < 8.0) {
        return;
    }
    //创建消息上面的Resend动作
    UIMutableUserNotificationAction *actionResend = [[UIMutableUserNotificationAction alloc] init];
    actionResend.identifier = kNotificationActionIdentifierResend;
    actionResend.title = NSLocalizedStringFromTable(@"ReSend", nil, nil);
    //点击时候不启动app 后台处理
    actionResend.activationMode = UIUserNotificationActivationModeBackground;
    
    //需要解锁才能处理(意思就是如果在锁屏界面收到通知，并且用户设置了屏幕锁，用户点击了Resend不会直接进入我们的回调进行处理，而是需要用户输入屏幕锁密码之后才进入我们的回调)，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    actionResend.authenticationRequired = NO;
    /*
     destructive属性设置后，在通知栏或锁屏界面左划，按钮颜色会变为红色
     如果两个按钮均设置为YES，则均为红色（略难看）
     如果两个按钮均设置为NO，即默认值，则第一个为蓝色，第二个为浅灰色
     如果一个YES一个NO，则都显示对应的颜色，即红蓝双色 (CP色)。
     */
    actionResend.destructive = NO;
    
    //创建第二个动作
    UIMutableUserNotificationAction *actionComment = [[UIMutableUserNotificationAction alloc]init];
    actionComment.identifier = kNotificationActionIdentifierComment;
    actionComment.title = NSLocalizedStringFromTable(@"NewMessage", nil, nil);
    actionComment.activationMode = UIUserNotificationActivationModeBackground;
    //设置了behavior属性为 UIUserNotificationActionBehaviorTextInput 的话，则用户点击了该按钮会出现输入框供用户输入 >>> IOS9
    if (sysVersion>=9.0) {
        actionComment.behavior = UIUserNotificationActionBehaviorTextInput;
        actionComment.activationMode = UIUserNotificationActivationModeBackground;

        //这个字典定义了当用户点击了NewMessage按钮后，输入框右侧的按钮名称，如果不设置该字典，则右侧按钮名称默认为 “发送”
        actionComment.parameters = @{UIUserNotificationTextInputActionButtonTitleKey: @"NewMessage"};

    }else
    {
        actionComment.activationMode = UIUserNotificationActivationModeForeground;

    }
    
    //创建动作（button）的类别集合
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc]init];
    /**
     *  @author Jason He, 16-03-25
     *  服务端配置的消息体中 需要包含 category 字段且与本地设置相同 才能触发动作
     *  @brief {"aps":{"alert":"testMessage", "sound":"default", "badge": 1, "category":"kNotificationCategoryIdentifier"}}
     */
    category.identifier = kNotificationCategoryIdentifier;
    //最多支持两个，如果添加更多的话，后面的将被忽略
    [category setActions:@[actionResend,actionComment] forContext:UIUserNotificationActionContextMinimal];
    
    UIUserNotificationType type=UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
    UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:type categories:[NSSet setWithObject:category]];
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    //注册远程推送
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *tokenStr = [NSString stringWithTokenData:deviceToken];
    NSLog(@"token:%@",tokenStr);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
 {
      NSLog(@"Receive remote notification : %@",userInfo);
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
       [alert show];
     
 }

#pragma mark - 本地通知回调函数，当应用程序在前台时调用

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"%@", notification.userInfo);
    [self showAlertView:@"用户没点击按钮直接点的推送消息进来的/或者该app在前台状态时收到推送消息"];
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge -= notification.applicationIconBadgeNumber;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
}

#pragma mark - IOS9 本地通知动作响应 
//在非本App界面时收到本地消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮，notification为消息内容
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)())completionHandler
{
    if ([identifier isEqualToString:kNotificationActionIdentifierResend]) {
        
        [self scheduleNotification:notification];
        
    } else if ([identifier isEqualToString:kNotificationActionIdentifierComment]) {
        //获取通知页面输入的message
        SkyNotificationViewController *notifiVC = [[SkyNotificationViewController alloc]init];
        notifiVC.notificationMessage = [responseInfo objectForKey:UIUserNotificationActionResponseTypedTextKey];
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
        [nav pushViewController:notifiVC animated:YES];
        
    }
    
    completionHandler();
}

#pragma mark - IOS 8 本地通知动作响应
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler{
    
    if ([identifier isEqualToString:kNotificationActionIdentifierResend]) {
        
        [self scheduleNotification:notification];
        
    } else if ([identifier isEqualToString:kNotificationActionIdentifierComment]) {
        
        SkyNotificationViewController *notifiVC = [[SkyNotificationViewController alloc]init];
//        notifiVC.notificationMessage = [responseInfo objectForKey:UIUserNotificationActionResponseTypedTextKey];
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
        [nav pushViewController:notifiVC animated:YES];
        
    }
    
    completionHandler();
    
}
#pragma mark - IOS9 远程推送通知动作响应

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)())completionHandler NS_AVAILABLE_IOS(9_0) __TVOS_PROHIBITED{
    if ([identifier isEqualToString:kNotificationActionIdentifierResend]) {
        
//        [self scheduleNotification:notification];
        
    } else if ([identifier isEqualToString:kNotificationActionIdentifierComment]) {
        //获取通知页面输入的message
        SkyNotificationViewController *notifiVC = [[SkyNotificationViewController alloc]init];
        notifiVC.notificationMessage = [responseInfo objectForKey:UIUserNotificationActionResponseTypedTextKey];
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
        [nav pushViewController:notifiVC animated:YES];
        
    }
    
    completionHandler();
   
}
#pragma mark - IOS8 远程推送通知动作响应

// Called when your app has been activated by the user selecting an action from a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler NS_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED{
   
    SkyNotificationViewController *notifiVC = [[SkyNotificationViewController alloc]init];
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    [nav pushViewController:notifiVC animated:YES];

}


- (void)showAlertView:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self.window.rootViewController showDetailViewController:alert sender:nil];
}

- (void)scheduleNotification:(UILocalNotification *)origNotification{
    UILocalNotification *notification ;
    
    if (origNotification) {
        //重复执行
        notification = origNotification;
        NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:2];
        notification.fireDate = pushDate;
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
        return;

    }else
    {
        notification = [[UILocalNotification alloc] init];
    }
    
    //设置5秒之后
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow: 2];
    if (notification != nil) {
        //         设置推送时间（5秒后）
        notification.fireDate = pushDate;
        //         设置时区（此为默认时区）
        notification.timeZone = [NSTimeZone defaultTimeZone];
        //         设置重复间隔（默认0，不重复推送）
        //        notification.repeatInterval = kCFCalendarUnitMinute;
        notification.repeatInterval = 0;
        //         推送声音（系统默认）
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 推送内容
        notification.alertBody = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Local Notification  message test", nil, nil)];
        
        notification.applicationIconBadgeNumber = 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"SkyLocalNotification" forKey:@"SkyLocalNotificationKey"];
        notification.userInfo = info;
        notification.category = kNotificationCategoryIdentifier;
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
        //        [app presentLocalNotificationNow:notification];//立即执行
        
    }
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"baiduMap联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"baiduMap授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
