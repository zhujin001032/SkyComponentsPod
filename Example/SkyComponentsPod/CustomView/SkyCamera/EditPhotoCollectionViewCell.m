//
//  EditPhotoCollectionViewCell.m
//
//  Created by 何助金 on 15/7/1.
//  Copyright (c) 2015年 Missionsky. All rights reserved.
//

#import "EditPhotoCollectionViewCell.h"
#import "FlatRoundedButton.h"
#import "FlatRoundedImageView.h"

@implementation EditPhotoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (void)_initViews{
    
    _photo = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 54, 54)];
    _photo.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_photo];
    
    _deleteButton = [[FlatRoundedImageView alloc] init];
    _deleteButton.bounds = CGRectMake(0, 0, 16, 16);
    _deleteButton.backgroundColor = [UIColor whiteColor];
    [_deleteButton setImage:[UIImage imageNamed:@"deleteImage"]];
    _deleteButton.mkX = _photo.mkMaxX - 8;
    _deleteButton.mkY = _photo.mkMaxY - 8;
    [self addSubview:_deleteButton];
    
}

- (void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    if (self.isEditing)
    {
        _deleteButton.hidden = NO;
    }
    else
    {
        _deleteButton.hidden = YES;
    }
}
@end
