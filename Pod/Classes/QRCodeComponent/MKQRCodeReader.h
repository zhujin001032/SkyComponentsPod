//
//  MKQRCodeReader.h
//  Pods
//
//  Created by Mark Yang on 11/19/15.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface MKQRCodeReader : NSObject

@property (nonatomic, strong, readonly) NSArray                     *metadataObjectTypes;
@property (nonatomic, strong, readonly) AVCaptureVideoPreviewLayer  *previewLayer;

#pragma mark -

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock;

#pragma mark -

/**
 *	@brief	检查是否支持QR Code扫描(iOS7.0+)
 *
 *	@param 	metadataObjectTypes 	支持类型
 *
 *	@return 是否支持标识
 *
 *	Created by Mark on 2015-11-19 16:34
 */
+ (BOOL)supportsMetadataObjectTypes:(NSArray *)metadataObjectTypes;

+ (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

#pragma mark -

+ (instancetype)readerWithMetadataObjectTypes:(NSArray *)metadataObjectTypes;

#pragma mark -

/**
 *	@brief	是否有前置摄相头
 *
 *	@return 是否有前置摄相头标识
 *
 *	Created by Mark on 2015-11-19 17:26
 */
- (BOOL)hasFrontDevice;

/**
 *	@brief	是否带有闪光灯装置
 *
 *	@return	闪光灯装置标识
 *
 *	Created by Mark on 2015-11-19 17:29
 */
- (BOOL)isTorchAvailable;

#pragma mark -
#pragma mark Control Reader

- (void)startScanning;
- (void)stopScanning;
- (BOOL)running;
- (void)switchDeviceInput;
- (void)toggleTorch;

/**
 *	@brief	设置扫描区域(基于Screen Size)
 *
 *	@param 	interestRect 	扫描区域的屏幕坐标
 *
 *	@return	N/A
 *
 *	Created by Mark on 2015-11-20 14:22
 */
- (void)setInterstRect:(CGRect)interestRect;

@end
