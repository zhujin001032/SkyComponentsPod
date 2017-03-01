//
//  SkyMapsDemoViewController.m
//  SkyComponentsPod
//
//  Created by SimonLiu on 16/4/6.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import "SkyMapsDemoViewController.h"


@interface SkyMapsDemoViewController () <BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic, weak) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, weak) UIButton *startLocBtn;
@property (nonatomic, weak) UIButton *trafficBtn;
@property (nonatomic, weak) UIButton *mapSettingBtn;
@property (nonatomic ,weak) UIButton *lastMapTypeBtn;
@property (nonatomic, strong) UIView *mapSettingView;
@property (nonatomic, strong) UIView   *maskView;

@end

@implementation SkyMapsDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    
}

- (void)createViews {
    
    CGRect mapRect = self.view.frame;
    mapRect.size.height -= 64;
    BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:mapRect];
    _mapView = mapView;
    //    _mapView.overlooking = -30;
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(22.550008, 113.943121)];
    _mapView.zoomLevel = 18;
    _mapView.maxZoomLevel = 20;
    _mapView.showMapScaleBar = YES;
    _mapView.mapScaleBarPosition = CGPointMake(50, CGRectGetMaxY(_mapView.frame) - 60);
    [self.view addSubview:_mapView];
    
    UIButton *trafficBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _trafficBtn = trafficBtn;
    trafficBtn.frame = CGRectMake(CGRectGetMaxX(_mapView.frame) - 46, 30, 36, 36);
    [trafficBtn setBackgroundImage:[UIImage imageNamed:@"image_traffic_off.png"] forState:UIControlStateNormal];
    [trafficBtn setBackgroundImage:[UIImage imageNamed:@"image_traffic_on.png"] forState:UIControlStateSelected];
    [trafficBtn addTarget:self action:@selector(trafficBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:trafficBtn];
    
    UIButton *mapSettingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mapSettingBtn = mapSettingBtn;
    mapSettingBtn.clipsToBounds = YES;
    mapSettingBtn.frame = CGRectMake(CGRectGetMaxX(_mapView.frame) - 46, CGRectGetMaxY(trafficBtn.frame) + 5 , 36, 36);
    [mapSettingBtn setBackgroundImage:[UIImage imageNamed:@"mapSetting.png"] forState:UIControlStateNormal];
    [mapSettingBtn setBackgroundImage:[UIImage imageNamed:@"mapStatus_closed.png"] forState:UIControlStateSelected];
    [mapSettingBtn addTarget:self action:@selector(mapSettingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapSettingBtn];
    
    UIView *mapSettingView = [[UIView alloc] initWithFrame:CGRectZero];
    mapSettingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mapSettingView];
    _mapSettingView = mapSettingView;
    
    UIButton *startLocBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startLocBtn.frame = CGRectMake(10, CGRectGetMaxY(_mapView.frame) - 66, 36, 36);
    [startLocBtn setBackgroundImage:[UIImage imageNamed:@"btn_map_location.png"] forState:UIControlStateNormal];
    [startLocBtn addTarget:self action:@selector(startLocBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startLocBtn];
    _startLocBtn = startLocBtn;
    
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    
    
}

- (void)initMapSettingView {
    
    CGFloat mapTypeBtnW = (SCREEN_WIDTH - 20 - 20)/3.0;
    CGFloat mapTypeBtnH = 60.0;
    UIImage *mapTypeBtnUnselectedBgImg = [[UIImage imageNamed:@"unselected_map_type_bg.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImage *mapTypeBtnSelectedBgImg = [[UIImage imageNamed:@"selected_map_type_bg.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    
    UIButton *satelliteMapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    satelliteMapBtn.tag = 1000;
    satelliteMapBtn.frame = CGRectMake(5, 5, mapTypeBtnW, mapTypeBtnH);
    [satelliteMapBtn setImage:[UIImage imageNamed:@"img_map_satellite.png"] forState:UIControlStateNormal];
    [satelliteMapBtn setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [satelliteMapBtn setBackgroundImage:mapTypeBtnUnselectedBgImg forState:UIControlStateNormal];
    [satelliteMapBtn setBackgroundImage:mapTypeBtnSelectedBgImg forState:UIControlStateSelected];
    [satelliteMapBtn addTarget:self action:@selector(mapTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *satelliteLb = [[UILabel alloc] initWithFrame:CGRectMake(satelliteMapBtn.mkX, satelliteMapBtn.mkMaxY + 5, satelliteMapBtn.mkWidth, 15)];
    satelliteLb.text = @"卫星图";
    satelliteLb.font = [UIFont systemFontOfSize:11.0];
    satelliteLb.textAlignment = NSTextAlignmentCenter;
    [_mapSettingView addSubview:satelliteMapBtn];
    [_mapSettingView addSubview:satelliteLb];
    
    UIButton *plane2DMapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    plane2DMapBtn.tag = 1001;
    _lastMapTypeBtn = plane2DMapBtn;
    plane2DMapBtn.selected = YES;
    plane2DMapBtn.frame = CGRectMake(satelliteMapBtn.mkMaxX + 5, 5, mapTypeBtnW, mapTypeBtnH);
    [plane2DMapBtn setImage:[UIImage imageNamed:@"img_map_2D.png"] forState:UIControlStateNormal];
    [plane2DMapBtn setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [plane2DMapBtn setBackgroundImage:mapTypeBtnUnselectedBgImg forState:UIControlStateNormal];
    [plane2DMapBtn setBackgroundImage:mapTypeBtnSelectedBgImg forState:UIControlStateSelected];
    [plane2DMapBtn addTarget:self action:@selector(mapTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *plane2DLb = [[UILabel alloc] initWithFrame:CGRectMake(plane2DMapBtn.mkX, plane2DMapBtn.mkMaxY + 5, plane2DMapBtn.mkWidth, 15)];
    plane2DLb.text = @"2D平面图";
    plane2DLb.font = [UIFont systemFontOfSize:11.0];
    plane2DLb.textAlignment = NSTextAlignmentCenter;
    [_mapSettingView addSubview:plane2DMapBtn];
    [_mapSettingView addSubview:plane2DLb];
    
    UIButton *overlook3DMapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    overlook3DMapBtn.tag = 1002;
    overlook3DMapBtn.frame = CGRectMake(plane2DMapBtn.mkMaxX + 5, 5, mapTypeBtnW, mapTypeBtnH);
    [overlook3DMapBtn setImage:[UIImage imageNamed:@"img_building3D.png"] forState:UIControlStateNormal];
    [overlook3DMapBtn setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [overlook3DMapBtn setBackgroundImage:mapTypeBtnUnselectedBgImg forState:UIControlStateNormal];
    [overlook3DMapBtn setBackgroundImage:mapTypeBtnSelectedBgImg forState:UIControlStateSelected];
    [overlook3DMapBtn addTarget:self action:@selector(mapTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *overlook3DLb = [[UILabel alloc] initWithFrame:CGRectMake(overlook3DMapBtn.mkX, overlook3DMapBtn.mkMaxY + 5, overlook3DMapBtn.mkWidth, 15)];
    overlook3DLb.text = @"3D俯视图";
    overlook3DLb.font = [UIFont systemFontOfSize:11.0];
    overlook3DLb.textAlignment = NSTextAlignmentCenter;
    [_mapSettingView addSubview:overlook3DMapBtn];
    [_mapSettingView addSubview:overlook3DLb];
    UIView *separeteLine1 = [[UIView alloc] initWithFrame:CGRectMake(5, satelliteLb.mkMaxY + 5, SCREEN_WIDTH - 30, 1)];
    separeteLine1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_seperator_line.png"]];
    [_mapSettingView addSubview:separeteLine1];
    UIImageView *mapHeatImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, separeteLine1.mkMaxY + 5, satelliteMapBtn.mkWidth/2, satelliteMapBtn.mkHeight/2)];
    mapHeatImgView.image = [UIImage imageNamed:@"img_map_heat.png"];
    UILabel *mapHeatLb = [[UILabel alloc] initWithFrame:CGRectMake(mapHeatImgView.mkMaxX + 10, mapHeatImgView.mkY, 60, mapHeatImgView.mkHeight)];
    mapHeatLb.text = @"热力图";
    mapHeatLb.font = [UIFont systemFontOfSize:11.0];
    UISwitch *mapHeatSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40 - 60, mapHeatImgView.mkY, 50, mapHeatImgView.mkHeight)];
    [mapHeatSwitch addTarget:self action:@selector(mapHeatIsOn:) forControlEvents:UIControlEventValueChanged];
    [_mapSettingView addSubview:mapHeatImgView];
    [_mapSettingView addSubview:mapHeatLb];
    [_mapSettingView addSubview:mapHeatSwitch];
    
}

- (void)initMaskView {
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor lightGrayColor];
    maskView.alpha = 0.4;
    UITapGestureRecognizer *tapRemoveMask = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRemoveMask:)];
    [maskView addGestureRecognizer:tapRemoveMask];
    _maskView = maskView;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = 22.550008;
    coor.longitude = 113.943121;
    annotation.coordinate = coor;
    annotation.title = @"凌云新创信息科技(深圳)有限公司";
    [_mapView addAnnotation:annotation];
    
}

- (void)startLocBtnClick:(UIButton *)sender {
    
    sender.enabled = NO;
    _mapView.zoomLevel = 18;
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.locService startUserLocationService];
        weakSelf.mapView.showsUserLocation = NO;//先关闭显示的定位图层
        weakSelf.mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        weakSelf.mapView.showsUserLocation = YES;//显示定位图层
    });
    
}


- (void)trafficBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _mapView.trafficEnabled = sender.selected;
}

- (void)mapSettingBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    __block CGRect mapSettingViewFrame = CGRectMake(10, CGRectGetMaxY(_mapSettingBtn.frame), SCREEN_WIDTH - 20, 150);
    __weak typeof(self) weakSelf = self;

    if (sender.isSelected) {
        
        weakSelf.mapSettingView.frame = mapSettingViewFrame;
        if (!weakSelf.mapSettingView.subviews.count) {
              [weakSelf initMapSettingView];
        }
        
        if (!_maskView) {
            [weakSelf initMaskView];
        }
        
        [weakSelf.view insertSubview:weakSelf.maskView belowSubview:weakSelf.mapSettingBtn];
        [weakSelf.view addSubview:weakSelf.mapSettingView];
        
    } else {
        
        weakSelf.mapSettingView.frame = CGRectZero;
        [weakSelf.mapSettingView removeFromSuperview];
        [weakSelf.maskView removeFromSuperview];
        
    }
        
   
}

