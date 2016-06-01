//
//  TRLocationManager.h
//  Demo01_Encapsulate(封装)
//
//  Created by 韩浩 on 16/5/25.
//  Copyright © 2016年 HH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef void(^locationManagerCompletionHandler) (CLLocation* location,NSError *error);//类型声明
typedef void (^CityCompletionHandler)(NSString* cityName,NSError *error);

@interface TRLocationManager : NSObject
//返回已经存储的用户的位置（目的：只是获取用户的位置）
@property(nonatomic,readonly)CLLocation *location;//OC默认nil
//返回单例类方法(GCD)
+(instancetype)sharedLocationManager;
//给定block参数，获取用户位置
-(void)updateLocationWithCompletionHandler:(locationManagerCompletionHandler)completion;

//返回所在位置对应的城市名字（去掉市字）
-(void)updateCityWithCompletionHandler:(CityCompletionHandler)completion;//completion 是参数
@end
