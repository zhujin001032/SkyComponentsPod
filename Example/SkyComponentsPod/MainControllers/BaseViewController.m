//
//  BaseViewController.m
//  SkyComponentsPod
//
//  Created by 何助金 on 16/3/18.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kHexRGB(0xFFFFFF);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing: YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
@end
