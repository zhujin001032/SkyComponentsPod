//
//  UIDevice+MKResolution.h
//  Pods
//
//  Created by Mark Yang on 12/7/15.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MKSUIDeviceResolution) {
    UIDevice_iPhoneStandardRes      = 1,    // iPhone 1,3,3GS 标准分辨率(320x480px)
    UIDevice_iPhoneHiRes            = 2,    // iPhone 4,4S 高清分辨率(640x960px)
    UIDevice_iPhoneTallerHiRes      = 3,    // iPhone 5+ 高清分辨率(640x1136px)
    UIDevice_iPadStandardRes        = 4,    // iPad 1,2 标准分辨率(1024x768px)
    UIDevice_iPadHiRes              = 5,    // iPad 3 High Resolution(2048x1536px)
    // Waiting for extend...
};

@interface UIDevice (MKResolution)

/**
 *	@brief	当前分辨率
 *
 *	@return 当前分辨率类型
 *
 *	Created by Mark on 2014-06-10 22:56
 */
+ (MKSUIDeviceResolution)currentResolution;

/**
 *	@brief	当前是否运行在iPhone5端
 *
 *	@return 是否运行在iPhone5端标识
 *
 *	Created by Mark on 2014-06-10 22:56
 */
+ (BOOL)isRunningOniPhone5;

/**
 *	@brief	当前是否运行在iPhone端
 *
 *	@return 是否运行在iPhone端标识
 *
 *	Created by Mark on 2014-06-10 22:57
 */
+ (BOOL)isRunningOniPhone;

@end
