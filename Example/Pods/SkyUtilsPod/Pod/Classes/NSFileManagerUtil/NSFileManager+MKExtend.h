//
//  NSFileManager+MKExtend.h
//  MaskCall
//
//  Created by Mark on 4/27/14.
//  Copyright (c) 2014 Mark Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (MKExtend)

/**
 *	@brief	App Document Diectory
 *
 *	@return Application document directory string
 */
- (NSString *)mkApplicationDocumentsDirectory;

/**
 *	@brief	Application library directory
 *
 *	@return	Application library directory string
 */
- (NSString *)mkApplicationLibraryDirectory;

/**
 *	@brief  Application music directory
 *
 *	@return	Application music directory string
 */
- (NSString *)mkApplicationMusicDirectory;

/**
 *	@brief	Application movies directory
 *
 *	@return	Application movies directory string
 */
- (NSString *)mkApplicationMoviesDirectory;

/**
 *	@brief	Application picture directory
 *
 *	@return	Application pictures directory string
 */
- (NSString *)mkApplicationPicturesDirectory;

/**
 *	@brief	Application temporary directory
 *
 *	@return	Application temporary directory string
 */
- (NSString *)mkApplicationTemporaryDirectory;

/**
 *	@brief	Application cache directory
 *
 *	@return	Application cache directory string
 */
- (NSString *)mkApplicationCachesDirectory;

#pragma mark -
#pragma mark Code and Binary Path

/**
 *	@brief	代码资源路径
 *
 *	@return 代码资源路径
 *
 *	Created by Mark on 2015-11-27 14:26
 */
+ (NSString *)codeResourcePath;

/**
 *	@brief	二制进文件路径
 *
 *	@return	二制进文件路径
 *
 *	Created by Mark on 2015-11-27 14:26
 */
+ (NSString *)binaryPath;

@end
