//
//  SkyNotificationViewController.h
//  SkyComponentsPod
//
//  Created by 何助金 on 16/3/24.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

/**
 *  @author Jason He, 16-03-28
 *
 *  @brief 1.通知配置 参见 SkyAppdelegate.m 中方法 registerNotification
 *  2.收到本地通知及远程推送 处理详见 参见 SkyAppdelegate.m
 *  3.推送相关证书制作 参考：http://www.jianshu.com/p/78282e16db66
 */

#import "BaseViewController.h"

@interface SkyNotificationViewController : BaseViewController
@property (nonatomic,retain)NSString *notificationMessage;
- (void)scheduleNotification;
@end
