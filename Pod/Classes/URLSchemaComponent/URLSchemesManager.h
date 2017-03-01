//
//  URLSchemesManager.h
//  ThinkMail_iOS
//
//  Created by Mark on 11/4/13.
//  Copyright (c) 2013 RICHINFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLSchemesManager : NSObject

/**
 *	@brief	跳转打开指定URL的WebView
 *
 *	@param 	strURL 	WebView URL
 *
 *	@return N/A
 */
+ (void)openWebView:(NSString *)strURL;

/**
 *	@brief	调用系统功能呼出指定的电话号码
 *
 *	@param 	strNumber 	待呼出的电话号码
 *
 *	@return N/A
 */
+ (void)dail:(NSString *)strNumber;

+ (void)dailWithPrompt:(NSString *)strNumber;

/**
 *	@brief	调用系统功能进入到指定的电话号码短信编辑页
 *
 *	@param 	strNumber 	待发送信息的电话号码
 *
 *	@return N/A
 */
+ (void)sendMessage:(NSString *)strNumber;

@end
