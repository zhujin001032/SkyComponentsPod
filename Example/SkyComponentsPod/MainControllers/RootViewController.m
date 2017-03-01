//
//  RootViewController.m
//  SkyComponentsPod
//
//  Created by Mark Yang on 3/16/16.
//  Copyright © 2016 Jason.He. All rights reserved.
//

#import "RootViewController.h"
#import "AppInfoViewController.h"
#import "SkyLandingPageTableViewController.h"
#import "SkyBubbleGuideViewController.h"
#import "SkySMSValidateViewController.h"
#import "SkyNetworkReachabilityViewController.h"
#import "SkyGraphicsLockViewController.h"
#import "SkyNewUserAuthenticationViewController.h"
#import "SkyNotificationViewController.h"
#import "SkyCameraViewController.h"
#import "SkyH5ChartViewController.h"
#import "SettingBundleViewController.h"
#import "SkyTouchIDViewController.h"
#import "SkySharingViewController.h"
#import "SkySSOViewController.h"
#import "TrackingViewController.h"
#import "OperationAnalyticViewController.h"
#import "SkyMapsDemoViewController.h"
#import "SkyGeoCodeViewController.h"
#import "SkyThirdReaderViewController.h"


static NSString *kTitleKey      = @"title";
static NSString *kCompletedKey  = @"completed";

@interface RootViewController ()

@property (nonatomic, strong) NSArray *arrSections;
@property (nonatomic, strong) NSArray *arrBasic;
@property (nonatomic, strong) NSArray *arrPeripheral;
@property (nonatomic, strong) NSArray *arrFunction;
@property (nonatomic, strong) NSArray *arrPayment;
@property (nonatomic, strong) NSArray *arrSecurity;
@property (nonatomic, strong) NSArray *arrWeChatPublic;
@property (nonatomic, strong) NSArray *arrTest;

@end

#pragma mark -

@implementation RootViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self setTitle:@"MissionSky Modules"];
        [self initData];
    }
    
    return self;
}//

