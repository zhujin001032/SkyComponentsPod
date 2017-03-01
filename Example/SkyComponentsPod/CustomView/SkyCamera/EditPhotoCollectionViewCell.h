//
//  EditPhotoCollectionViewCell.h
//
//  Created by 何助金 on 15/7/1.
//  Copyright (c) 2015年 Missionsky. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kEditPhotoCollectionViewCellIdentifier @"EditPhotoCollectionViewCell"

@interface EditPhotoCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *photo;
@property (strong, nonatomic) UIImageView *deleteButton;

@property(nonatomic,assign)BOOL isEditing;

@end
