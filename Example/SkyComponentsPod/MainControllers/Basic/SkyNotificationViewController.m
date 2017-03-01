//
//  SkyNotificationViewController.m
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
#import "SkyNotificationViewController.h"
#define kLocalNotificationKey @"SkyLocalNotificationKey"
@interface SkyNotificationViewController ()
{
    UITextField *_startTimeField;
    UITextField *_bageNumberField;
    UITextField *_messageField;
}
@end
@implementation SkyNotificationViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    _messageField = [[UITextField alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 30, 35)];
    _messageField.placeholder = NSLocalizedString(@"Enter Message For Notification", nil);
    _messageField.borderStyle = UITextBorderStyleRoundedRect;
    if (self.notificationMessage) {
        _messageField.text = self.notificationMessage;
    }
    [self.view addSubview:_messageField];

    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, 120, 30)];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.text = NSLocalizedString(@"Start Time:", nil);
    [self.view addSubview:timeLabel];
    
    _startTimeField = [[UITextField alloc]initWithFrame:CGRectMake(timeLabel.mkMaxX + 5, timeLabel.mkY, SCREEN_WIDTH - timeLabel.mkMaxX  - 30, 30)];
    _startTimeField.placeholder = NSLocalizedString(@"Seconds", nil);
    _startTimeField.keyboardType = UIKeyboardTypeNumberPad;
    _startTimeField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_startTimeField];

    UILabel *repeatLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, timeLabel.mkMaxY+5, 120, 30)];
    repeatLabel.font = [UIFont systemFontOfSize:14];
    repeatLabel.text = NSLocalizedString(@"Badge Number:", nil);
    [self.view addSubview:repeatLabel];
    
    _bageNumberField = [[UITextField alloc]initWithFrame:CGRectMake( repeatLabel.mkMaxX + 5, repeatLabel.mkY, SCREEN_WIDTH - repeatLabel.mkMaxX  - 30, 30)];
    _bageNumberField.placeholder = NSLocalizedString(@"Enter a number", nil);
    _bageNumberField.keyboardType = UIKeyboardTypeNumberPad;
    _bageNumberField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_bageNumberField];

    
    UIButton *sendNotificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendNotificationButton.frame = CGRectMake(40,  _bageNumberField.mkMaxY + 15, SCREEN_WIDTH - 2*40 , 30);
    [sendNotificationButton setTitle:NSLocalizedString(@"Send Local Notification", nil) forState:UIControlStateNormal];
    [sendNotificationButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [sendNotificationButton setTitleColor:[UIColor colorWithRed:0.437 green:0.455 blue:0.439 alpha:1.000] forState:UIControlStateHighlighted];
    sendNotificationButton.backgroundColor = [UIColor colorWithRed:0.117 green:0.585 blue:1.000 alpha:1.000];
    [sendNotificationButton addTarget: self action:@selector(sendButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    sendNotificationButton.layer.cornerRadius = 5.0;
    sendNotificationButton.layer.masksToBounds = YES;
    [self.view addSubview:sendNotificationButton];
}

- (void)sendButtonPress:(UIButton *)sender
{
    [self scheduleNotification];

}


#pragma mark - 设置本地推送参数，并进行推送
- (void)scheduleNotification{
    
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    for (UILocalNotification *obj in [UIApplication sharedApplication].scheduledLocalNotifications) {
        if ([obj.userInfo.allKeys containsObject:kLocalNotificationKey]) {
            [[UIApplication sharedApplication] cancelLocalNotification:obj];
        }
    }
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置5秒之后
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow: ([_startTimeField.text integerValue]>=0) ? ([_startTimeField.text integerValue]): 5];
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
        if (_messageField.text.length) {
            notification.alertBody = _messageField.text;
        }else
        {
            notification.alertBody = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Local Notification  message received", nil, nil)];
        }

        notification.applicationIconBadgeNumber = ([_bageNumberField.text integerValue]>0)?[_bageNumberField.text integerValue] : 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"SkyLocalNotification" forKey:kLocalNotificationKey];
        notification.userInfo = info;
        notification.category = kNotificationCategoryIdentifier;
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
//        [app presentLocalNotificationNow:notification];//立即执行
        
    }
}

@end
