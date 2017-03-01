//
//  UIImage+MKExtend.h
//  Pods
//
//  Created by Mark Yang on 12/4/15.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (MKExtend)

/**
 *	@brief	根据颜色值生成图片(w*h=1*1)
 *
 *	@param 	color 	颜色值
 *
 *	@return	生成的图片
 *
 *	Created by Mark on 2015-12-04 13:57
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *	@brief	<#Description#>
 *
 *	@param 	color 	<#color description#>
 *	@param 	size 	<#size description#>
 *	@param 	raduis 	<#raduis description#>
 *
 *	@return	<#return value description#>
 *
 *	Created by Mark on 2015-12-04 13:54
 */
+ (UIImage *)imageWithColor:(UIColor *)color
                   withSize:(CGSize)size
           withCornerRadius:(CGFloat)raduis;

/**
 *	@brief	毛玻璃模糊转换
 *
 *	@param 	image 	原始图片
 *	@param 	blur 	模糊比例
 *
 *	@return	转换后的模糊图片
 *
 *	Created by Mark on 2015-12-07 10:58
 */
+ (UIImage *)blurImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

#pragma mark -

+ (UIImage *)imageBlackToTransparent:(UIImage *)image;

@end
