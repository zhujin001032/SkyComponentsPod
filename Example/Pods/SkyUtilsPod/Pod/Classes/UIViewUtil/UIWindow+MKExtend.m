//
//  UIWindow+MKExtend.m
//  Pods
//
//  Created by Mark Yang on 12/3/15.
//
//

#import "UIWindow+MKExtend.h"

@implementation UIWindow (MKExtend)

+ (UIWindow *)lastWindow
{
    NSArray *windonws = [[UIApplication sharedApplication] windows];
    for (UIWindow *win in [windonws reverseObjectEnumerator]) {
        if ([win isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(win.bounds, [[UIScreen mainScreen] bounds])) {
            return win;
        }
    }
    
    return [[UIApplication sharedApplication] keyWindow];
}//

@end
