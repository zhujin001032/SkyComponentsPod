//
//  UIViewController+MKAlert.m
//  SkyUtils
//
//  Created by Mark Yang on 11/18/15.
//  Copyright © 2015 MissionSky. All rights reserved.
//

#import "UIViewController+MKAlert.h"

@implementation UIViewController (MKAlert)

+ (void)showAlertView:(NSString *)title withMessage:(NSString *)message
{
    [self showAlertView:title
            withMessage:message
           withDelegate:nil];
}//

+ (void)showAlertView:(NSString *)title
          withMessage:(NSString *)message
         withDelegate:(UIViewController<UIAlertViewDelegate> *)delegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:delegate
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    });
}//

@end
