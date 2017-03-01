//
//  TelephonyManager.m
//  Pods
//
//  Created by Mark Yang on 8/9/15.
//
//

#import "TelephonyManager.h"

struct CTServerConnection *sc = NULL;
struct CTResult result;

void callback() {
}

@implementation TelephonyManager

//+ (NSString *)IMEI
//{
//#if TARGET_IPHONE_SIMULATOR
//    NSLog(@"模拟器没有此项!");
//    return nil;
//#else
//    NSString *imei;
//    _CTServerConnectionCopyMobileIdentity(&result, sc, &imei);
//    sc = _CTServerConnectionCreate(kCFAllocatorDefault, callback, NULL);
//    
//    return imei;
//#endif
//}// IMEI

@end
