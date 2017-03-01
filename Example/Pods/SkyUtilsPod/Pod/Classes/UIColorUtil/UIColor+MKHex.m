//
//  UIColor+MKHex.m
//  SkyUtils
//
//  Created by Mark Yang on 11/18/15.
//  Copyright © 2015 MissionSky. All rights reserved.
//

#import "UIColor+MKHex.h"

#pragma mark -
#pragma mark C Style Methods

UIColor *UIColorFromHex(NSInteger colorHex)
{
    return UIColorFromHexAndAphla(colorHex, 1.0);
}//

UIColor *UIColorFromHexAndAphla(NSInteger colorHex, float aph)
{
    UIColor *color = [UIColor colorWithRed:((float)((colorHex & 0xFF0000) >> 16)) / 0xFF
                                     green:((float)((colorHex & 0xFF00) >> 8))    / 0xFF
                                      blue:((float)(colorHex & 0xFF))             / 0xFF
                                     alpha:aph];
    return color;
}//

#pragma mark -
#pragma mark Objective-C Style Methods

@implementation UIColor (MKHex)

+ (UIColor *)colorWithLongHex:(long)hex;
{
    return [UIColor colorWithLongHex:hex alpha:1.0f];
}//

+ (UIColor *)colorWithLongHex:(long)hex alpha:(float)aph
{
    float red = (float) ((hex & 0xFF0000) >> 16) / 0xFF ;
    float green = (float) ((hex & 0xFF00) >> 8) / 0xFF;
    float blue = (float) (hex & 0xFF) / 0xFF;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:aph];
}//

@end
