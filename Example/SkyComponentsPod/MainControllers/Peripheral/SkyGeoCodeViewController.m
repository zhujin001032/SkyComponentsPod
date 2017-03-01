//
//  SkyGeoCodeViewController.m
//  SkyComponentsPod
//
//  Created by SimonLiu on 16/4/7.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import "SkyGeoCodeViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

static CGFloat kLeftRightPadding = 10.0f;

@interface SkyGeoCodeViewController () <BMKGeoCodeSearchDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate>

{
    BOOL _isGeoSearch;
}
@property (nonatomic, weak) UITextField *cityTextF;
@property (nonatomic, weak) UITextField *addressTextF;
@property (nonatomic, weak) UITextField *coordinateXTextF;
@property (nonatomic, weak) UITextField *coordinateYTextF;
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic ,strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, weak)  UIButton *startLocBtn;


@end

@implementation SkyGeoCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    [self initUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _geoCodeSearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
    _geoCodeSearch.delegate = nil;
    
}

- (void)initUI {
    
    UITextField *cityTextF = [[UITextField alloc] initWithFrame:CGRectMake(kLeftRightPadding, kLeftRightPadding, SCREEN_WIDTH/5, 3*kLeftRightPadding)];
    cityTextF.borderStyle = UITextBorderStyleBezel;
    cityTextF.font = [UIFont systemFontOfSize:11.0];
    [self.view addSubview:cityTextF];
    _cityTextF = cityTextF;
    
    UITextField *addressTextF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cityTextF.frame)+kLeftRightPadding, kLeftRightPadding, SCREEN_WIDTH/5*2, 3*kLeftRightPadding)];
    addressTextF.borderStyle = UITextBorderStyleBezel;
    addressTextF.font = [UIFont systemFontOfSize:11.0];
    [self.view addSubview:addressTextF];
    _addressTextF = addressTextF;
    
    UIButton *geoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    geoBtn.frame = CGRectMake(CGRectGetMaxX(addressTextF.frame) + kLeftRightPadding, kLeftRightPadding, SCREEN_WIDTH - CGRectGetMaxX(addressTextF.frame) - 2*kLeftRightPadding, 3*kLeftRightPadding);
    [geoBtn setTitle:@"Geo" forState:UIControlStateNormal];
    [geoBtn setTitleColor:[UIColor colorWithRed:52/255.0 green:75/255.0 blue:132/255.0 alpha:1.0] forState:UIControlStateNormal];
    geoBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [geoBtn addTarget:self action:@selector(geoCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:geoBtn];
    
    UITextField *coordinateXTextF = [[UITextField alloc] initWithFrame:CGRectMake(kLeftRightPadding, CGRectGetMaxY(cityTextF.frame) + kLeftRightPadding, SCREEN_WIDTH*0.3, 3*kLeftRightPadding)];
    coordinateXTextF.borderStyle = UITextBorderStyleBezel;
    coordinateXTextF.font = [UIFont systemFontOfSize:11.0];
    [self.view addSubview:coordinateXTextF];
    _coordinateXTextF = coordinateXTextF;
    
    UITextField *coordinateYTextF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(coordinateXTextF.frame)+kLeftRightPadding, CGRectGetMaxY(cityTextF.frame) + kLeftRightPadding, SCREEN_WIDTH*0.3, 3*kLeftRightPadding)];
    coordinateYTextF.borderStyle = UITextBorderStyleBezel;
    coordinateYTextF.font = [UIFont systemFontOfSize:11.0];
    [self.view addSubview:coordinateYTextF];
    _coordinateYTextF = coordinateYTextF;
    
    UIButton *reverseGeoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    reverseGeoBtn.frame = CGRectMake(CGRectGetMaxX(coordinateYTextF.frame) + kLeftRightPadding, CGRectGetMaxY(cityTextF.frame) + kLeftRightPadding, SCREEN_WIDTH - CGRectGetMaxX(addressTextF.frame) - 2*kLeftRightPadding, 3*kLeftRightPadding);
    [reverseGeoBtn setTitle:@"ReverseGeo" forState:UIControlStateNormal];
    [reverseGeoBtn setTitleColor:[UIColor colorWithRed:52/255.0 green:75/255.0 blue:132/255.0 alpha:1.0] forState:UIControlStateNormal];
    reverseGeoBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [reverseGeoBtn addTarget:self action:@selector(reverseGeoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reverseGeoBtn];
    
    _coordinateXTextF.text = @"113.943121";
    _coordinateYTextF.text = @"22.550008";
    _cityTextF.text = @"深圳";
    _addressTextF.text = @"南山区软件园2期12栋";
    
    BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(coordinateXTextF.frame) + kLeftRightPadding, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - CGRectGetMaxY(coordinateXTextF.frame) - kLeftRightPadding)];
    [self.view addSubview:mapView];
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(22.550008, 113.943121)];
    mapView.zoomLevel = 14;
    mapView.maxZoomLevel = 20;
    mapView.showMapScaleBar = YES;
    mapView.mapScaleBarPosition = CGPointMake(50, CGRectGetMaxY(mapView.frame) - 60);
    _mapView = mapView;
    
    
    UIButton *startLocBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startLocBtn.frame = CGRectMake(10, CGRectGetMaxY(_mapView.frame) - 66, 36, 36);
    [startLocBtn setBackgroundImage:[UIImage imageNamed:@"btn_map_location.png"] forState:UIControlStateNormal];
    [startLocBtn addTarget:self action:@selector(startLocBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startLocBtn];
    _startLocBtn = startLocBtn;
    

}

//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView *)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView *)annotationView).animatesDrop = YES;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    return annotationView;
}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc] init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        
        titleStr = @"正向地理编码";
        showmeg = [NSString stringWithFormat:@"经度:%f,纬度:%f",item.coordinate.longitude,item.coordinate.latitude];
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }
}


- (void)geoCodeBtnClick:(UIButton *)sender {
    
    _isGeoSearch = true;
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc] init];
    geocodeSearchOption.city= _cityTextF.text;
    geocodeSearchOption.address = _addressTextF.text;
    BOOL flag = [_geoCodeSearch geoCode:geocodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }

}

- (void)reverseGeoBtnClick:(UIButton *)sender {
    
    _isGeoSearch = false;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    if (_coordinateXTextF.text != nil && _coordinateYTextF.text != nil) {
        pt = (CLLocationCoordinate2D){[_coordinateYTextF.text floatValue], [_coordinateXTextF.text floatValue]};
    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }

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
    
    _coordinateXTextF.text = [NSString stringWithFormat:@"%lf",userLocation.location.coordinate.longitude];
    _coordinateYTextF.text = [NSString stringWithFormat:@"%lf",userLocation.location.coordinate.latitude];
    
    UIAlertView *locationAlert = [[UIAlertView alloc] initWithTitle:@"我的位置" message:[NSString stringWithFormat:@"经度:%f,纬度:%f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [locationAlert show];
    
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
    
    UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [failAlert show];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
