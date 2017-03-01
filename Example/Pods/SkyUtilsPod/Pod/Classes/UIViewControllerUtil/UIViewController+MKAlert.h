//
//  UIViewController+MKAlert.h
//  SkyUtils
//
//  Created by Mark Yang on 11/18/15.
//  Copyright © 2015 MissionSky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MKAlert)

/**
 *	@brief	显示带标题&内容的警告框
 *
 *	@param 	title 	标题
 *	@param 	message 	警告内容
 *
 *	@return	N/A
 *
 *	Created by Mark on 2015-11-18 17:02
 */
+ (void)showAlertView:(NSString *)title withMessage:(NSString *)message;

/**
 *	@brief  显示带标题&内容的警告框，警告选项handle代理
 *
 *	@param 	title   标题
 *	@param 	message     警告内容
 *	@param 	delegate    Handle Delegate
 *
 *	@return	N/A
 *
 *	Created by Mark on 2015-11-18 17:03
 */
+ (void)showAlertView:(NSString *)title
          withMessage:(NSString *)message
         withDelegate:(UIViewController<UIAlertViewDelegate> *)delegate;

@end
