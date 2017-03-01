//
//  NSString+MKValidateRegex.h
//  Pods
//
//  Created by Mark Yang on 11/24/15.
//
//

#import <Foundation/Foundation.h>

@interface NSString (MKValidateRegex)

/**
 *	@brief	验证是否是手机号码(仅限中国)
 *
 *	@return	验证结果
 *
 *	Created by Mark on 2015-11-24 15:45
 */
- (BOOL)validateMobileNumber;

/**
 *	@brief	手机号码格式验证(仅限中国)
 *
 *	@return	验证结果
 *
 *	Created by Mark on 2016-09-08 09:26
 */
- (BOOL)isMobile;

/**
 *	@brief	验证密码(6-20位)
 *
 *	@return 验证结果
 *
 *	Created by Mark on 2015-11-24 15:52
 */
- (BOOL)validatePassword;

/**
 *	@brief	验证是否Email
 *
 *	@return	验证结果
 *
 *	Created by Mark on 2015-11-24 15:55
 */
- (BOOL)validateEmail;

@end
