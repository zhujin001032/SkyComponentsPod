//
//  SkyBubleGuideViewController.m
//  SkyComponentsPod
//
//  Created by SimonLiu on 16/3/31.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import "SkyBubbleGuideViewController.h"
#import "SkyADLandingPageView.h"


@interface SkyBubbleGuideViewController ()

@property (nonatomic, assign) NSInteger bubbleNumber;  // 记录气泡图片的顺序
@property (nonatomic, weak) UIImageView *bgImageView;
@property (nonatomic, weak) UIImageView *bubbleImageView;
@property (nonatomic, weak) UIButton    *lastSelectedButton;

@end

@implementation SkyBubbleGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavigationItem];
    [self initUI];
    [self showGuideBubble];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
}


- (void)loadNavigationItem {
    
    UIButton *rightItemBtn  = [UIButton buttonWithType:UIButtonTypeSystem];
    rightItemBtn.frame = CGRectMake(0, 11, 22, 22);
    [rightItemBtn setBackgroundImage:[UIImage imageNamed:@"safari_logo.png"] forState:UIControlStateNormal];
    [rightItemBtn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
}

- (void)initUI {
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _bgImageView = bgImageView;
    [self.view addSubview:bgImageView];
    _bgImageView.image = [UIImage imageNamed:@"about_us.png"];
    NSArray *titleArr = @[@"关于我们",@"成功案例",@"联系我们"];
    CGFloat btnX = 0.0;
    CGFloat btnY = self.view.frame.size.height - 49 - 64;
    CGFloat btnW = SCREEN_WIDTH / 3;
    CGFloat btnH = 49;
    
    for (NSInteger i = 0; i< 3; i++) {
        UIButton *btnItem = [UIButton buttonWithType:UIButtonTypeSystem];
        btnItem.frame = CGRectMake(btnX, btnY, btnW, btnH);
        btnItem.tag = 1000 + i;
        [btnItem setBackgroundColor:[UIColor lightGrayColor]];
        [btnItem setTitle:titleArr[i] forState:UIControlStateNormal];
        [btnItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnItem];
        btnX += btnW;
    }
    
    UIButton *firstBtn = (UIButton *)[self.view viewWithTag:1000];
    [self btnItemClick:firstBtn];
    
}

- (void)showGuideBubble {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bubbleImageView.backgroundColor = [UIColor clearColor];
    bubbleImageView.image = [UIImage imageNamed:@"guideBubble1.png"];
    _bubbleImageView = bubbleImageView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    _bubbleImageView.userInteractionEnabled = YES;
    [_bubbleImageView addGestureRecognizer:tap];
    [keyWindow addSubview:bubbleImageView];
    [keyWindow bringSubviewToFront:bubbleImageView];

}

- (void)btnItemClick:(UIButton *)sender {
    if (sender == _lastSelectedButton) {
        return;
    }
    _lastSelectedButton.backgroundColor = [UIColor lightGrayColor];
    _lastSelectedButton = sender;
    switch (sender.tag - 1000) {
        case 0:
        {
            sender.backgroundColor = [UIColor orangeColor];
            _bgImageView.image = [UIImage imageNamed:@"about_us.png"];
        }
            break;
        case 1:
        {
            sender.backgroundColor = [UIColor orangeColor];
             _bgImageView.image = [UIImage imageNamed:@"success_case.png"];
        }
            break;
        case 2:
        {
            sender.backgroundColor = [UIColor orangeColor];
             _bgImageView.image = [UIImage imageNamed:@"contact_us.png"];
        }
            break;
        default:
            break;
    }
    
    
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    
    _bubbleNumber++;
    NSArray *bubbleImageArr = @[@"guideBubble1.png",@"guideBubble2.png",@"guideBubble3.png",@"guideBubble4.png",@"guideBubble5.png"];
    if (_bubbleNumber < 5) {
        _bubbleImageView.image = [UIImage imageNamed:bubbleImageArr[_bubbleNumber]];
    } else {
        [_bubbleImageView removeAllSubViews];
        [_bubbleImageView removeFromSuperview];
    }
 
}

- (void)rightItemClick:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.missionsky.com"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
