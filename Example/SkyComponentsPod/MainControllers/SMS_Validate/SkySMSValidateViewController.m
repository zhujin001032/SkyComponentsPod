//
//  SkySMSValidateViewController.m
//  SkyComponentsPod
//
//  Created by SimonLiu on 16/3/23.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import "SkySMSValidateViewController.h"
#import "FirstPageViewController.h"
#import <SMS_SDK/SMSSDK.h>

static CGFloat kLeftPadding = 20.0f;

@interface SkySMSValidateViewController () <UITextFieldDelegate>

@property (nonatomic, weak) UIButton *sendButton;
@property (nonatomic, weak) UIButton *nextButton;
@property (nonatomic, weak) UITextField *phoneNumberField;
@property (nonatomic, weak) UITextField *verifyField;
@property (nonatomic, weak) NSTimer *finalCountTimer;
@property (nonatomic, assign) NSInteger finalCount;

@end

@implementation SkySMSValidateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    _finalCount = 60;
}

- (void)initUI {
    
    // 提示:目前只支持中国内地手机号码
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftPadding, 20, self.view.frame.size.width-2*kLeftPadding, 40)];
    noticeLabel.textColor = [UIColor lightGrayColor];
    noticeLabel.font = [UIFont systemFontOfSize:13.0];
    noticeLabel.numberOfLines = 0;
    noticeLabel.text = @"暂时只支持中国内地手机号码,相同号码每天最多发送5次";
    [self.view addSubview:noticeLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftPadding, CGRectGetMaxY(noticeLabel.frame)+kLeftPadding, 55, 30)];
    phoneLabel.textColor = [UIColor blackColor];
    phoneLabel.textAlignment = NSTextAlignmentRight;
    phoneLabel.font = [UIFont systemFontOfSize:13.0];
    phoneLabel.text = @"手机号码";
    [self.view addSubview:phoneLabel];
    
    // 手机号码输入框
    UITextField *phoneField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame)+10, CGRectGetMinY(phoneLabel.frame), SCREEN_WIDTH-75-kLeftPadding, 30)];
    phoneField.borderStyle = UITextBorderStyleBezel;
    phoneField.delegate = self;
    phoneField.font = [UIFont fontWithName:@"Helvetica-Italic" size:15.0];
    phoneField.textColor = [UIColor blackColor];
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneField];
    _phoneNumberField = phoneField;
    
    UILabel *verifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftPadding, CGRectGetMaxY(phoneLabel.frame)+kLeftPadding, 55, 30)];
    verifyLabel.textColor = [UIColor blackColor];
    verifyLabel.textAlignment = NSTextAlignmentRight;
    verifyLabel.font = [UIFont systemFontOfSize:13.0];
    verifyLabel.text = @"验证码";
    [self.view addSubview:verifyLabel];
    
    // 验证码输入框
    UITextField *verifyField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(verifyLabel.frame)+10, CGRectGetMinY(verifyLabel.frame), SCREEN_WIDTH-75-kLeftPadding-110, 30)];
    verifyField.borderStyle = UITextBorderStyleBezel;
    verifyField.delegate = self;
    verifyField.font = [UIFont fontWithName:@"Helvetica-Italic" size:15.0];
    verifyField.textColor = [UIColor blackColor];
    verifyField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:verifyField];
    _verifyField = verifyField;
    
    // 获取验证码按钮
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(CGRectGetMaxX(verifyField.frame)+10, CGRectGetMinY(verifyField.frame), 100, 30);
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [sendButton setBackgroundColor:[UIColor orangeColor]];
    [sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    _sendButton = sendButton;
    
    // 下一步按钮
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    nextButton.frame = CGRectMake(kLeftPadding, CGRectGetMaxY(sendButton.frame)+kLeftPadding, self.view.frame.size.width-2*kLeftPadding, 40);
    [nextButton setBackgroundColor:[UIColor lightGrayColor]];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
    // 默认不可用,在用户开始输入验证码后改变为可用状态
    nextButton.enabled = NO;
    [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    _nextButton = nextButton;
    
    // 获取验证码后需等待60s才可再次获取
    NSTimer *finalCountTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(finalCountBegin) userInfo:nil repeats:YES];
    [finalCountTimer setFireDate:[NSDate distantFuture]];
    _finalCountTimer = finalCountTimer;
    
}

- (void)sendButtonClick:(UIButton *)sender {
    
    // 校验用户输入的手机号码是否有效
    if (![self isMobile:_phoneNumberField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"友情提示", nil) message:@"手机号码有误,请重新输入" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // 调用SMS_SDK获取验证码的方法
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneNumberField.text zone:@"86" customIdentifier:@"SkyComponents" result:^(NSError *error) {
        if (!error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"友情提示", nil) message:[NSString stringWithFormat:@"验证码已发送至%@",_phoneNumberField.text] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            _sendButton.backgroundColor = [UIColor lightGrayColor];
            _sendButton.enabled = NO;
            [_finalCountTimer setFireDate:[NSDate date]];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"友情提示", nil) message:@"获取验证码失败,请稍后再试" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
}

#pragma mark - 获取验证码后进入60s倒计时
- (void)finalCountBegin {
    if (_finalCount > 0) {
        _finalCount--;
        _sendButton.backgroundColor = [UIColor lightGrayColor];
        _sendButton.enabled = NO;
        [_sendButton setTitle:[NSString stringWithFormat:@"%zds",_finalCount] forState:UIControlStateDisabled];
    } else {
        _finalCount = 60;
        [_finalCountTimer setFireDate:[NSDate distantFuture]];
        _sendButton.backgroundColor = [UIColor orangeColor];
        _sendButton.enabled = YES;
        [_sendButton setTitle:NSLocalizedString(@"再次获取", nil) forState:UIControlStateNormal];
    }
    
}

- (void)nextButtonClick:(UIButton *)sender {
    
    // 调用SMS_SDK提交验证码的方法
    [SMSSDK commitVerificationCode:_verifyField.text phoneNumber:_phoneNumberField.text zone:@"86" result:^(NSError *error) {
        if (!error) {
            FirstPageViewController *firstPageVC = [[FirstPageViewController alloc] init];
            [self.navigationController pushViewController:firstPageVC animated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"友情提示", nil) message:@"验证码错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    
}

/**
 *  手机号码验证
 *
 *  @param mobileNumbel 传入的手机号码
 *
 *  @return 格式正确返回true  错误 返回fals
 */
- (BOOL)isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码(内容引用百度百科手机号词条)
     * 移动：134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,182,183,184,187,188
     * 联通：130,131,132,145(上网卡),152,155,156,185,186
     * 电信：133,1349(卫星电话),153,180,189,181
     * 4G号段:170:[1700/1701/1702(电信)、1705(移动)、1707/1708/1709(联通)]、176(联通)、177(电信)、178(移动)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[0-9]|7[06-8]|47)\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[0127-9]|8[23478]|47)\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[56]|8[56]|45)\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    
    return NO;
}

#pragma mark - textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == _phoneNumberField) {
        if (_finalCount == 60) {
            _sendButton.backgroundColor = [UIColor orangeColor];
            _sendButton.enabled = YES;
        }
    } else if (textField == _verifyField && _phoneNumberField.text.length > 0) {
        _nextButton.backgroundColor = [UIColor orangeColor];
        _nextButton.enabled = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




@end
