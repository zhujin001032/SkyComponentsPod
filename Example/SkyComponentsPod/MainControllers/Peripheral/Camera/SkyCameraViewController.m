//
//  SkyCameraViewController.m
//  SkyComponentsPod
//
//  Created by 何助金 on 16/3/29.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import "SkyCameraViewController.h"
#import "EditPhotoCollectionViewCell.h"
#import "QRCodeScanViewController.h"
#import <ZJPhotoPod/ZJPhoto.h>
@interface SkyCameraViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ZJTakePhotoActionSheetDelegate,MKQRCodeReaderViewControllerDelegate>
@property (nonatomic,retain)UICollectionView  *collectionView;
@property (nonatomic,retain)NSMutableArray *dataArray;
@property (nonatomic,assign)BOOL isEditing;
@property (nonatomic,retain)ZJTakePhotoActionSheet *photoAction;
@end

@implementation SkyCameraViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isEditing = NO;
    if(!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:4];
    }
    [_dataArray addObject:@"add"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"二维码"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(rqCodeScan:)];
//   UIButton *cameraButtion = [self creteButtonWithTitle:NSLocalizedString(@"拍照/照片", nil) withTag:100];
//    cameraButtion.frame = CGRectMake(0, 5, SCREEN_WIDTH, 35);
//    [self.view addSubview:cameraButtion];
//   
//    UIButton *qrCodeButtion = [self creteButtonWithTitle:NSLocalizedString(@"二维码", nil) withTag:101];
//    qrCodeButtion.frame = CGRectMake(0, cameraButtion.mkMaxY + 5, SCREEN_WIDTH, 35);
//    [self.view addSubview:qrCodeButtion];
    
    [self createCollectionView];

}

- (void)rqCodeScan:(UIBarButtonItem *)sender
{
    NSArray *arrMetaObjectTypes = @[AVMetadataObjectTypeQRCode,                // 二维码
                                    AVMetadataObjectTypeEAN13Code,             // 条形码
                                    AVMetadataObjectTypeEAN8Code,
                                    AVMetadataObjectTypeCode39Code,
                                    AVMetadataObjectTypeCode128Code];
    if ([MKQRCodeReader supportsMetadataObjectTypes:arrMetaObjectTypes]) {
        static QRCodeScanViewController *vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            MKQRCodeReader *reader = [MKQRCodeReader readerWithMetadataObjectTypes:arrMetaObjectTypes];
            //            [reader setInterstRect:CGRectMake(50, 124, 220, 220)];
            vc = [[QRCodeScanViewController alloc] initWithCancelButtonTitle:nil
                                                                  codeReader:reader
                                                         startScanningAtLoad:YES
                                                      showSwitchCameraButton:YES
                                                             showTorchButton:YES];
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        vc.delegate = self;
        //        [vc setCompletionWithBlock:^(NSString *resultAsString) {
        //            NSLog(@"Completion with result: %@", resultAsString);
        //        }];
        
        [self presentViewController:vc animated:YES completion:NULL];
//        [self.navigationController pushViewController:vc animated:YES];

    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Reader not supported by the current device"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
}//

- (UIButton *)creteButtonWithTitle:(NSString *)title withTag:(NSInteger)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.437 green:0.455 blue:0.439 alpha:1.000] forState:UIControlStateHighlighted];
    button.backgroundColor = [UIColor colorWithRed:0.117 green:0.585 blue:1.000 alpha:1.000];
    [button addTarget: self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5.0;
    button.layer.masksToBounds = YES;
    button.tag = tag;
    return button;
   
}
- (void)buttonPress:(UIButton *)sender{
    if (sender.tag == 100) {
        if (!_photoAction) {
        
            _photoAction = [[ZJTakePhotoActionSheet alloc]init];
            _photoAction.owner = self;
            _photoAction.allowEdit = YES;
            _photoAction.maxNumber = 5;
            _photoAction.takePhotoDelegate = self;
//            _photoAction.tintColor =
//            _photoAction.barTintColor =
        }
    }else if(sender.tag == 101)
    {
        
    }
        
}

- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc ]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.mkHeight -= 90+64 - 90;
    _collectionView.mkY = 90 - 90;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[EditPhotoCollectionViewCell class]forCellWithReuseIdentifier:kEditPhotoCollectionViewCellIdentifier];
    [self.view addSubview:_collectionView];
    [self reload];
}

