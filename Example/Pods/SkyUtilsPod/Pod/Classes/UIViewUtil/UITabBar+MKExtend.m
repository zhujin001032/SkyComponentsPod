//
//  UITabBar+MKExtend.m
//  Pods
//
//  Created by Mark Yang on 12/7/15.
//
//

#import "UITabBar+MKExtend.h"

@implementation UITabBar (MKExtend)

- (void)customAppearance:(UIImage *)imgBK
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:imgBK];
    [imgView setFrame:self.bounds];
    [imgView setContentMode:UIViewContentModeScaleToFill];
    [self insertSubview:imgView atIndex:0];
    
    return;
}//

@end