- (void)tapRemoveMask:(UITapGestureRecognizer *)tap {
    
    [self mapSettingBtnClick:_mapSettingBtn];
    [tap.view removeFromSuperview];
    
}

- (void)mapTypeBtnClick:(UIButton *)button {
    
    if ([button isEqual:_lastMapTypeBtn]) {
        return;
    }
    
    _lastMapTypeBtn.selected = NO;
    button.selected = !button.selected;
    _lastMapTypeBtn = button;
    
    switch (button.tag) {
        case 1000:
        {
            _mapView.mapType = BMKMapTypeSatellite;
        }
            break;
        case 1001:
        {
            _mapView.mapType = BMKMapTypeStandard;
            _mapView.overlooking = 0;
            _mapView.buildingsEnabled = NO;
        }
            break;
        case 1002:
        {
            _mapView.mapType = BMKMapTypeStandard;
            _mapView.overlooking = -45;
            _mapView.buildingsEnabled = YES;
        }
            break;
        default:
            break;
    }
    
}

- (void)mapHeatIsOn:(UISwitch *)sender {
    _mapView.baiduHeatMapEnabled = sender.isOn;
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
  
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
//    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    [_mapView updateLocationData:userLocation];
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [_locService stopUserLocationService];
    
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
    _startLocBtn.enabled = YES;

}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    _startLocBtn.enabled = YES;
    [_locService stopUserLocationService];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
}


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

@end
