//
//  SkyADLandingPageView.m
//  SkyComponentsPod
//
//  Created by SimonLiu on 16/3/18.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import "SkyADLandingPageView.h"

#define kDefaultDuration 3


@interface SkyADLandingPageView ()

@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *finalCountLabel;
@property (nonatomic, assign) NSInteger finalCount;

@end

@implementation SkyADLandingPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _adImageView                        = [[UIImageView alloc] initWithFrame:self.bounds];
        _adImageView.contentMode            = UIViewContentModeScaleAspectFill;
        _adImageView.userInteractionEnabled = YES;
        [self addSubview:_adImageView];
        
        UIView *finalCountContentView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 34, 35, 35)];
        finalCountContentView.backgroundColor = [UIColor blackColor];
        finalCountContentView.alpha = 0.5;
        finalCountContentView.layer.cornerRadius = finalCountContentView.bounds.size.width/2.0;
        finalCountContentView.clipsToBounds = YES;
        [self addSubview:finalCountContentView];
        
        UIButton *btnSkip = [UIButton buttonWithType:UIButtonTypeSystem];
        btnSkip.frame = CGRectMake(2.5, 0, 30, 30);
        [btnSkip setBackgroundColor:[UIColor clearColor]];
        btnSkip.contentEdgeInsets = UIEdgeInsetsMake(-3, 0, 0, 0);
        [btnSkip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnSkip.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [btnSkip setTitle:NSLocalizedString(@"跳过", nil) forState:UIControlStateNormal];
        btnSkip.showsTouchWhenHighlighted = YES;
        [btnSkip addTarget:self
                    action:@selector(disappearBtnClick:)
          forControlEvents:UIControlEventTouchUpInside];
        [finalCountContentView addSubview:btnSkip];
        
        UILabel *finalCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 23, 30, 10)];
        _finalCountLabel = finalCountLabel;
        finalCountLabel.textAlignment = NSTextAlignmentCenter;
        finalCountLabel.backgroundColor = [UIColor clearColor];
        finalCountLabel.textColor = [UIColor lightGrayColor];
        finalCountLabel.font = [UIFont systemFontOfSize:11.0];
        finalCountLabel.text = [NSString stringWithFormat:@"%zd秒",_adDuration?_adDuration:kDefaultDuration];
        [finalCountContentView addSubview:finalCountLabel];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(finalCountHandle:)
                                                userInfo:nil
                                                 repeats:YES];
        [_timer fire];
        _finalCount = _adDuration?_adDuration:kDefaultDuration;
        
    }
    return self;
}

- (void)showInView:(UIView *)inView adImage:(UIImage *)adImage {
    self.frame = inView.bounds;
    self.adImageView.image = adImage;
    [inView addSubview:self];
    [inView bringSubviewToFront:self];
}

- (void)disappearBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
    if (self.disappearHandler) {
        self.disappearHandler();
    }
}

- (void)finalCountHandle:(id)sender {
    if (_finalCount > 0) {
        _finalCount--;
        _finalCountLabel.text = [NSString stringWithFormat:@"%d秒",_finalCount];
    } else {
        [self removeFromSuperview];
        if (self.disappearHandler) {
            self.disappearHandler();
        }
    }
}



@end
