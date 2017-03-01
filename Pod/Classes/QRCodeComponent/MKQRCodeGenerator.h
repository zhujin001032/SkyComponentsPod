//
//  MKQRCodeGenerator.h
//  Pods
//
//  Created by Mark Yang on 1/5/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MKQRCodeGenerator : NSObject

+ (UIImage *)generateQRCodeWithInfo:(NSString *)strInfo;
+ (UIImage *)generateQRCodeWithInfo:(NSString *)strInfo withSize:(CGFloat)sideWidth;

@end
