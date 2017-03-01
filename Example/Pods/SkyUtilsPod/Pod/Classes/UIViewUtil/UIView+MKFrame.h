//
//  UIView+MKFrame.h
//  BetterUtils
//
//  Created by Mark Yang on 4/26/15.
//  Copyright (c) 2015 HH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MKFrame)

@property (nonatomic, assign) CGFloat mkX;
@property (nonatomic, assign) CGFloat mkY;
@property (nonatomic, assign) CGFloat mkWidth;
@property (nonatomic, assign) CGFloat mkHeight;
@property (nonatomic, assign) CGFloat mkMaxX;
@property (nonatomic, assign) CGFloat mkMaxY;
@property (nonatomic, assign) CGFloat mkCenterX;
@property (nonatomic, assign) CGFloat mkCenterY;
@property (nonatomic, assign, readonly) CGFloat mkBoundWidth;
@property (nonatomic, assign, readonly) CGFloat mkBoundHeight;

@end
