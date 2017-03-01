//
//  FirstPageViewController.h
//  SkyComponentsPod
//
//  Created by SimonLiu on 16/3/18.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, LandingPageType) {
    LandingPageTypeAD = 0,
    LandingPageTypeScroll,
    LandingPageTypeGIF,
};


@interface FirstPageViewController : BaseViewController

@property (nonatomic, assign) LandingPageType landingPageType;      // 启动页样式

@end
