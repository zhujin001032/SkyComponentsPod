//
//  URLSchemesManager.m
//  ThinkMail_iOS
//
//  Created by Mark on 11/4/13.
//  Copyright (c) 2013 RICHINFO. All rights reserved.
//

#import "URLSchemesManager.h"
#import <UIKit/UIKit.h>

@implementation URLSchemesManager

+ (void)openWebView:(NSString *)strURL
{
    NSURL *url = [NSURL URLWithString:strURL];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}// openWebView:(NSString *)strURL

+ (void)dail:(NSString *)strNumber
{
    if (strNumber.length < 1) {
        return;
    }
#if TARGET_IPHONE_SIMULATOR
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友好提示"
                                                    message:@"骚年,敢拿个真机测试不?"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
#else
    NSString *strDail = [NSString stringWithFormat:@"tel:%@", strNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strDail]];
#endif
    
    return;
}// dail:(NSString *)strNumber

+ (void)dailWithPrompt:(NSString *)strNumber
{
    if (strNumber.length < 1) {
        return;
    }
#if TARGET_IPHONE_SIMULATOR
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友好提示"
                                                    message:@"骚年,敢拿个真机测试不?"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
#else
    NSString *strDail = [NSString stringWithFormat:@"telprompt:%@", strNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strDail]];
#endif
    
    return;
}//

+ (void)sendMessage:(NSString *)strNumber
{
#if TARGET_IPHONE_SIMULATOR
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友好提示"
                                                    message:@"骚年,得瑟什么?真机!赶紧的!!!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
#else
    NSString *strSend = [NSString stringWithFormat:@"sms:%@", strNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strSend]];
#endif
    
    return;
}// sendMessage:(NSString *)strNumber

@end
