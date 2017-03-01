//
//  NSString+MKSDes.h
//  HKTTPhone
//
//  Created by Mark Yang on 1/25/15.
//  Copyright (c) 2015 Richinfo Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MKSDes)

/**
 *	@brief	根据指定DES_KEY加密指定明文
 *
 *	@param 	plainText 	明文信息
 *	@param 	key 	DES_KEY值
 *
 *	@return	DES加密后密文
 *
 *	Created by Mark on 2015-05-25 09:07
 */
+ (NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key;

/**
 *	@brief	根据指定DES_KEY解密指定密文
 *
 *	@param 	cipherText 	密文信息
 *	@param 	key 	DES_KEY值
 *
 *	@return	DES解密后明文
 *
 *	Created by Mark on 2015-05-25 09:07
 */
+ (NSString *)decryptUseDES:(NSString*)cipherText key:(NSString*)key;

@end
