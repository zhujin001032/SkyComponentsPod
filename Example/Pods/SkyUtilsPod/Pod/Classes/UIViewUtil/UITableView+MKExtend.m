//
//  UITableView+MKExtend.m
//  Pods
//
//  Created by Mark Yang on 12/7/15.
//
//

#import "UITableView+MKExtend.h"

@implementation UITableView (MKExtend)

- (void)hideExtraCellLine
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    [self setTableFooterView:view];
    
    return;
}//

@end
