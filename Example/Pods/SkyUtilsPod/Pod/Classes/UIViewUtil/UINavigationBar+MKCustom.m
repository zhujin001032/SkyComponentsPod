//
//  UINavigationBar+MKCustom.m
//  SkyUtils
//
//  Created by Mark Yang on 11/18/15.
//  Copyright © 2015 MissionSky. All rights reserved.
//

#import "UINavigationBar+MKCustom.h"

@implementation UINavigationBar (MKCustom)

- (void)customAppearance
{
    UIImage *imgOri = [UIImage imageNamed:@"nav_bk"];
    UIImage *imgStr = [imgOri stretchableImageWithLeftCapWidth:160 topCapHeight:5];
    [self setBackgroundImage:imgStr forBarMetrics:UIBarMetricsDefault];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return;
}//

- (void)customBackgroundImage:(NSString *)strImg
{
    UIImage *imgOri = [UIImage imageNamed:strImg];
    if (imgOri == nil) {
        return;
    }
    UIImage *imgStr = [imgOri stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    [self setBackgroundImage:imgStr forBarMetrics:UIBarMetricsDefault];
    
    return;
}//

- (void)customTitleColor:(UIColor *)titleColor
{
    if (titleColor == nil) {
        return;
    }
    NSDictionary *dic = @{NSForegroundColorAttributeName:titleColor};
    [self setTitleTextAttributes:dic];
    
    return;
}//

- (void)customTitleFont:(UIFont *)titleFont
{
    if (nil == titleFont) {
        return;
    }
    NSDictionary *dic = @{NSFontAttributeName:titleFont};
    [self setTitleTextAttributes:dic];
    
    return;
}//

@end
