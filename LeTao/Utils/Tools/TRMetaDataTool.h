//
//  TRMetaDataTool.h
//  LeTao
//
//  Created by tarena on 16/5/26.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRDeal.h"
#import "TRCategory.h"
#import "TRMenuData.h"
@interface TRMetaDataTool : NSObject

//返回所有订单数组，给定服务器返回的result(JSON数据)
+ (NSArray *)parseDealsResult:(id)result;

//返回所有排序数组(TRSort)
+ (NSArray *)getAllSorts;

//返回所有城市数组(TRCity)
+ (NSArray *)getAllCities;

//给定城市的名字, 返回该城市的所有区域数组(TRRegion)
+ (NSArray *)getRegionsByCityName:(NSString *)cityName;

+(NSArray *)getAllBusiness:(TRDeal*)deal;

//给定订单对象，返回该订单所属分类
+(TRCategory*)getCategoryWithDeal:(TRDeal*)deal;
// 返回所有首页控制器需要的菜单数组(TRMenuData)
+(NSArray*)getAllMenuData;

//设置城市的名字（用户所在城市，或者用户自定义选择的城市）
+(void)setSelectedCityName:(NSString*)cityName;
//获取城市的名字
+(NSString*)getSelectedCityName;


//返回所有城市组数组（TRCityGroup）静态
+(NSArray*)getAllCityGroups;

@end
