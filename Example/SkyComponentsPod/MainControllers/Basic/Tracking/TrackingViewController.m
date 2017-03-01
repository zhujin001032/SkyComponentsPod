//
//  TrackingViewController.m
//  SkyComponentsPod
//
//  Created by Mark Yang on 4/5/16.
//  Copyright © 2016 Jason.He. All rights reserved.
//

#import "TrackingViewController.h"

@interface TrackingViewController ()

@end

@implementation TrackingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}//

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat fMargin = 20;
    UILabel *lbTip = [[UILabel alloc] initWithFrame:CGRectMake(fMargin,
                                                               0,
                                                               CGRectGetWidth(self.view.bounds)-2*fMargin,
                                                               100)];
    [lbTip setFont:[UIFont systemFontOfSize:15.0]];
    [lbTip setTextAlignment:NSTextAlignmentCenter];
    [lbTip setNumberOfLines:0];
    [lbTip setText:@"进入此页面停留后退出，即可统计到该页面路径相关信息"];
    [lbTip setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))];
    [self.view addSubview:lbTip];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Demo For Tracking

// 页面统计集成正确，才能够获取正确的页面访问路径、访问深度（PV）的数据
// 在特定应用的“功能应用”页面可查询此项数据
// beginLogPageView and endLogPageView must be couple
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}//

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}//

@end