#pragma -mark
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
   return _dataArray.count;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 70);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EditPhotoCollectionViewCell *myCell = [collectionView dequeueReusableCellWithReuseIdentifier:kEditPhotoCollectionViewCellIdentifier
                                                                                    forIndexPath:indexPath];
    
    if ( !_dataArray || (_dataArray.count == 0)) {
        return myCell;
    }
    
    NSString *imagePath =  [_dataArray objectAtIndex:[indexPath row]];
    if([imagePath hasPrefix:@"http:"]) {
//        [myCell.photo sd_setImageWithURL:[NSURL URLWithString:imagePath]];
    }
    else {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *strPath = [documentsDirectory stringByAppendingPathComponent:imagePath];
        UIImage *image = [UIImage imageWithContentsOfFile:strPath];
        if (!image) {
            image = [UIImage imageNamed:imagePath];
        }
        myCell.photo.image = image;
        
    }
    myCell.photo.contentMode = UIViewContentModeScaleAspectFill;
    myCell.photo.clipsToBounds = YES;
    myCell.photo.tag = indexPath.row;
    myCell.deleteButton.tag = indexPath.row;
    myCell.photo.userInteractionEnabled = YES;
    
    
    if ([indexPath row] != (_dataArray.count - 1))
    {
        myCell.isEditing = self.isEditing;
        
    }else
    {
        myCell.isEditing = NO;
    }
    
    return myCell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(12, 6, 12, 6);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEditing && (indexPath.row < (self.dataArray.count-1))) {
        [self deletePhoto:indexPath.row];
    }
    else {
        EditPhotoCollectionViewCell *cell = (EditPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        [self tapProfileImage:cell.photo.image AtIndex:indexPath.row];
    }
    
}
#pragma mark - UI交互

- (void)reload
{
    [_collectionView reloadData];
}
- (void)deletePhoto:(NSInteger)index
{
    [_dataArray removeObjectAtIndex:index];
    [self reload];
}

- (void)tapProfileImage:(UIImage *)image AtIndex:(NSInteger)index
{
    if (index == (_dataArray.count -1)) {
        //添加照片
        if (!_photoAction) {
            
            _photoAction = [[ZJTakePhotoActionSheet alloc]init];
            _photoAction.owner = self;
            _photoAction.allowEdit = YES;
            _photoAction.maxNumber = 5;
            _photoAction.takePhotoDelegate = self;
            //            _photoAction.tintColor =
            //            _photoAction.barTintColor =
        }
        [_photoAction showInView: self.view];

    }
    else {
        //放大图
        UIView *backgroud = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backgroud.backgroundColor = kRGBAlpha(0, 0, 0, 0.5);
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissCellImageView:)];
        [backgroud addGestureRecognizer:singleTap];
        [[UIApplication sharedApplication].keyWindow addSubview:backgroud];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 69, SCREEN_WIDTH - 10, SCREEN_HEIGHT-69*2)];
        imageView.image = image;
        imageView.userInteractionEnabled = NO;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [backgroud addSubview:imageView];
        
        __weak UIImageView *weekImage = imageView;
        imageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:.3 animations:^{
            weekImage.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            weekImage.transform = CGAffineTransformIdentity;
        }];
    }
}



- (void)dismissCellImageView:(UITapGestureRecognizer *)gesture
{
    __block UIView *v = gesture.view;
    
    [UIView animateWithDuration:.3 animations:^{
        v.alpha = 0;
    } completion:^(BOOL finished) {
        [v removeFromSuperview];
    }];
}

#pragma mark - ZJTakePhotoActionSheetDelegate

- (void)takePhotoActionSheet:(ZJTakePhotoActionSheet *)actionSheet didSelectedImagesPath:(NSMutableArray *)arrPaths
{
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    [set addIndexesInRange:NSMakeRange(_dataArray.count-1, arrPaths.count)];
    [_dataArray insertObjects:[arrPaths copy] atIndexes:set];
    [self reload];
}

- (void)takePhotoActionSheet:(ZJTakePhotoActionSheet *)actionSheet didSelectedImageAtPath:(NSString *)path
{
    if (_dataArray.count > 0) {
        [_dataArray insertObject:[path lastPathComponent] atIndex:[_dataArray count] - 1];
    }
    
    [self reload];
}



#pragma mark -
#pragma mark MKQRCodeReaderViewControllerDelegate

- (void)reader:(MKQRCodeReaderViewController *)readerController didScanResult:(NSString *)result
{
    NSLog(@"Scen Result : %@", result);
    [readerController stopScanning];

//    NSError *error = nil;
//    NSData *jsonData = [result dataUsingEncoding:NSASCIIStringEncoding];
//    NSDictionary *dicAsset = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                             options:NSJSONReadingMutableContainers
//                                                               error:&error];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(1.0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [readerController dismissViewControllerAnimated:YES completion:nil];
                   });
  
    if ([result isKindOfClass:[NSString class]]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"扫描的结果", nil) message:result delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}//

- (void)readerDidCancel:(MKQRCodeReaderViewController *)readerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}//

@end
