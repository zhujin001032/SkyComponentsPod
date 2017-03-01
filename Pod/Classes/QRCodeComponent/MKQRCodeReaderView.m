//
//  MKQRCodeReaderView.m
//  Pods
//
//  Created by Mark Yang on 11/19/15.
//
//

#import "MKQRCodeReaderView.h"

@interface MKQRCodeReaderView ()

@property (nonatomic, strong) CAShapeLayer *overLay;

@end

#pragma mark -

@implementation MKQRCodeReaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addOverLay];
    }
    
    return self;
}//

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // 暂时不用自画的线
//    CGRect innerRect = CGRectInset(rect, 50, 50);
//    
//    CGFloat minSize = MIN(innerRect.size.width, innerRect.size.height);
//    if (innerRect.size.width != minSize) {
//        innerRect.origin.x   += (innerRect.size.width - minSize) / 2;
//        innerRect.size.width = minSize;
//    }
//    else if (innerRect.size.height != minSize) {
//        innerRect.origin.y    += (innerRect.size.height - minSize) / 2;
//        innerRect.size.height = minSize;
//    }
//    
//    CGRect offsetRect = CGRectOffset(innerRect, 0, 15);
//    
//    _overLay.path = [UIBezierPath bezierPathWithRoundedRect:offsetRect cornerRadius:5].CGPath;
}

#pragma mark -
#pragma mark Private Methods

- (void)addOverLay
{
    _overLay = [[CAShapeLayer alloc] init];
    _overLay.backgroundColor = [UIColor clearColor].CGColor;
    _overLay.fillColor       = [UIColor clearColor].CGColor;
    _overLay.strokeColor     = [UIColor whiteColor].CGColor;
    _overLay.lineWidth       = 3;
    _overLay.lineDashPattern = @[@7.0, @7.0];
    _overLay.lineDashPhase   = 0;
    
    [self.layer addSublayer:_overLay];
}//

@end
