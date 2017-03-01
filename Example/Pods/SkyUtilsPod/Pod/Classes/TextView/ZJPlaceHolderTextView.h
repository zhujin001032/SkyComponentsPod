//
//  ZJPlaceHolderTextView.h
//  Pods
//
//  Created by 何助金 on 8/2/15.
//
//

#import <UIKit/UIKit.h>

@interface ZJPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor  *placeholderColor;

#pragma mark -

-(void)textChanged:(NSNotification*)notification;

@end
