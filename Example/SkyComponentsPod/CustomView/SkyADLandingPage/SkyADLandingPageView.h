//
//  SkyADLandingPageView.h
//  SkyComponentsPod
//
//  Created by SimonLiu on 16/3/18.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkyADLandingPageView : UIView

@property (nonatomic, assign) NSInteger adDuration;     // 广告时长，默认3秒
@property (nonatomic, copy) void(^disappearHandler)(void);  // 广告图片消失时的回调

- (void)showInView:(UIView *)inView adImage:(UIImage *)adImage;


@end
