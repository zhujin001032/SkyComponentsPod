//
//  FirstPageViewController.m
//  SkyComponentsPod
//
//  Created by SimonLiu on 16/3/18.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import "FirstPageViewController.h"
#import "SkyADLandingPageView.h"
#import "SkyAnimateLandingPageView.h"
#import "SkyGuideView.h"

@interface FirstPageViewController ()

@end

@implementation FirstPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitle];
    [self initBackground];
    [self loadLandingPage];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)initBackground {
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"about_us.png"];
    [self.view addSubview:bgImageView];
}

- (void)initTitle {
    switch (self.landingPageType) {
        case LandingPageTypeAD:
            self.title = NSLocalizedString(@"静态广告", nil);
            break;
        case LandingPageTypeScroll:
            self.title = NSLocalizedString(@"滑动引导", nil);
        case LandingPageTypeGIF:
            self.title = NSLocalizedString(@"动态图片", nil);
        default:
            break;
    }
}

- (void)loadLandingPage {
      switch (self.landingPageType) {
        case LandingPageTypeAD:
        {
            SkyADLandingPageView *adLandingPageView = [[SkyADLandingPageView alloc] initWithFrame:self.view.bounds];
            __weak typeof(self) weakSelf = self;
            adLandingPageView.disappearHandler = ^{
                weakSelf.navigationController.navigationBarHidden = NO;
            };
            [adLandingPageView showInView:self.view adImage:[UIImage imageNamed:@"ad_accela.png"]];
        }
            break;
        case LandingPageTypeScroll:
        {
            SkyGuideView *guideView = [[SkyGuideView alloc] initWithFrame:self.view.bounds Images:@[[UIImage imageNamed:@"guide1.png"],[UIImage imageNamed:@"guide2.png"],[UIImage imageNamed:@"guide3.png"]]];
            [guideView showInView:self.view];
            __weak typeof(self) weakSelf = self;
            guideView.disappearHandler = ^{
                weakSelf.navigationController.navigationBarHidden = NO;
            };
        }
            break;
        case LandingPageTypeGIF:
        {
            SkyAnimateLandingPageView *animateLandingPageView = [[SkyAnimateLandingPageView alloc] initWithFrame:self.view.frame];
            __weak typeof(self) weakSelf = self;
            animateLandingPageView.disappearHandler = ^{
                weakSelf.navigationController.navigationBarHidden = NO;
            };
            NSString *animateImagePath = [[NSBundle mainBundle] pathForResource:@"star_sky" ofType:@"gif"];
            [animateLandingPageView showInView:self.view animateImagePath:animateImagePath];
            
        }
            break;
        default:
            break;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
