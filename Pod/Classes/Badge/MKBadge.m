//
//  MKBadge.m
//  Pods
//
//  Created by Mark Yang on 12/17/15.
//
//

#import "MKBadge.h"

@implementation MKBadgeStyle

+ (MKBadgeStyle *)defaultStyle
{
    id instance = [[super alloc] init];
    [instance setBadgeFontType:MKBadgeStyleFontTypeHelveticaNeueLight];
    [instance setBadgeTextColor:[UIColor whiteColor]];
    [instance setBadgeInsetColor:[UIColor redColor]];
    [instance setBadgeFrameColor:nil];
    [instance setBadgeFrame:NO];
    [instance setBadgeShadow:NO];
    [instance setBadgeShining:NO];
    
    return instance;
}//

+ (MKBadgeStyle *)oldStyle
{
    id instance = [[super alloc] init];
    [instance setBadgeFontType:MKBadgeStyleFontTypeHelveticaNeueMedium];
    [instance setBadgeTextColor:[UIColor whiteColor]];
    [instance setBadgeInsetColor:[UIColor redColor]];
    [instance setBadgeFrameColor:[UIColor whiteColor]];
    [instance setBadgeFrame:YES];
    [instance setBadgeShadow:YES];
    [instance setBadgeShining:YES];
    
    return instance;
}//

+ (MKBadgeStyle *)freeStyleWithTextColor:(UIColor *)textColor
                          withInsetColor:(UIColor*)insetColor
                          withFrameColor:(UIColor*)frameColor
                               withFrame:(BOOL)frame
                              withShadow:(BOOL)shadow
                             withShining:(BOOL)shining
                            withFontType:(MKBadgeStyleFontType)fontType
{
    id instance = [[super alloc] init];
    [instance setBadgeFontType:fontType];
    [instance setBadgeTextColor:textColor];
    [instance setBadgeInsetColor:insetColor];
    [instance setBadgeFrameColor:frameColor];
    [instance setBadgeFrame:frame];
    [instance setBadgeShadow:shadow];
    [instance setBadgeShining:shining];
    
    return instance;
}//

@end

#pragma mark -

@interface MKBadge ()

@property (nonatomic, strong) UIFont *badgeFont;

#pragma mark -

- (void)drawRoundedRectWithContext:(CGContextRef)context withRect:(CGRect)rect;
- (void)drawFrameWithContext:(CGContextRef)context withRect:(CGRect)rect;

@end

#pragma mark -

@implementation MKBadge

- (id) initWithString:(NSString *)badgeString
            withScale:(CGFloat)scale
            withStyle:(MKBadgeStyle *)style
{
    self = [super initWithFrame:CGRectMake(0, 0, 25, 25)];
    if(self!=nil) {
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        self.backgroundColor = [UIColor clearColor];
        self.badgeText = badgeString;
        self.badgeStyle = style;
        self.badgeCornerRoundness = 0.4;
        self.badgeScaleFactor = scale;
        [self autoBadgeSizeWithString:badgeString];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -

+ (MKBadge *)customBadgeWithString:(NSString *)badgeString
{
    return [[self alloc] initWithString:badgeString
                              withScale:1.0
                              withStyle:[MKBadgeStyle defaultStyle]];
}//

+ (MKBadge *)customBadgeWithString:(NSString *)badgeString withScale:(CGFloat)scale
{
    return [[self alloc] initWithString:badgeString
                              withScale:scale
                              withStyle:[MKBadgeStyle defaultStyle]];
}//

+ (MKBadge *)customBadgeWithString:(NSString *)badgeString withStyle:(MKBadgeStyle*)style
{
    return [[self alloc] initWithString:badgeString
                              withScale:1.0
                              withStyle:style];
}//

+ (MKBadge *)customBadgeWithString:(NSString *)badgeString
                         withScale:(CGFloat)scale
                         withStyle:(MKBadgeStyle*)style
{
    return [[self alloc] initWithString:badgeString
                              withScale:scale
                              withStyle:style];
}//

#pragma mark -

// Draws the Badge with Quartz
- (void)drawRoundedRectWithContext:(CGContextRef)context withRect:(CGRect)rect
{
    CGContextSaveGState(context);
    
    CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
    CGFloat puffer = CGRectGetMaxY(rect)*0.10;
    CGFloat maxX = CGRectGetMaxX(rect) - puffer;
    CGFloat maxY = CGRectGetMaxY(rect) - puffer;
    CGFloat minX = CGRectGetMinX(rect) + puffer;
    CGFloat minY = CGRectGetMinY(rect) + puffer;
    
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, [self.badgeStyle.badgeInsetColor CGColor]);
    CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
    CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
    CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
    CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
    if (self.badgeStyle.badgeShadow) {
        CGContextSetShadowWithColor(context, CGSizeMake(1.0,1.0), 3, [[UIColor blackColor] CGColor]);
    }
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
}

// Draws the Badge Shine with Quartz
- (void)drawShineWithContext:(CGContextRef)context withRect:(CGRect)rect
{
    CGContextSaveGState(context);
    
    CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
    CGFloat puffer = CGRectGetMaxY(rect)*0.10;
    CGFloat maxX = CGRectGetMaxX(rect) - puffer;
    CGFloat maxY = CGRectGetMaxY(rect) - puffer;
    CGFloat minX = CGRectGetMinX(rect) + puffer;
    CGFloat minY = CGRectGetMinY(rect) + puffer;
    CGContextBeginPath(context);
    CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
    CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
    CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
    CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
    CGContextClip(context);
    
    
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 0.4 };
    CGFloat components[8] = {  0.92, 0.92, 0.92, 1.0, 0.82, 0.82, 0.82, 0.4 };
    
    CGColorSpaceRef cspace;
    CGGradientRef gradient;
    cspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColorComponents (cspace, components, locations, num_locations);
    
    CGPoint sPoint, ePoint;
    sPoint.x = 0;
    sPoint.y = 0;
    ePoint.x = 0;
    ePoint.y = maxY;
    CGContextDrawLinearGradient (context, gradient, sPoint, ePoint, 0);
    
    CGColorSpaceRelease(cspace);
    CGGradientRelease(gradient);
    
    CGContextRestoreGState(context);
}