- (void)initData
{
    NSLog(@"%@", NSLocalizedString(@"Basic", nil));
    _arrSections = @[NSLocalizedString(@"Basic", nil),
                     NSLocalizedString(@"Peripheral", nil),
                     NSLocalizedString(@"Function", nil),
                     NSLocalizedString(@"Payment", nil),
                     NSLocalizedString(@"Security", nil),
                     NSLocalizedString(@"WeChatPublic", nil),
                     NSLocalizedString(@"Test_Deployment", nil)];
    _arrBasic = @[[@{kTitleKey:NSLocalizedString(@"Landing", nil), kCompletedKey:@YES} mutableCopy],
                  [@{kTitleKey:NSLocalizedString(@"Bubble_Help", nil), kCompletedKey:@YES} mutableCopy],
                  [@{kTitleKey:NSLocalizedString(@"Version", nil), kCompletedKey:@YES} mutableCopy],
                  [@{kTitleKey:NSLocalizedString(@"NewUser", nil), kCompletedKey:@YES} mutableCopy],
                  [@{kTitleKey:NSLocalizedString(@"Notification", nil), kCompletedKey:@YES} mutableCopy],
                  [@{kTitleKey:NSLocalizedString(@"Tracking", nil), kCompletedKey:@YES} mutableCopy],
                  [@{kTitleKey:NSLocalizedString(@"Networking", nil), kCompletedKey:@YES} mutableCopy],
                  [@{kTitleKey:NSLocalizedString(@"Menu_Setting", nil), kCompletedKey:@YES} mutableCopy],
                  [@{kTitleKey:NSLocalizedString(@"SMS_Validate", nil), kCompletedKey:@YES} mutableCopy],
                  [@{kTitleKey:NSLocalizedString(@"Graph_Lock", nil), kCompletedKey:@YES} mutableCopy]];
    _arrPeripheral = @[[@{kTitleKey:NSLocalizedString(@"Camera", nil), kCompletedKey:@YES} mutableCopy],
                       [@{kTitleKey:NSLocalizedString(@"Bluetooth", nil), kCompletedKey:@NO} mutableCopy],
                       [@{kTitleKey:NSLocalizedString(@"Vibrator", nil), kCompletedKey:@NO} mutableCopy],
                       [@{kTitleKey:NSLocalizedString(@"GPS", nil), kCompletedKey:@YES} mutableCopy],
                       [@{kTitleKey:NSLocalizedString(@"WIFI", nil), kCompletedKey:@NO} mutableCopy],
                       [@{kTitleKey:NSLocalizedString(@"FingerMark", nil), kCompletedKey:@YES} mutableCopy]];
    _arrFunction = @[[@{kTitleKey:NSLocalizedString(@"H5Chart", nil), kCompletedKey:@YES} mutableCopy],
                     [@{kTitleKey:NSLocalizedString(@"Maps", nil), kCompletedKey:@YES} mutableCopy],
                     [@{kTitleKey:NSLocalizedString(@"3rd_Data", nil), kCompletedKey:@NO} mutableCopy],
                     [@{kTitleKey:NSLocalizedString(@"3rd_Reader", nil), kCompletedKey:@YES} mutableCopy],
                     [@{kTitleKey:NSLocalizedString(@"Sharing", nil), kCompletedKey:@YES} mutableCopy],
                     [@{kTitleKey:NSLocalizedString(@"SSO", nil), kCompletedKey:@YES} mutableCopy],
                     [@{kTitleKey:NSLocalizedString(@"Operation_Count", nil), kCompletedKey:@YES} mutableCopy],
                     [@{kTitleKey:NSLocalizedString(@"LiveVideo", nil), kCompletedKey:@NO} mutableCopy]];
    _arrPayment = @[[@{kTitleKey:NSLocalizedString(@"AliPay", nil), kCompletedKey:@NO} mutableCopy],
                    [@{kTitleKey:NSLocalizedString(@"WeChatPay", nil), kCompletedKey:@NO} mutableCopy],
                    [@{kTitleKey:NSLocalizedString(@"Paypal", nil), kCompletedKey:@NO} mutableCopy],
                    [@{kTitleKey:NSLocalizedString(@"ApplePay", nil), kCompletedKey:@NO} mutableCopy]];
    _arrSecurity = @[[@{kTitleKey:NSLocalizedString(@"LocalProperties", nil), kCompletedKey:@NO} mutableCopy],
                     [@{kTitleKey:NSLocalizedString(@"Decomplier", nil), kCompletedKey:@NO} mutableCopy],
                     [@{kTitleKey:NSLocalizedString(@"Socket", nil), kCompletedKey:@NO} mutableCopy],
                     [@{kTitleKey:NSLocalizedString(@"API_Call", nil), kCompletedKey:@NO} mutableCopy]];
    _arrWeChatPublic = @[[@{kTitleKey:NSLocalizedString(@"Online_Vote", nil), kCompletedKey:@NO} mutableCopy],
                         [@{kTitleKey:NSLocalizedString(@"Response", nil), kCompletedKey:@NO} mutableCopy],
                         [@{kTitleKey:NSLocalizedString(@"Messaging", nil), kCompletedKey:@NO} mutableCopy]];
    _arrTest = @[[@{kTitleKey:NSLocalizedString(@"AWS", nil), kCompletedKey:@NO} mutableCopy],
                 [@{kTitleKey:NSLocalizedString(@"Auto_Test", nil), kCompletedKey:@NO} mutableCopy],
                 [@{kTitleKey:NSLocalizedString(@"Auto_Deployment", nil), kCompletedKey:@NO} mutableCopy],
                 [@{kTitleKey:NSLocalizedString(@"Performance_Test", nil), kCompletedKey:@NO} mutableCopy]];
}//

