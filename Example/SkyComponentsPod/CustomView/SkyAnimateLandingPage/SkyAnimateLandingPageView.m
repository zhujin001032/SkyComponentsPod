//
//  SkyAnimateLandingPageView.m
//  SkyComponentsPod
//
//  Created by SimonLiu on 16/3/22.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import "SkyAnimateLandingPageView.h"
#define kDefaultDuration 3

@interface SkyAnimateLandingPageView()


@end

@implementation SkyAnimateLandingPageView

- (void)showInView:(UIView *)inView animateImagePath:(NSString *)animateImagePath {
    self.frame = inView.bounds;
//    self.adImageView.image = adImage;
    [inView addSubview:self];
    
    FLAnimatedImage *flImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:animateImagePath]];
    FLAnimatedImageView *flImageView = [[FLAnimatedImageView alloc] init];
    flImageView.animatedImage = flImage;
    flImageView.frame = self.bounds;
    [self addSubview:flImageView];
    [inView bringSubviewToFront:self];
    
    __weak typeof(self) weakSelf = self
    ;
    NSInteger finalCount = _animatedDuration ? _animatedDuration : kDefaultDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(finalCount * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf removeFromSuperview];
        if (self.disappearHandler) {
            self.disappearHandler();
        }
    });
}



@end
