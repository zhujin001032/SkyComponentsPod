//
//  UIView+MKExtend.m
//  Pods
//
//  Created by Mark Yang on 12/4/15.
//
//

#import "UIView+MKExtend.h"

@implementation UIView (MKExtend)

- (UIView *)showTips:(NSString *)strTips
{
    if (strTips.length < 1) {
        return nil;
    }
    
    UIFont *font = [UIFont systemFontOfSize:13.0];
    CGFloat kLeftPadding = 15.0;
//    CGSize aSize = [strTips sizeWithFont:font
//                       constrainedToSize:CGSizeMake(CGRectGetWidth(self.bounds)-kLeftPadding*2,
//                                                    MAXFLOAT)
//                           lineBreakMode:NSLineBreakByWordWrapping];
    CGRect aRect = [strTips boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.bounds)-kLeftPadding*2, MAXFLOAT)
                                         options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin)
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    CGSize aSize = aRect.size;
    UILabel *lbTips = [[UILabel alloc] initWithFrame:CGRectMake(kLeftPadding,
                                                                0,
                                                                aSize.width,
                                                                aSize.height)];
    [lbTips setFont:font];
    [lbTips setTextColor:[UIColor grayColor]];
    [lbTips setText:strTips];
    [lbTips setBackgroundColor:[UIColor clearColor]];
    [lbTips setCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-20)];
    [self addSubview:lbTips];
    
    return lbTips;
}//

- (void)removeAllSubViews
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    return ;
}//

@end
