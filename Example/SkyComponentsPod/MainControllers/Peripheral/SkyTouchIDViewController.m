//
//  SkyTouchIDViewController.m
//  SkyComponentsPod
//
//  Created by 何助金 on 16/4/1.
//  Copyright © 2016年 Jason.He. All rights reserved.
//
#import "SkyTouchIDViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
static NSString *kPassword  = @"Password";
static NSString *kService   = @"com.msinner.components";

@interface SkyTouchIDViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    UITextView *_messageLogView;
}
@end

@implementation SkyTouchIDViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = @[@"检测是否支持TouchID",@"测试TouchID",@"测试TouchID自定义输入提示"];
    
    [self addTableView];
    [self addMessageLogView];
}

- (void)addMessageLogView{
    _messageLogView = [[UITextView alloc]initWithFrame:CGRectMake(0, _tableView.mkMaxY+10 , SCREEN_WIDTH,SCREEN_HEIGHT - 190 - 64)];
    [self.view addSubview:_messageLogView];
}
- (void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0 ,SCREEN_WIDTH, 180) style:UITableViewStylePlain];
    
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor grayColor];
    [self.view addSubview:_tableView];
}


#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            LAContext *context = [[LAContext alloc]init];
            
            NSError *error;
            BOOL success;
            success = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _messageLogView.text = [_messageLogView.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",@"该设备支持TouchID"]];
                    [_messageLogView scrollRangeToVisible:NSMakeRange(_messageLogView.text.length, 0)];
                });
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _messageLogView.text = [_messageLogView.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",@"该设备不支持TouchID！"]];
                    [_messageLogView scrollRangeToVisible:NSMakeRange(_messageLogView.text.length, 0)];
                });

            }
        }
            break;
        case 1:{
            LAContext *context = [[LAContext alloc]init];
            __block  NSString *message;
            
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"用于测试TouchId" reply:^(BOOL success, NSError * _Nullable error) {
                [self touchReplyWithSuccess:success withError:error withMessage:message];   
            }];
        }
            break;
        case 2:{
            LAContext *context = [[LAContext alloc]init];
            __block  NSString *message;
            context.localizedFallbackTitle = @"直接输入密码OK？";
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"用于测试TouchId" reply:^(BOOL success, NSError * _Nullable error) {
                [self touchReplyWithSuccess:success withError:error withMessage:message];
            }];

        }
            break;
        default:
            break;
    }
}

- (void)touchReplyWithSuccess:(BOOL)success withError:(NSError *)error withMessage:(NSString *)message{
    if (success) {
        message = @"指纹验证成功！";
    }else
    {
        if (error.code ==  kLAErrorUserFallback) {
            [self createAlertView];
            message = [NSString stringWithFormat:@"您选择输入密码方式"];
            
        }else{
            message = [NSString stringWithFormat:@"验证失败：%@",error.localizedDescription];
        }
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _messageLogView.text = [_messageLogView.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",message]];
        [_messageLogView scrollRangeToVisible:NSMakeRange(_messageLogView.text.length, 0)];
        
    });

}
- (void)createAlertView
{
    __block UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"测试TouchID" message:@"输入密码完成校验" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [alertView show];
    });
    return ;

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *text = [alertView textFieldAtIndex:0].text;
        NSString *password = [SSKeychain passwordForService:kService account:kPassword];

        if (text.length > 0 && password.length > 0) {
            if ([text isEqualToString:password]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _messageLogView.text = [_messageLogView.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",@"输入密码正确"]];
                    [_messageLogView scrollRangeToVisible:NSMakeRange(_messageLogView.text.length, 0)];
                    
                });
   
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _messageLogView.text = [_messageLogView.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",@"输入密码错误"]];
                    [_messageLogView scrollRangeToVisible:NSMakeRange(_messageLogView.text.length, 0)];
                    [self createAlertView];
                });

            }
        }else if (password == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                _messageLogView.text = [_messageLogView.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",@"没有设置密码，请先到新用户认证页面设置密码！！！"]];
                [_messageLogView scrollRangeToVisible:NSMakeRange(_messageLogView.text.length, 0)];
                
                
            });

        }
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _messageLogView.text = [_messageLogView.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",@"您取消了输入密码"]];
            [_messageLogView scrollRangeToVisible:NSMakeRange(_messageLogView.text.length, 0)];
            
        });
    }
}
@end
