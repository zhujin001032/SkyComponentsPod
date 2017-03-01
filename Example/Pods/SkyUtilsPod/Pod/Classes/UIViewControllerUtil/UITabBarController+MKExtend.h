//
//  UITabBarController+MKExtend.h
//  Pods
//
//  Created by Mark Yang on 12/7/15.
//
//

#import <UIKit/UIKit.h>

@interface UITabBarController (MKExtend)


@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

#pragma mark -

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

/**
 *	@brief	隐藏/显示TabBar
 *
 *	@return	N/A
 *
 *	Created by Mark on 2015-08-10 12:19
 */
- (void)hideTabBar:(BOOL)hidden;

@end
