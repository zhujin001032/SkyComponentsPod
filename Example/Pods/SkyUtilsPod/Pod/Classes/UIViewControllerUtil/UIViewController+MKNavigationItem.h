//
//  UIViewController+MKNavigationItem.h
//  SkyUtils
//
//  Created by Mark Yang on 11/18/15.
//  Copyright © 2015 MissionSky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MKNavigationItem)

/**
 *	@brief	自定义导航栏标题视图
 *
 *	@param 	titleView 	标题视图
 *
 *	@return	N/A
 *
 *	Created by Mark on 2015-11-18 17:46
 */
- (void)customNavigationTitleView:(UIView *)titleView;

/**
 *	@brief	自定义导航栏返回按钮(图片名称：backArrow, WH:24*44)
 *
 *	@param 	aSelector 	返回事件handle方法
 *
 *	@return	N/A
 *
 *	Created by Mark on 2015-11-18 17:52
 */
- (void)customBackItem:(SEL)aSelector;

@end
