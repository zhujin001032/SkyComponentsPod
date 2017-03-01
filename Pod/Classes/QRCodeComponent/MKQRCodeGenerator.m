//
//  MKQRCodeGenerator.m
//  Pods
//
//  Created by Mark Yang on 1/5/16.
//
//

#import "MKQRCodeGenerator.h"

@implementation MKQRCodeGenerator

+ (UIImage *)generateQRCodeWithInfo:(NSString *)strInfo
{
    return [MKQRCodeGenerator generateQRCodeWithInfo:strInfo withSize:100];
}//

+ (UIImage *)generateQRCodeWithInfo:(NSString *)strInfo withSize:(CGFloat)sideWidth
{
    if (strInfo.length < 1) {
        return nil;
    }
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [strInfo dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    UIImage *image = [MKQRCodeGenerator createNonInterpolatedUIImageFormCIImage:outputImage
                                                                       withSize:sideWidth];
    
    return image;
}//

//改变二维码大小
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

@end
