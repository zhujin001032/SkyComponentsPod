//
//  NSFileManager+MKExtend.m
//  MaskCall
//
//  Created by Mark on 4/27/14.
//  Copyright (c) 2014 Mark Studio. All rights reserved.
//

#import "NSFileManager+MKExtend.h"

@implementation NSFileManager (MKExtend)

- (NSString *)mkApplicationDocumentsDirectory;
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)mkApplicationLibraryDirectory;
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)mkApplicationMusicDirectory;
{
    return [NSSearchPathForDirectoriesInDomains(NSMusicDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)mkApplicationMoviesDirectory;
{
    return [NSSearchPathForDirectoriesInDomains(NSMoviesDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)mkApplicationPicturesDirectory;
{
    return [NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)mkApplicationTemporaryDirectory
{
    return NSTemporaryDirectory();
}

- (NSString *)mkApplicationCachesDirectory;
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Code and Binary Path

+ (NSString *)codeResourcePath
{
    NSString *excutableName = [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleExecutableKey];
    NSString *strAppDocDir = [[NSFileManager defaultManager] mkApplicationDocumentsDirectory];
    NSString *tmpPath = [strAppDocDir stringByDeletingLastPathComponent];
    NSString *appPath = [[tmpPath stringByAppendingPathComponent:excutableName]
                                  stringByAppendingPathExtension:@"app"];
    NSString *sigPath = [[appPath stringByAppendingPathComponent:@"_CodeSignature"]
                                  stringByAppendingPathComponent:@"CodeResources"];
    return sigPath;
}//

+ (NSString *)binaryPath
{
    NSString *excutableName = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
    NSString *strAppDocDir = [[NSFileManager defaultManager] mkApplicationDocumentsDirectory];
    NSString *tmpPath = [strAppDocDir stringByDeletingLastPathComponent];
    NSString *appPath = [[tmpPath stringByAppendingPathComponent:excutableName]
                                  stringByAppendingPathExtension:@"app"];
    NSString *binaryPath = [appPath stringByAppendingPathComponent:excutableName];
    
    return binaryPath;
}//

@end
