//
//  UIView+MKExtend.h
//  Pods
//
//  Created by Mark Yang on 12/4/15.
//
//

#import <UIKit/UIKit.h>

@interface UIView (MKExtend)

/**
 *	@brief	Show Toast Tip View with Tip String
 *
 *	@param 	strTips 	Tip String
 *
 *	@return	Toast View
 *
 *	Created by Mark on 2015-12-07 10:26
 */
- (UIView *)showTips:(NSString *)strTips;

/**
 *	@brief	Remove all subviews
 *
 *	@return	N/A
 *
 *	Created by Mark on 2015-12-04 15:51
 */
- (void)removeAllSubViews;

@end
