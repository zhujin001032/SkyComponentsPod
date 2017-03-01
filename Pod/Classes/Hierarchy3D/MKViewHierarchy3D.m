//
//  MKViewHierarchy3D.m
//  Pods
//
//  Created by Mark Yang on 12/8/15.
//
//

#import "MKViewHierarchy3D.h"

#if !__has_feature(objc_arc)
#error add -fobjc-arc to complier flags
#endif

#ifndef DEGREES_TO_RADIANS
#define DEGREES_TO_RADIANS(d) ((d) * M_PI / 180)
#endif

#pragma mark -

@interface UIView (MKHolderFrame)

@property (nonatomic, readonly) CGRect holderFrame;

#pragma mark -

- (CGRect)holderFrameWithDelta:(CGPoint)delta;

@end

@implementation UIView (MKHolderFrame)

- (CGRect)holderFrame
{
    CGRect r = CGRectMake(self.center.x - self.bounds.size.width / 2,
                          self.center.y - self.bounds.size.height / 2,
                          self.bounds.size.width,
                          self.bounds.size.height);
    return r;
}//

- (CGRect)holderFrameWithDelta:(CGPoint)delta {
    CGRect r = CGRectMake(self.center.x - self.bounds.size.width / 2 + delta.x,
                          self.center.y - self.bounds.size.height / 2 + delta.y,
                          self.bounds.size.width,
                          self.bounds.size.height);
    return r;
}

@end

#pragma mark -

@interface MKViewImageHolder : NSObject


@end

@implementation MKViewImageHolder



@end

#pragma mark -

@interface MKViewHierarchy3DTOP : UIWindow

+ (MKViewHierarchy3DTOP *)sharedInstance;

@end

@implementation MKViewHierarchy3DTOP

+ (MKViewHierarchy3DTOP *)sharedInstance
{
    static MKViewHierarchy3DTOP *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[MKViewHierarchy3DTOP alloc] init];
    });
    
    return __sharedInstance;
}//

- (instancetype)init
{
    CGRect frame = CGRectMake(40, 40, 40, 40);
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setWindowLevel:UIWindowLevelStatusBar+100.0];
        UIButton *btnToggle = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnToggle setShowsTouchWhenHighlighted:YES];
        [btnToggle setFrame:CGRectMake(5, 5, 30, 30)];
        [btnToggle.layer setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.9].CGColor];
        [btnToggle.layer setCornerRadius:15.0];
        [btnToggle.layer setShadowOpacity:1.0];
        [btnToggle.layer setShadowRadius:4.0];
        [btnToggle.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [btnToggle.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
        
        UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(panGestureHandle:)];
        [btnToggle addGestureRecognizer:panGest];
        [btnToggle addTarget:[MKViewHierarchy3D sharedInstance]
                      action:@selector(btnToggleEvent:)
            forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btnToggle];
    }
    
    return self;
}//

- (void)panGestureHandle:(UIPanGestureRecognizer *)gest
{
    static CGRect oldFrame;
    if (UIGestureRecognizerStateBegan == gest.state) {
        oldFrame = self.frame;
    }
    CGPoint change = [gest translationInView:self];
    CGRect newFrame = oldFrame;
    newFrame.origin.x += change.x;
    newFrame.origin.y += change.y;
    [self setFrame:newFrame];
}//

@end

#pragma mark -

@interface MKViewHierarchy3D ()

@property (nonatomic, assign) BOOL              isAnimating;
@property (nonatomic, strong) NSMutableArray    *arrHolders;
@property (nonatomic, assign) CGFloat           rotateX;
@property (nonatomic, assign) CGFloat           rotateY;

@end

#pragma mark -

@implementation MKViewHierarchy3D

+ (MKViewHierarchy3D *)sharedInstance
{
    static MKViewHierarchy3D *__sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        __sharedInstance = [[MKViewHierarchy3D alloc] init];
    });
    
    return __sharedInstance;
}//

- (void)btnToggleEvent:(id)sender
{
    if (_isAnimating) {
        return;
    }
    if (self.hidden) {
        [self setHidden:NO];
        [self setFrame:[[UIScreen mainScreen] bounds]];
    }
}//

#pragma mark -

- (void)startShow
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    _rotateX = 0.0;
    _rotateY = 0.0;
    _arrHolders = nil;
    _arrHolders = [NSMutableArray arrayWithCapacity:100];
    
    NSArray *arrWins = [[UIApplication sharedApplication] windows];
    for (NSInteger i = 0; i < [arrWins count]; i++) {
        if (arrWins[i] == [MKViewHierarchy3DTOP sharedInstance]) {
            continue;
        }
//        [self dump];
    }
    
}//

@end