// Draws the Badge Frame with Quartz
- (void)drawFrameWithContext:(CGContextRef)context withRect:(CGRect)rect
{
    CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
    CGFloat puffer = CGRectGetMaxY(rect)*0.10;
    
    CGFloat maxX = CGRectGetMaxX(rect) - puffer;
    CGFloat maxY = CGRectGetMaxY(rect) - puffer;
    CGFloat minX = CGRectGetMinX(rect) + puffer;
    CGFloat minY = CGRectGetMinY(rect) + puffer;
    
    
    CGContextBeginPath(context);
    CGFloat lineSize = 2;
    if(self.badgeScaleFactor>1) {
        lineSize += self.badgeScaleFactor*0.25;
    }
    CGContextSetLineWidth(context, lineSize);
    CGContextSetStrokeColorWithColor(context, [self.badgeStyle.badgeFrameColor CGColor]);
    CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
    CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
    CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
    CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawRoundedRectWithContext:context withRect:rect];
    if(self.badgeStyle.badgeShining) {
        [self drawShineWithContext:context withRect:rect];
    }
    
    if (self.badgeStyle.badgeFrame)  {
        [self drawFrameWithContext:context withRect:rect];
    }
    
    if ([self.badgeText length]>0) {
        CGFloat sizeOfFont = 13.5*_badgeScaleFactor;
        if ([self.badgeText length]<2) {
            sizeOfFont += sizeOfFont * 0.20f;
        }
        UIFont *textFont =  [self fontForBadgeWithSize:sizeOfFont];
        NSDictionary *fontAttr = @{ NSFontAttributeName : textFont, NSForegroundColorAttributeName : self.badgeStyle.badgeTextColor };
        CGSize textSize = [self.badgeText sizeWithAttributes:fontAttr];
        CGPoint textPoint = CGPointMake((rect.size.width/2-textSize.width/2), (rect.size.height/2-textSize.height/2) - 1 );
        [self.badgeText drawAtPoint:textPoint withAttributes:fontAttr];
    }
}

#pragma mark -

- (void)autoBadgeSizeWithString:(NSString *)badgeString
{
    CGSize retValue;
    CGFloat rectWidth, rectHeight;
    NSDictionary *fontAttr = @{NSFontAttributeName:[self fontForBadgeWithSize:12]};
    CGSize stringSize = [badgeString sizeWithAttributes:fontAttr];
    CGFloat flexSpace;
    if ([badgeString length]>=2) {
        flexSpace = [badgeString length];
        rectWidth = 20 + (stringSize.width + flexSpace); rectHeight = 22;
        retValue = CGSizeMake(rectWidth*_badgeScaleFactor, rectHeight*_badgeScaleFactor);
    }
    else {
        retValue = CGSizeMake(25*_badgeScaleFactor, 25*_badgeScaleFactor);
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, retValue.width, retValue.height);
    self.badgeText = badgeString;
    [self setNeedsDisplay];
}//

- (UIFont *)fontForBadgeWithSize:(CGFloat)size {
    switch (self.badgeStyle.badgeFontType) {
        case MKBadgeStyleFontTypeHelveticaNeueMedium:
            return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
            break;
        default:
            return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
            break;
    }
}

@end
