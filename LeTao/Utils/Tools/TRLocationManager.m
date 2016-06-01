//
//  TRLocationManager.m
//  Demo01_Encapsulate(封装)
//
//  Created by 韩浩 on 16/5/25.
//  Copyright © 2016年 HH. All rights reserved.
//

#import "TRLocationManager.h"
@interface TRLocationManager()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;
//记录用户的位置的block（block属性声明和.h中的block一样）
@property(nonatomic,strong) locationManagerCompletionHandler completionBlock;

//地理编码属性
@property(nonatomic,strong)CLGeocoder *geocoder;
@end

@implementation TRLocationManager
-(void)updateCityWithCompletionHandler:(CityCompletionHandler)completion
{
    
    //先获取用户的位置
    [self updateLocationWithCompletionHandler:^(CLLocation *location, NSError *error) {
        if (!error) {
            [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                CLPlacemark *placemark = [placemarks lastObject];
                NSString *cityName = placemark.addressDictionary[@"City"];
                cityName = [cityName substringToIndex:cityName.length-1];
                completion(cityName,nil);
            }];
        }else{
            completion(nil,error);
        }
    }];

    
}




-(CLLocationManager *)locationManager
{
    if (!_locationManager) {
        //.初始化manager对象
                _locationManager = [[CLLocationManager alloc]init];
        //2.征求用户的同意（ IOS8.0以上  Info.plist）
        [_locationManager requestWhenInUseAuthorization];
        //3.设置代理
        _locationManager.delegate = self;

    }
    return _locationManager;
}



+(instancetype)sharedLocationManager
{
    static TRLocationManager *sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationManager = [[TRLocationManager alloc]init];
    });
    return sharedLocationManager;
}

//在init方法中初始化值（看懂）也可以写在once 里面  只执行一次，一般只这些一次
-(instancetype)init
{
    self = [super init];
    if (self) {
        _location = nil;//点语法 会造成循环引用
        //初始化geocoder(保证线程安全)
        self.geocoder = [CLGeocoder new];
    }
    return self;
}

-(void)updateLocationWithCompletionHandler:(locationManagerCompletionHandler)completion
{
    //判断用户啊是否把“定位功能”打开，如果没有打开，给控制器返回错误
    if(![CLLocationManager locationServicesEnabled]){
        //1.返回一个错误对象，传给completion
        NSError *error = [NSError errorWithDomain:@"cn.terena.location" code:10 userInfo:[NSDictionary dictionaryWithObject:@"location service is disabled" forKey:NSLocalizedDescriptionKey]];
        completion(nil,error);
        //2.直接return
        return;
    }

  
    //调用开始定位
    [self.locationManager startUpdatingLocation];
    //completion赋值给block属性（两个block对象的地址指向同一片内存）
    self.completionBlock = completion;
}
//成功返回用户的位置
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    //获取最新的用户位置
    CLLocation *userLocation = [locations lastObject];
    _location = userLocation;
    //把用户的位置传给compltionBlock属性(调用)
    self.completionBlock(userLocation,nil);
    //把当前的block对象赋值为nil
    self.completionBlock = nil;
    
    
}
//失败返回用户的位置
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //把错误error对象回传
    if(self.completionBlock){
        self.completionBlock(nil,error);
    }
}





@end
