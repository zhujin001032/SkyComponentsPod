//
//  UITabBarItem+CustomBadge.h
//  CityGlance
//
//  Created by Enrico Vecchio on 18/05/14.
//  Copyright (c) 2014 Cityglance SRL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (CustomBadge)

/**
 *	@brief	设置自定义的badge value
 *  (font 13, white text color, gray background color)
 *
 *	@param 	value 	标值
 *
 *	@return	N/A
 *
 *	Created by Mark on 2015-11-27 10:56
 */
- (void)setMyAppCustomBadgeValue:(NSString *)value;

/**
 *	@brief	设置自定义的badge value
 *
 *	@param 	value 	badge value
 *	@param 	font 	text font
 *	@param 	color 	text color
 *	@param 	backColor 	background color
 *
 *	@return	N/A
 *
 *	Created by Mark on 2015-11-27 11:08
 */
- (void)setCustomBadgeValue:(NSString *)value
                   withFont:(UIFont *)font
               andFontColor:(UIColor *)color
         andBackgroundColor:(UIColor *)backColor;

@end
