//
//  UINavigationBar+MKCustom.h
//  SkyUtils
//
//  Created by Mark Yang on 11/18/15.
//  Copyright © 2015 MissionSky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (MKCustom)

/**
 *	@brief	自定义导航栏背景色
 *  (需要手动加入背景色图片，命名：'nav_bk_img'， WH=320*10)
 *
 *	@return	N/A
 *
 *	Created by Mark on 2015-08-06 10:08
 */
- (void)customAppearance;

/**
 *	@brief 根据图片名自定义导航栏背景色(Cap Size : 1:1, WH=2*2)
 *
 *	@param 	strImg 	背景图片名(In Bundle Source)
 *
 *	@return	N/A
 *
 *	Created by Mark on 2014-05-18 09:16
 */
- (void)customBackgroundImage:(NSString *)strImg;

/**
 *	@brief	自定义导航栏标题颜色
 *
 *	@param 	titleColor 	标题颜色
 *
 *	@return	N/A
 *
 *	Created by Mark on 2014-05-18 09:20
 */
- (void)customTitleColor:(UIColor *)titleColor;

/**
 *	@brief  自定义导航栏标题字体
 *
 *	@param 	titleFont   标题字体
 *
 *	@return	N/A
 *
 *	Created by Mark on 2015-11-18 17:26
 */
- (void)customTitleFont:(UIFont *)titleFont;

@end
