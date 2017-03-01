//
//  SkyNetworkReachabilityViewController.m
//  SkyComponentsPod
//
//  Created by SimonLiu on 16/3/25.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import "SkyNetworkReachabilityViewController.h"

static CGFloat kLeftPadding = 15.0f;
static NSString *kReachabilityChangedNotification = @"kReachabilityChangedNotification";

@interface SkyNetworkReachabilityViewController ()

@property (nonatomic, strong) MKNetworkReachability * internetConnectionReach;
@property (nonatomic, weak  ) UITextField     *addressField;
@property (nonatomic, weak  ) UIButton        *startConnectButton;
@property (nonatomic, weak  ) UILabel         *resultLabel;

- (void)reachabilityChanged:(NSNotification*)note;

@end

@implementation SkyNetworkReachabilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
}

- (void)initUI {
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftPadding, 20, 80, 30)];
    addressLabel.text = @"测试地址";
    addressLabel.textColor = [UIColor blackColor];
    addressLabel.font = [UIFont systemFontOfSize:15.0];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:addressLabel];
    
    // 输入网络地址用来测试网络连接状态
    UITextField *addressField = [[UITextField alloc] initWithFrame:CGRectMake(kLeftPadding, CGRectGetMaxY(addressLabel.frame), SCREEN_WIDTH-2*kLeftPadding, 40)];
    addressField.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    addressField.borderStyle = UITextBorderStyleBezel;
    addressField.text = @"www.baidu.com";
    [self.view addSubview:addressField];
    _addressField = addressField;
    
    UIButton *startConnectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    startConnectButton.frame = CGRectMake(kLeftPadding, CGRectGetMaxY(addressField.frame)+10, SCREEN_WIDTH-2*kLeftPadding, 40);
    startConnectButton.backgroundColor = [UIColor orangeColor];
    [startConnectButton setTitle:@"开始连接" forState:UIControlStateNormal];
    [startConnectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startConnectButton addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startConnectButton];
    _startConnectButton = startConnectButton;
    
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftPadding, CGRectGetMaxY(startConnectButton.frame)+10, SCREEN_WIDTH-2*kLeftPadding, 60)];
    resultLabel.numberOfLines = 0;
    resultLabel.contentMode = UIViewContentModeTopLeft;
    resultLabel.text = @"当前网络状态: 等待连接";
    [self.view addSubview:resultLabel];
    _resultLabel = resultLabel;
    
}

- (void)startButtonClick:(UIButton *)sender {
    
    // 检验测试地址是否为空
    if (!_addressField.text.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"测试地址不能为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    _resultLabel.text = @"正在连接";
    _startConnectButton.backgroundColor = [UIColor lightGrayColor];
    _startConnectButton.enabled = NO;
    
    _internetConnectionReach = [MKNetworkReachability reachabilityWithHostname:_addressField.text];
    __weak typeof(self) weakSelf = self;
    _internetConnectionReach.notifyBlock = ^(MKNetworkReachability *reach){
        weakSelf.startConnectButton.backgroundColor = [UIColor orangeColor];
        weakSelf.startConnectButton.enabled = YES;
        [weakSelf changeResult:weakSelf.internetConnectionReach];
    };
}

- (void)reachabilityChanged:(NSNotification *)note {
    MKNetworkReachability *reach = [note object];
    [self changeResult:reach];
}

- (void)changeResult:(MKNetworkReachability *)reach {
    
    __weak typeof(self) weakSelf = self;
    switch (reach.status) {
        case MKNetworkReachabilityStatusNone:
            weakSelf.resultLabel.text = @"当前网络状态: 无法连接";
            break;
        case MKNetworkReachabilityStatusWiFi:
            weakSelf.resultLabel.text = @"当前网络状态: WiFi";
            break;
        case MKNetworkReachabilityStatusWWAN:
        {
            switch (reach.wwanStatus) {
                case MKNetworkWWANStatus2G:
                    weakSelf.resultLabel.text = @"当前网络状态: 2G";
                    break;
                case MKNetworkWWANStatus3G:
                    weakSelf.resultLabel.text = @"当前网络状态: 3G";
                    break;
                case MKNetworkWWANStatus4G:
                    weakSelf.resultLabel.text = @"当前网络状态: 4G";
                    break;
                default:
                    weakSelf.resultLabel.text = @"当前网络状态: 移动蜂窝网络";
                    break;
            }
        }
        default:
            break;
            
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
