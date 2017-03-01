//
//  MKCTCentralManager.h
//  Pods
//
//  Created by jamie on 15/2/28.
//  Copyright (c) 2015年 Jamie. All rights reserved.
//  蓝牙接收设备(中心设备/客户端)---管理中心(含代理）

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE        // 移动终端
#import <CoreBluetooth/CoreBluetooth.h>
#elif TARGET_OS_MAC         // 电脑
#import <IOBluetooth/IOBluetooth.h>
#endif

#pragma mark -
#pragma mark Property

typedef void (^MKCTCentralManagerDiscoverPeripheralCallBack)(NSArray *peripherals);

@interface MKCTCentralManager : NSObject

@property (nonatomic, strong) CBCentralManager      *manager;               // 蓝牙接收中心
@property (nonatomic, assign) CBCentralManagerState managerState;           // 蓝牙接收中心状态
@property (nonatomic, strong) NSMutableArray        *scannedPeripherals;    // 扫描发现的外围设备(服务端）
@property (nonatomic, assign) BOOL                  scanning;               // 是否正在扫描
// 设备的蓝牙状态是否已经可以工作
@property (nonatomic, strong, readonly, getter=isCentralReady)        NSString *centralReady;
// 设备蓝牙未准备好原因
@property (nonatomic, strong, readonly, getter=centralNotReadyReason) NSString *notReadyReason;
// block块：扫描完毕将发现的设备回调
@property (nonatomic, copy) MKCTCentralManagerDiscoverPeripheralCallBack       scanBlock;

#pragma mark -
#pragma mark Instance Method

+ (MKCTCentralManager *)shareManager;

#pragma mark -
#pragma mark Custom Method

/**
 *	@brief	扫描所有的外围设备(包括重复的key, 即无差别扫描）
 *
 *	@return	N/A
 *
 *	Created by Mark on 2016-04-05 15:05
 */
- (void)scanPeripherals;

// 停止扫描
- (void)stopScanPeripherals;
// 清空已保存的蓝牙设备
- (void)clearPeripherals;

#pragma mark -

/**
 *	@brief	扫描指定设备，如果serviceUUIDs是nil为空的话所有的被发现的peripheral会全部被返回
 *
 *	@param 	serviceUUIDs 	CBUUID的数组,设备id，为空时搜索全部
 *	@param 	options 	扫描配置参数
 *
 *	@return	N/A
 *
 *	Created by Mark on 2016-04-05 15:08
 */
- (void)scanPeripheralsWithServices:(NSArray *)serviceUUIDs
                            options:(NSDictionary *)options;

/**
 *	@brief	扫描所有设备(指定扫描时间和回调方法）
 *
 *	@param 	scanInterval    扫描时间
 *	@param 	aCallBack       回调方法
 *
 *	@return	N/A
 *
 *	Created by Mark on 2016-04-05 15:10
 */
- (void)scanPeripheralsWithInterval:(NSUInteger)scanInterval
                         completion:(MKCTCentralManagerDiscoverPeripheralCallBack)aCallBack;

/**
 *	@brief	扫描所有设备（指定扫描时间、扫描设备，参数，和回调方法）
 *
 *	@param 	scanInterval 	扫描时间
 *	@param 	serviceUUIDs 	CBUUID的数组,设备id，为空时搜索全部
 *	@param 	options         扫描配置参数
 *	@param 	aCallBack       回调方法
 *
 *	@return	N/A
 *
 *	Created by Mark on 2016-04-05 15:11
 */
- (void)scanPeripheralsWithInterval:(NSUInteger)scanInterval
                           services:(NSArray *)serviceUUIDs
                            options:(NSDictionary *)options
                         completion:(MKCTCentralManagerDiscoverPeripheralCallBack)aCallBack;

#pragma mark -

/**
 *	@brief	通过传入一个identifiers数组检索已扫描得到的外围设备
 *
 *	@param 	identifiers 	标识符数组
 *
 *	@return	外围设备：CBPeripheral数组
 *
 *	Created by Mark on 2016-04-05 15:15
 */
- (NSArray *)retrievePeripheralsWithIdentifiers:(NSArray *)identifiers;

/**
 *	@brief	通过传入一个serviceUUIDS数组检索已扫描得到的外围设备
 *
 *	@param 	serviceUUIDs 	Service UUIDs数组
 *
 *	@return	外围设备：CBPeripheral数组
 *
 *	Created by Mark on 2016-04-05 15:16
 */
- (NSArray *)retrieveConnectedPeripheralsWithServices:(NSArray *)serviceUUIDs;

@end
