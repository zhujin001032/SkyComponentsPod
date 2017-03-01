//
//  UIWindow+MKExtend.h
//  Pods
//
//  Created by Mark Yang on 12/3/15.
//
//

#import <UIKit/UIKit.h>

@interface UIWindow (MKExtend)

/**
 *	@brief	取得最上层的Window(用于正确的HubView显示)
 *
 *	@return UIWindow instance
 *
 *	Created by Mark on 2015-12-03 11:01
 */
+ (UIWindow *)lastWindow;

@end