- (void)viewDidLoad
{
    [super viewDidLoad];
}//

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrSections.count;
}//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case ModuleSection_Basic: {
            return _arrBasic.count;
        }
        case ModuleSection_Peripheral: {
            return _arrPeripheral.count;
        }
        case ModuleSection_Function: {
            return _arrFunction.count;
        }
        case ModuleSection_Payment: {
            return _arrPayment.count;
        }
        case ModuleSection_Security: {
            return _arrSecurity.count;
        }
        case ModuleSection_WeChatPublic: {
            return _arrWeChatPublic.count;
        }
        case ModuleSection_Test_Deployment: {
            return _arrTest.count;
        }
        default:
            break;
    }
    
    return 0;
}//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    NSArray *arrInfo = nil;
    switch (indexPath.section) {
        case ModuleSection_Basic: {
            arrInfo = _arrBasic;
            break;
        }
        case ModuleSection_Peripheral: {
            arrInfo = _arrPeripheral;
            break;
        }
        case ModuleSection_Function: {
            arrInfo = _arrFunction;
            break;
        }
        case ModuleSection_Payment: {
            arrInfo = _arrPayment;
            break;
        }
        case ModuleSection_Security: {
            arrInfo = _arrSecurity;
            break;
        }
        case ModuleSection_WeChatPublic: {
            arrInfo = _arrWeChatPublic;
            break;
        }
        case ModuleSection_Test_Deployment: {
            arrInfo = _arrTest;
            break;
        }
        default:
            break;
    }
    if (arrInfo.count > indexPath.row) {
        NSString *strText = arrInfo[indexPath.row][kTitleKey];
        [cell.textLabel setText:strText];
        BOOL isCompleted = [arrInfo[indexPath.row][kCompletedKey] boolValue];
        NSString *strDetail = isCompleted ? @"已完成" : @"未完成";
        UIColor  *color = isCompleted ? [UIColor greenColor] : [UIColor redColor];
        [cell.detailTextLabel setText:strDetail];
        [cell.detailTextLabel setTextColor:color];
    }
    
    return cell;
}//

