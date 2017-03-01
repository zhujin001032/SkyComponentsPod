//
//  SkyGuideView.m
//  SkyComponentsPod
//
//  Created by SimonLiu on 16/3/22.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import "SkyGuideView.h"

@interface SkyGuideView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControll;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation SkyGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Images:(NSArray *)images {
    self = [self initWithFrame:frame];
    
    _pageNumber = images.count;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(frame.size.width*(images.count+0.5), frame.size.height);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    for (NSInteger index = 0; index < images.count; index++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        imageView.image = images[index];
        [_scrollView addSubview:imageView];
    }
    
    if (_isPageIndicator) {
        _pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/8, SCREEN_HEIGHT-80, SCREEN_WIDTH/4.0, 20)];
        _pageControll.numberOfPages = images.count;
        _pageControll.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControll.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControll.currentPage = 0;
        [self addSubview:_pageControll];
    }
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _startButton = startButton;
    startButton.frame = CGRectMake((self.frame.size.width-100)/2,
                                   self.frame.size.height-60, 100, 30);
    [startButton setTitle:@"立即体验" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton setBackgroundColor:[UIColor orangeColor]];
    startButton.layer.cornerRadius = 10.0;
    startButton.clipsToBounds = YES;
    [startButton addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:startButton];
    
    return self;
}

- (void)showInView:(UIView *)inView {
    
    [inView addSubview:self];
    [inView bringSubviewToFront:self];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    NSLog(@"--- contentOffset.x = %lf ----",scrollView.contentOffset.x);
    if (_isPageIndicator) {
        if (scrollView.contentOffset.x > 0) {
            NSInteger currentPageIndex = (scrollView.contentOffset.x + self.frame.size.width/2)/self.frame.size.width;
            _pageControll.currentPage = currentPageIndex;
        } else {
            _pageControll.currentPage = 0;
        }
    }
    
    if (scrollView.contentOffset.x > self.frame.size.width*(_pageNumber-1)) {
        
//        if (self.disappearHandler) {
//            self.disappearHandler();
//        }
//        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            self.alpha = 0.0;
//        } completion:^(BOOL finished) {
//            [self removeFromSuperview];
//        }];
        _startButton.mkX = (self.frame.size.width - 100)/2 - (scrollView.contentOffset.x -  self.frame.size.width*(_pageNumber-1));
        self.alpha = 1 - (scrollView.contentOffset.x -  self.frame.size.width*(_pageNumber-1))/self.frame.size.width;
        if (scrollView.contentOffset.x > self.frame.size.width*(_pageNumber-1+0.33)) {
            [self removeFromSuperview];
            if (self.disappearHandler) {
                self.disappearHandler();
                }
        }
        
    }
}



- (void)startBtnClick:(UIButton *)sender {
    if (self.superview) {
        [self removeFromSuperview];
        if (self.disappearHandler) {
            self.disappearHandler();
        }
    }
}



@end
