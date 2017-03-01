//
//  MKCTCentralManager.m
//  Pods
//
//  Created by Mark Yang on 4/5/16.
//
//

#import "MKCTCentralManager.h"

@implementation MKCTCentralManager

- (BOOL)isCentralReady
{
    return (_manager.state == CBCentralManagerStatePoweredOn);
}//

- (NSString *)centralNotReadyReason
{
    return [self stateMessage];
}//

#pragma mark -
#pragma mark Private Methods

- (NSString *)stateMessage
{
    NSString *message = nil;
    switch (_manager.state) {
        case CBCentralManagerStateUnsupported: {
            message = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        }
        case CBCentralManagerStateUnauthorized: {
            message = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        }
        case CBCentralManagerStateUnknown: {
            message = @"Central not initialized yet.";
            break;
        }
        case CBCentralManagerStatePoweredOff: {
            message = @"Bluetooth is currently powered off.";
            break;
        }
        case CBCentralManagerStatePoweredOn: {
            break;
        }
        default:
            break;
    }
    
    return message;
}//

#pragma mark -
#pragma mark Instance Method

+ (MKCTCentralManager *)shareManager
{
    static MKCTCentralManager *__shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shareManager = [[MKCTCentralManager alloc] init];
    });
    
    return __shareManager;
}//

#pragma mark -
#pragma mark Custom Method

- (void)scanPeripherals
{
    // 允许扫描已经存在的重复的key
    [self scanPeripheralsWithServices:nil
                              options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
}//

// 停止扫描
- (void)stopScanPeripherals
{
    _scanning = NO;
    [_manager stopScan];
    // 取消可能存在的延时取消方法
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(stopScanPeripherals)
                                               object:nil];
}//

// 清空已保存的蓝牙设备
- (void)clearPeripherals
{
    return;
}//

@end
