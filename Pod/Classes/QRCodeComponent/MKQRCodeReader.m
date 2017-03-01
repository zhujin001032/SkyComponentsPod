//
//  MKQRCodeReader.m
//  Pods
//
//  Created by Mark Yang on 11/19/15.
//
//

#import "MKQRCodeReader.h"

@interface MKQRCodeReader () <AVCaptureFileOutputRecordingDelegate,
                              AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureDevice            *defaultDevice;
@property (strong, nonatomic) AVCaptureDeviceInput       *defaultDeviceInput;
@property (strong, nonatomic) AVCaptureDevice            *frontDevice;
@property (strong, nonatomic) AVCaptureDeviceInput       *frontDeviceInput;
@property (strong, nonatomic) AVCaptureMetadataOutput    *metadataOutput;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (copy, nonatomic) void (^completionBlock) (NSString *);

#pragma mark -

+ (BOOL)isAvailable;

@end

#pragma mark -

@implementation MKQRCodeReader

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock
{
    _completionBlock = completionBlock;
}//

#pragma mark -

+ (BOOL)supportsMetadataObjectTypes:(NSArray *)metadataObjectTypes
{
    if (![self isAvailable]) {
        return NO;
    }
    
    @autoreleasepool {
        // Setup components
        AVCaptureDevice *captureDevice    = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
        AVCaptureMetadataOutput *output   = [[AVCaptureMetadataOutput alloc] init];
        AVCaptureSession *session         = [[AVCaptureSession alloc] init];
        
        [session addInput:deviceInput];
        [session addOutput:output];
        
        if (metadataObjectTypes == nil || metadataObjectTypes.count == 0) {
            // Check the QRCode metadata object type by default
            metadataObjectTypes = @[AVMetadataObjectTypeQRCode,             // 二维码
                                    AVMetadataObjectTypeEAN13Code,          // 条形码
                                    AVMetadataObjectTypeEAN8Code,
                                    AVMetadataObjectTypeCode128Code];
        }
        
        for (NSString *metadataObjectType in metadataObjectTypes) {
            if (![output.availableMetadataObjectTypes containsObject:metadataObjectType]) {
                return NO;
            }
        }
        
        return YES;
    }
}//

+ (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        default:
            return AVCaptureVideoOrientationPortraitUpsideDown;
    }
}

#pragma mark -

- (id)initWithMetadataObjectTypes:(NSArray *)metadataObjectTypes
{
    if ((self = [super init])) {
        _metadataObjectTypes = metadataObjectTypes;
        
        [self setupAVComponents];
        [self configureDefaultComponents];
    }
    return self;
}

+ (instancetype)readerWithMetadataObjectTypes:(NSArray *)metadataObjectTypes
{
    return [[self alloc] initWithMetadataObjectTypes:metadataObjectTypes];
}//

#pragma mark -

- (BOOL)hasFrontDevice
{
    return (_frontDevice != nil);
}//

- (BOOL)isTorchAvailable
{
    return _defaultDevice.hasTorch;
}//

#pragma mark -
#pragma mark Control Reader

- (void)startScanning
{
    if (![_session isRunning]) {
        [_session startRunning];
    }
}//

- (void)stopScanning
{
    if ([_session isRunning]) {
        [_session stopRunning];
    }
}//

- (BOOL)running
{
    return _session.running;
}//

- (void)switchDeviceInput
{
    if (_frontDeviceInput) {
        [_session beginConfiguration];
        
        AVCaptureDeviceInput *currentInput = [_session.inputs firstObject];
        [_session removeInput:currentInput];
        
        AVCaptureDeviceInput *newDeviceInput = (currentInput.device.position == AVCaptureDevicePositionFront) ?_defaultDeviceInput : _frontDeviceInput;
        [_session addInput:newDeviceInput];
        
        [_session commitConfiguration];
    }
}//

- (void)toggleTorch
{
    NSError *error = nil;
    [_defaultDevice lockForConfiguration:&error];
    if (nil == error) {
        AVCaptureTorchMode mode = _defaultDevice.torchMode;
        _defaultDevice.torchMode = (mode == AVCaptureTorchModeOn ? AVCaptureTorchModeOff : AVCaptureTorchModeOn);
    }
    [_defaultDevice unlockForConfiguration];
}//

- (void)setInterstRect:(CGRect)interestRect
{
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth  = [[UIScreen mainScreen] bounds].size.width;
    // 扫描区设置，按比例，右上角为原点，X,Y,W,H对调
    [_metadataOutput setRectOfInterest:CGRectMake (CGRectGetMinY(interestRect)/screenHeight,
                                                   ((screenWidth-CGRectGetWidth(interestRect))/2)/screenWidth ,
                                                   CGRectGetHeight(interestRect)/screenHeight,
                                                   CGRectGetWidth(interestRect)/screenWidth)];
}//

#pragma mark -
#pragma mark Initializing the AV Components

- (void)setupAVComponents
{
    _defaultDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (_defaultDevice) {
        _defaultDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_defaultDevice
                                                                    error:nil];
        _metadataOutput     = [[AVCaptureMetadataOutput alloc] init];
//        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
//        CGFloat screenWidth  = [[UIScreen mainScreen] bounds].size.width;
////         扫描区设置，按比例，右上角为原点，X,Y,W,H对调
//        [_metadataOutput setRectOfInterest:CGRectMake (124/screenHeight,
//                                                       ((screenWidth-220)/2)/screenWidth ,
//                                                       220/screenHeight,
//                                                       220/screenWidth)];
        _session            = [[AVCaptureSession alloc] init];
        _previewLayer       = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        
        for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
            if (device.position == AVCaptureDevicePositionFront) {
                _frontDevice = device;
            }
        }
        
        if (_frontDevice) {
            _frontDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_frontDevice
                                                                      error:nil];
        }
        
        
    }
}

#pragma mark 设置焦距 大于1
- (void)setFocalLength:(CGFloat)lengthScale {
    AVCaptureConnection *videoConnection =[_metadataOutput connectionWithMediaType:AVMediaTypeVideo];
    [UIView animateWithDuration:0.025 animations:^{
        [_previewLayer setAffineTransform:CGAffineTransformMakeScale(lengthScale, lengthScale)];
        videoConnection.videoScaleAndCropFactor = lengthScale;
    
    }];
    
}

- (void)configureDefaultComponents
{
    [_session addOutput:_metadataOutput];
    if (_defaultDeviceInput) {
        [_session addInput:_defaultDeviceInput];
    }
    [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_metadataOutput setMetadataObjectTypes:_metadataObjectTypes];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//    [self setFocalLength:2];
}

#pragma mark -
#pragma mark Private

+ (BOOL)isAvailable
{
    @autoreleasepool {
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (!captureDevice) {
            return NO;
        }
        
        NSError *error;
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        
        if (!deviceInput || error) {
            return NO;
        }
        
        return YES;
    }
}//

#pragma mark -
#pragma mark AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error
{
    return;
}//

#pragma mark -
#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
                                                                 fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *current in metadataObjects) {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]] &&
            [_metadataObjectTypes containsObject:current.type]) {
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *) current stringValue];
            if (_completionBlock) {
                _completionBlock(scannedResult);
            }
            
            break;
        }
    }
}//

@end
