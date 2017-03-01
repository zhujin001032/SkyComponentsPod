//
//  SkyGuideView.h
//  SkyComponentsPod
//
//  Created by SimonLiu on 16/3/22.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkyGuideView : UIView

@property (nonatomic, copy) void(^disappearHandler)(void);  // 引导页面消失时的回调
@property (nonatomic, assign) BOOL isPageIndicator;         // 是否需要手动添加页码标记


- (instancetype)initWithFrame:(CGRect)frame Images:(NSArray *)images;
- (void)showInView:(UIView *)inView;

@end
