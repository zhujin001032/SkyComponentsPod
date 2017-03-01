//
//  SkyGraphicsLockViewController.m
//  SkyComponentsPod
//
//  Created by SimonLiu on 16/4/1.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import "SkyGraphicsLockViewController.h"
#import "CLLockVC.h"

@interface SkyGraphicsLockViewController ()

@end

@implementation SkyGraphicsLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self loadBtns];
}

- (void)loadBtns {
    
    CGFloat kLeftRightPadding = 50.0f;
    CGFloat btnW = SCREEN_WIDTH - 2*kLeftRightPadding;
    CGFloat btnH = 40;
    
    NSArray *titleArr = @[@"设置密码",@"验证密码",@"修改密码"];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        settingBtn.tag = 100 + i;
        settingBtn.frame = CGRectMake(kLeftRightPadding, (i + 1)* 100, btnW, btnH);
        [settingBtn setBackgroundColor:[UIColor orangeColor]];
        [settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [settingBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [settingBtn addTarget:self action:@selector(settingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:settingBtn];
    }
    
    
    
}

- (void)settingBtnClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 100: {
        // 设置密码
            BOOL hasPwd = [CLLockVC hasPwd];
            hasPwd = NO;
            if(hasPwd){
                
                NSLog(@"已经设置过密码了，你可以验证或者修改密码");
            }else{
                
                [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                    
                    NSLog(@"密码设置成功");
                    [lockVC dismiss:1.0f];
                }];
            }
           
        }
            break;
        case 101: {
        // 验证密码
            BOOL hasPwd = [CLLockVC hasPwd];
            
            if(!hasPwd){
                
                NSLog(@"你还没有设置密码，请先设置密码");
            }else {
                
                [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
                    NSLog(@"忘记密码");
                } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                    NSLog(@"密码正确");
                    [lockVC dismiss:1.0f];
                }];
            }

            
        }
            break;
        case 102: {
         // 修改密码
            BOOL hasPwd = [CLLockVC hasPwd];
            
            if(!hasPwd){
                
                NSLog(@"你还没有设置密码，请先设置密码");
                
            }else {
                
                [CLLockVC showModifyLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                    
                    [lockVC dismiss:.5f];
                }];
            }

        }
            break;
            
        default:
            break;
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}



@end
