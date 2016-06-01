//
//  TRMapViewController.m
//  LeTao
//
//  Created by tarena on 16/5/30.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRMapViewController.h"
#import "DPAPI.h"
#import <MapKit/MapKit.h>
#import "TRAnnotation.h"
#import "TRBusiness.h"
#import "TRMetaDataTool.h"
#import "TRDeal.h"
@interface TRMapViewController ()<MKMapViewDelegate, DPRequestDelegate>
//CLLocationManager
@property (nonatomic, strong) CLLocationManager *locationMgr;
//mapView
@property (nonatomic, strong) MKMapView *mapView;
//地理编码
@property (nonatomic, strong) CLGeocoder *geocoder;
//记录用户所在的城市的名字
@property (nonatomic, copy) NSString *cityName;

@end

@implementation TRMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.geocoder    = [CLGeocoder new];
    self.locationMgr = [CLLocationManager new];
    //iOS8+; 用户同意; Info.plist
    [self.locationMgr requestWhenInUseAuthorization];
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //mapView属性
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.view addSubview:self.mapView];
}

#pragma mark -- MKMapViewDelegate
//获取到用户的位置
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    //用户所在位置 -反向地理编码-> 获取对应位置的城市名字
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            CLPlacemark *placemark = [placemarks lastObject];
            //前提：模拟器是简体中文
            self.cityName = placemark.addressDictionary[@"City"];
            //截取字符串,去掉最后一个”市“这个字
            self.cityName = [self.cityName substringToIndex:self.cityName.length - 1];
            //发送请求
            [self mapView:mapView regionDidChangeAnimated:YES];
        } else {
            NSLog(@"反向地理编码失败");
        }
    }];
}
//区域发生挪动停止的时候
//regionDidChangeAnimated早于didUpdateUserLocation方法
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (!self.cityName) {
        //直接返回，不执行下面的逻辑
        return;
    }
    /*city: self.cityName(必须发送的不能为空的参数)
      latitude:mapView.region.center.latitude
      longitude:mapView.region.center.longitude
      radius: 500
     */
    DPAPI *api = [DPAPI new];
    //设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city"] = self.cityName;
    params[@"latitude"]  = @(mapView.region.center.latitude);
    params[@"longitude"] = @(mapView.region.center.longitude);
    params[@"radius"] = @500;//米；默认是1000米；可以不给定
    [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}
//成功获取
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    //清除地图视图上的所有大头针对象(内存)
    NSArray *annotations = [NSArray arrayWithArray:self.mapView.annotations];
    [self.mapView removeAnnotations:annotations];
    //1.解析result JSON数据
    //2.添加自定义的大头针对象
    NSArray *resultArray = [TRMetaDataTool parseDealsResult:result];
    for (TRDeal *deal in resultArray) {
        
        
        NSArray *dealsArray = [TRMetaDataTool getAllBusiness:deal];
        TRCategory *category = [TRMetaDataTool getCategoryWithDeal:deal];
        for (TRBusiness *business in dealsArray) {
            TRAnnotation *annotation = [TRAnnotation new];
            annotation.coordinate = CLLocationCoordinate2DMake([business.latitude doubleValue] , [business.longitude doubleValue] );
            annotation.title = business.name;
            annotation.subtitle = deal.desc;
            if (category) {
                //找到了所属分类
                annotation.image = [UIImage imageNamed:category.map_icon];
            }else
            {
                annotation.image = [UIImage imageNamed:@"ic_category_default"];
            }
    
            [self.mapView addAnnotation:annotation];
        }
    }
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *identifier = @"annotation";
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annoView) {
        annoView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
        annoView.canShowCallout = YES;
        TRAnnotation *anno = (TRAnnotation*)annotation;
        annoView.image = anno.image;
    }else{
        annoView.annotation = annotation;
    }
    return annoView;
}
//失败
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"失败:%@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
