//
//  UIColor+MKHex.h
//  SkyUtils
//
//  Created by Mark Yang on 11/18/15.
//  Copyright © 2015 MissionSky. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) \
                                                  green:((g) / 255.0) \
                                                   blue:((b) / 255.0) \
                                                  alpha:1.0]
#define kRGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) \
                                                  green:((g) / 255.0) \
                                                   blue:((b) / 255.0) \
                                                  alpha:(a)]

#define kHexRGB(rgbValue)         [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                  green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                   blue:((float)(rgbValue & 0xFF))/255.0 \
                                                  alpha:1.0]
#define kHexRGBAlpha(rgbValue,a)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                  green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                   blue:((float)(rgbValue & 0xFF))/255.0 \
                                                  alpha:(a)]

#pragma mark -
#pragma mark C Style Methods

/**
 *	@brief	获取十六进制RGB值代表的颜色 (如：#FEFEFE, 无透明度值)
 *
 *	@param 	colorHex	十六进制RGB值 (如：#FEFEFE)
 *
 *	@return	UIColor实例
 *
 *	Created by Mark on 2015-08-06 10:11
 */
UIColor * UIColorFromHex(NSInteger colorHex);

/**
 *	@brief 获取十六进制RGB值及相应透明度代表的颜色  (如：#FEFEFE, 透明度值在0.0-1.0之间)
 *
 *	@param 	colorHex 	十六进制RGB值 (如：#FEFEFE)
 *	@param 	aph     透明度值(0.0-1.0)
 *
 *	@return	UIColor实例
 *
 *	Created by Mark on 2015-08-06 10:48
 */
UIColor * UIColorFromHexAndAphla(NSInteger colorHex, float aph);

#pragma mark -
#pragma mark Objective-C Style Methods

@interface UIColor (MKHex)

/**
 *	@brief	获取十六进制RGB值代表的颜色
 *
 *	@param 	hex     十六进制RGB值 (如：#FEFEFE)
 *
 *	@return	UIColor实例
 */
+ (UIColor *)colorWithLongHex:(long)hex;

/**
 *	@brief	获取十六进制RGB值及相应透明度代表的颜色
 *
 *	@param 	hex 	十六进制RGB值 (如：#FEFEFE)
 *	@param 	aph 	透明度(0.0 -1.0)
 *
 *	@return	UIColor实例
 */
+ (UIColor *)colorWithLongHex:(long)hex alpha:(float)aph;

@end
