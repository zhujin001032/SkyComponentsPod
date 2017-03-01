//
//  SkyViewController.m
//  SkyComponentsPod
//
//  Created by Jason.He on 06/16/2015.
//  Copyright (c) 2014 Jason.He. All rights reserved.
//

#import "SkyViewController.h"
#import <SkyComponentsPod/SkyComponents.h>
#import <SkyComponentsPod/MKHTTPManager.h>
#import <SkyComponentsPod/MKQRCodeReader.h>
#import <SkyComponentsPod/MKQRCodeReaderViewController.h>
#import <SkyComponentsPod/MKQRCodeGenerator.h>

@interface SkyViewController () <MKQRCodeReaderViewControllerDelegate>

@end

@implementation SkyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //应用示例
    [SkyComponentsInfo skyComponentsInfo];
	// Do any additional setup after loading the view, typically from a nib.
    
    // For TEST HTTP Manager
//    MKHTTPManager *httpManager = [MKHTTPManager manager];
//    [httpManager requestWithType:HTTPRequestType_GET
//                         withURL:@"http://localhost:63342/htdocs/GetTEST.php?a=123"
//                      withParams:@{@"a":@"HELLO"}
//                     withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                         NSString *strResponse = [[NSString alloc] initWithData:responseObject
//                                                                       encoding:NSUTF8StringEncoding];
//                         NSLog(@"Response : %@", strResponse);
//                     }
//                     withFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                         NSLog(@"Error : %@", error);
//                     }];
    
    UIButton *btnScan = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnScan setTitle:@"SCAN" forState:UIControlStateNormal];
    [btnScan setFrame:CGRectMake(0, 0, 100, 50)];
    [btnScan setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))];
    [btnScan setBackgroundColor:[UIColor grayColor]];
    [btnScan addTarget:self
                action:@selector(btnScanEvent:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnScan];
}

- (void)btnScanEvent:(id)sender
{
    // Generate a QRCode image
    NSString *str = @"http://www.baidu.com/";
    UIImage *image = [MKQRCodeGenerator generateQRCodeWithInfo:str];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [imageView setImage:image];
    [imageView setCenter:self.view.center];
    [self.view addSubview:imageView];
    
    return;
    
    NSArray *arrMetaObjectTypes = @[AVMetadataObjectTypeQRCode,             // 二维码
                                    AVMetadataObjectTypeEAN13Code,          // 条形码
                                    AVMetadataObjectTypeEAN8Code,
                                    AVMetadataObjectTypeCode128Code];
    if ([MKQRCodeReader supportsMetadataObjectTypes:arrMetaObjectTypes]) {
        static MKQRCodeReaderViewController *vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            MKQRCodeReader *reader = [MKQRCodeReader readerWithMetadataObjectTypes:arrMetaObjectTypes];
            [reader setInterstRect:CGRectMake(50, 124, 220, 220)];
            vc = [[MKQRCodeReaderViewController alloc] initWithCancelButtonTitle:@"CANCEL"
                                                                      codeReader:reader
                                                             startScanningAtLoad:YES
                                                          showSwitchCameraButton:NO
                                                                 showTorchButton:NO];
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        vc.delegate = self;
//        [vc setCompletionWithBlock:^(NSString *resultAsString) {
//            NSLog(@"Completion with result: %@", resultAsString);
//        }];
        
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Reader not supported by the current device"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
}//

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark MKQRCodeReaderViewControllerDelegate

- (void)reader:(MKQRCodeReaderViewController *)readerController didScanResult:(NSString *)result
{
    NSLog(@"Scen Result : %@", result);
}//

- (void)readerDidCancel:(MKQRCodeReaderViewController *)readerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}//

@end
