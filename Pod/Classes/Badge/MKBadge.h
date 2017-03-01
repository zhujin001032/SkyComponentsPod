//
//  MKBadge.h
//  Pods
//
//  Created by Mark Yang on 12/17/15.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MKBadgeStyleFontType) {
    MKBadgeStyleFontTypeHelveticaNeueMedium,
    MKBadgeStyleFontTypeHelveticaNeueLight,
};

@interface MKBadgeStyle : NSObject

@property(nonatomic, strong) UIColor *badgeTextColor;
@property(nonatomic, strong) UIColor *badgeInsetColor;
@property(nonatomic, strong) UIColor *badgeFrameColor;
@property(nonatomic, assign) MKBadgeStyleFontType badgeFontType;
@property(nonatomic, assign) BOOL badgeFrame;
@property(nonatomic, assign) BOOL badgeShining;
@property(nonatomic, assign) BOOL badgeShadow;

#pragma mark -

+ (MKBadgeStyle *)defaultStyle;
+ (MKBadgeStyle *)oldStyle;
+ (MKBadgeStyle *)freeStyleWithTextColor:(UIColor *)textColor
                          withInsetColor:(UIColor*)insetColor
                          withFrameColor:(UIColor*)frameColor
                               withFrame:(BOOL)frame
                              withShadow:(BOOL)shadow
                             withShining:(BOOL)shining
                            withFontType:(MKBadgeStyleFontType)fontType;

@end

#pragma mark -

@interface MKBadge : UIView

@property(nonatomic, strong) NSString       *badgeText;
@property(nonatomic, strong) MKBadgeStyle   *badgeStyle;
@property(nonatomic, assign) CGFloat badgeCornerRoundness;
@property(nonatomic, assign) CGFloat badgeScaleFactor;

#pragma mark -

+ (MKBadge *)customBadgeWithString:(NSString *)badgeString;
+ (MKBadge *)customBadgeWithString:(NSString *)badgeString withScale:(CGFloat)scale;
+ (MKBadge *)customBadgeWithString:(NSString *)badgeString withStyle:(MKBadgeStyle*)style;
+ (MKBadge *)customBadgeWithString:(NSString *)badgeString
                         withScale:(CGFloat)scale
                         withStyle:(MKBadgeStyle*)style;

#pragma mark -

- (void)autoBadgeSizeWithString:(NSString *)badgeString;

@end