#pragma mark -
#pragma mark UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _arrSections[section];
}//

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case ModuleSection_Basic: {
            switch (indexPath.row) {
                case BasicItem_Landing: {
                    SkyLandingPageTableViewController *landingPageTableVC = [[SkyLandingPageTableViewController alloc] initWithStyle:UITableViewStylePlain];
                    [landingPageTableVC setTitle:_arrBasic[indexPath.row][kTitleKey]];
                    [self.navigationController pushViewController:landingPageTableVC animated:YES];
                    break;
                }
                case BasicItem_Bubble: {
                    SkyBubbleGuideViewController *bubbleGuideVC = [[SkyBubbleGuideViewController alloc] init];
                    bubbleGuideVC.title = NSLocalizedString(@"Bubble_Help", nil);
                    [self.navigationController pushViewController:bubbleGuideVC animated:YES];
                    break;
                }
                case BasicItem_Graph_Lock: {
                    SkyGraphicsLockViewController *graphicsLockVC = [[SkyGraphicsLockViewController alloc] init];
                    graphicsLockVC.title = NSLocalizedString(@"Graph_Lock", nil);
                    [self.navigationController pushViewController:graphicsLockVC animated:YES];
                    break;
                }
                case BasicItem_SMS_Validate: {
                    SkySMSValidateViewController *smsValidateVC = [[SkySMSValidateViewController alloc] init];
                    [smsValidateVC setTitle:_arrBasic[indexPath.row][kTitleKey]];
                    [self.navigationController pushViewController:smsValidateVC animated:YES];
                    break;
                }
                case BasicItem_Networking: {
                    SkyNetworkReachabilityViewController *skyNetworkReachabilityVC = [[SkyNetworkReachabilityViewController alloc] init];
                    [skyNetworkReachabilityVC setTitle:NSLocalizedString(@"网络状态", nil)];
                    [self.navigationController pushViewController:skyNetworkReachabilityVC animated:YES];
                    break;
                }
                case BasicItem_Version: {
                    AppInfoViewController *appInfoController = [[AppInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    [appInfoController setTitle:_arrBasic[indexPath.row][kTitleKey]];
                    [self.navigationController pushViewController:appInfoController animated:YES];
                    break;
                }
                case BasicItem_NewUser:{
                    SkyNewUserAuthenticationViewController *newUserVC = [[SkyNewUserAuthenticationViewController alloc]init];
                    [newUserVC setTitle:_arrBasic[indexPath.row][kTitleKey]];
                    [self.navigationController pushViewController:newUserVC animated:YES];
                    break;
                }
                    
                case BasicItem_Notification:{
                    SkyNotificationViewController *notificationVC = [[SkyNotificationViewController alloc]init];
                    [notificationVC setTitle:_arrBasic[indexPath.row][kTitleKey]];
                    [self.navigationController pushViewController:notificationVC animated:YES];
                    break;
                }
                case BasicItem_Tracking: {
                    TrackingViewController *trackingVC = [[TrackingViewController alloc] init];
                    [trackingVC setTitle:_arrBasic[indexPath.row][kTitleKey]];
                    [self.navigationController pushViewController:trackingVC animated:YES];
                    break;
                }
                case BasicItem_Menu_Setting: {
                    SettingBundleViewController *settingBundleController = [[SettingBundleViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    [self.navigationController pushViewController:settingBundleController animated:YES];
                    break;
                }
            }
            break;
        }
        case ModuleSection_Peripheral:{
            switch (indexPath.row) {
                case PeripheralItem_Camera:
                {
                    SkyCameraViewController *cameraVC = [[SkyCameraViewController alloc]init];
                    [cameraVC setTitle:_arrPeripheral[indexPath.row][kTitleKey]];
                    [self.navigationController pushViewController:cameraVC animated:YES];
                    break;
                }
                case PeripheralItem_FingerMark:
                {
                    SkyTouchIDViewController *touchIdVC = [[SkyTouchIDViewController alloc]init];
                    [touchIdVC setTitle:_arrPeripheral[indexPath.row][kTitleKey]];
                    [self.navigationController pushViewController:touchIdVC animated:YES];
                    break;
                }
                case PeripheralItem_GPS: {
                    SkyGeoCodeViewController *geoCodeVC = [[SkyGeoCodeViewController alloc] init];
                    [geoCodeVC setTitle:_arrPeripheral[indexPath.row][kTitleKey]];
                    [self.navigationController pushViewController:geoCodeVC animated:YES];
                    break;
                }
                default:
                    break;
            }
        
        }
            break;
        case ModuleSection_Function:{
            switch (indexPath.row) {
                case FunctionItem_H5Chart: {
                    SkyH5ChartViewController *h5VC = [[SkyH5ChartViewController alloc]init];
                    [h5VC setTitle:_arrFunction[indexPath.row][kTitleKey]];
                    [self.navigationController pushViewController:h5VC animated:YES];
                    break;
                }
                    
                case FunctionItem_Sharing:{
                    SkySharingViewController *shareVC = [[SkySharingViewController alloc]init];
                    [shareVC setTitle:_arrFunction[indexPath.row][kTitleKey]];
                    [self.navigationController pushViewController:shareVC animated:YES];
                    break;
                    
                }
                case FunctionItem_Operation_Count: {
                    OperationAnalyticViewController *operationAnalyticVC = [[OperationAnalyticViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    [operationAnalyticVC setTitle:_arrFunction[indexPath.row][kTitleKey]];
                    [self.navigationController pushViewController:operationAnalyticVC animated:YES];
                    break;
                }
                    
                case FunctionItem_Maps: {
                    SkyMapsDemoViewController *mapsDemoVC = [[SkyMapsDemoViewController alloc] init];
                    [mapsDemoVC setTitle:_arrFunction[indexPath.row][kTitleKey]];
                    [self.navigationController pushViewController:mapsDemoVC animated:YES];
                    break;
            
                }
                    
                case FunctionItem_SSO:{
                    SkySSOViewController *ssoVC = [[SkySSOViewController alloc]init];
                    [ssoVC setTitle:_arrFunction[indexPath.row][kTitleKey]];
                    [self.navigationController pushViewController:ssoVC animated:YES];
                    
                    break;
                }
                case FunctionItem_3rd_Reader: {
                    SkyThirdReaderViewController *readerVC = [[SkyThirdReaderViewController alloc] init];
                    [readerVC setTitle:_arrFunction[indexPath.row][kTitleKey]];
                    [self.navigationController pushViewController:readerVC animated:YES];
                    break;
                }
                default:
                    break;
            }
            
        }
            break;

        default:
            break;
    }
}//

@end
