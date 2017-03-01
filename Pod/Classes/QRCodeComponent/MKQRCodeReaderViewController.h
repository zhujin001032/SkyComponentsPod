//
//  MKQRCodeViewController.h
//  Pods
//
//  Created by Mark Yang on 11/19/15.
//
//

#import <UIKit/UIKit.h>

@class MKQRCodeReaderViewController;
@class MKQRCodeReader;

#pragma mark -

@protocol MKQRCodeReaderViewControllerDelegate <NSObject>

@optional
- (void)reader:(MKQRCodeReaderViewController *)readerController didScanResult:(NSString *)result;
- (void)readerDidCancel:(MKQRCodeReaderViewController *)readerController;

@end

#pragma mark -

@interface MKQRCodeReaderViewController : UIViewController

@property (nonatomic, weak) id<MKQRCodeReaderViewControllerDelegate> __nullable delegate;
@property (nonatomic, strong, readonly) MKQRCodeReader * __nonnull              codeReader;

#pragma mark -

- (void)setCompletionBlock:(void (^)(NSString * _Nullable))completionBlock;

#pragma mark -

- (nonnull instancetype)initWithCancelButtonTitle:(nullable NSString *)cancelTitle
                                       codeReader:(nonnull MKQRCodeReader *)codeReader
                              startScanningAtLoad:(BOOL)startScanningAtLoad
                           showSwitchCameraButton:(BOOL)showSwitchCameraButton
                                  showTorchButton:(BOOL)showTorchButton;

- (void)setupUIComponentsWithCancelButtonTitle:(NSString *)cancelButtonTitle;
- (void)btnCancelEvent:(id)sender;
- (void)toggleTorch:(id)sender;

- (void)startScanning;
- (void)stopScanning;

@end
