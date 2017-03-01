//
//  SkyAnimateLandingPageView.h
//  SkyComponentsPod
//
//  Created by SimonLiu on 16/3/22.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

@interface SkyAnimateLandingPageView : UIView

@property (nonatomic, assign) NSInteger animatedDuration;     // 动画时长，默认3秒
@property (nonatomic, copy) void(^disappearHandler)(void);  // 动画消失时的回调

- (void)showInView:(UIView *)inView animateImagePath:(NSString *)animateImagePath;

@end
