//
//  TRMetaDataTool.m
//  LeTao
//
//  Created by tarena on 16/5/26.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRMetaDataTool.h"
#import "TRDeal.h"
#import "TRSort.h"
#import "TRRegion.h"
#import "TRCity.h"
#import "TRBusiness.h"
#import "TRCityGroup.h"
@implementation TRMetaDataTool

+ (NSArray *)parseDealsResult:(id)result {
    //取到deals的key对应数组(字典类型)
    NSArray *dealsArray = result[@"deals"];
    //for循环把字典转成TRDeal; 添加到可变数组中；返回
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dealDic in dealsArray) {
        //创建订单对象
        TRDeal *deal = [TRDeal new];
        //KVC转换
        [deal setValuesForKeysWithDictionary:dealDic];
        [mutableArray addObject:deal];
    }
    
    return [mutableArray copy];
}

static NSArray *_sortsArray = nil;
+ (NSArray *)getAllSorts {
    if (!_sortsArray) {
        _sortsArray = [[self alloc] getAndParseWithPlistFile:@"sorts.plist" withClass:[TRSort class]];
    }
    return _sortsArray;
}

static NSArray *_citiesArray = nil;
+ (NSArray *)getAllCities {
    if (!_citiesArray) {
        _citiesArray = [[self alloc] getAndParseWithPlistFile:@"cities.plist" withClass:[TRCity class]];
    }
    return _citiesArray;
}

//获取categories.plist所有数据
static NSArray *_categoryArray = nil;
+(NSArray *)getAllCategories{
    if (!_categoryArray) {
        _categoryArray = [[self alloc]getAndParseWithPlistFile:@"categories.plist" withClass:[TRCategory class]];
    }
    return _categoryArray;
}
static NSArray *_menuDataArray  = nil;
+(NSArray *)getAllMenuData
{
    if (!_menuDataArray) {
        _menuDataArray = [[self alloc]getAndParseWithPlistFile:@"menuData.plist" withClass:[TRMenuData class]];
    }
    return _menuDataArray;
}

static NSArray *_cityGroupsArray = nil;
+(NSArray *)getAllCityGroups
{
    if (!_cityGroupsArray) {
        _cityGroupsArray = [[self alloc]getAndParseWithPlistFile:@"cityGroups.plist" withClass:[TRCityGroup class]];
    }
    return _cityGroupsArray;
}

+ (NSArray *)getRegionsByCityName:(NSString *)cityName {
    //1.取到所有的城市数组
    NSArray *cityArray = [self getAllCities];
    //2.从城市数组中循环找cityName对应的TRCity
    for (TRCity *city in cityArray) {
        if ([city.name isEqualToString:cityName]) {
            //city.regions:数组中是字典类型
            //调用getArrayWithArray方法，把city.regions数组中的字典转成了TRRegion对象，返回
            return [[self alloc] getArrayWithArray:city.regions withClass:[TRRegion class]];
        }
    }
    return nil;
}



//前提：从plist文件中读数据；数组嵌套字典的样式
- (NSArray *)getAndParseWithPlistFile:(NSString *)plistFileName withClass:(Class)modelClass {
    //plist路径(文件名不一样)
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistFileName ofType:nil];
    //从plist读取数据
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:plistPath];
    NSArray *returnArray = [self getArrayWithArray:plistArray withClass:modelClass];
    return returnArray;
}
//把数组中的字典循环转成模型对象，并返回数组
- (NSArray *)getArrayWithArray:(NSArray *)array withClass:(Class)modelClass {
    //将字典转成模型对象(类型不一样); 返回
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        id model = [modelClass new];
        //KVC转换
        [model setValuesForKeysWithDictionary:dic];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

static NSArray* _getAllBusiness = nil;
+(NSArray *)getAllBusiness:(TRDeal*)deal
{
    NSArray *businessArray = deal.businesses;
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic  in businessArray) {
        TRBusiness *business = [TRBusiness new];
        [business setValuesForKeysWithDictionary:dic];
        [mutableArray addObject:business];
    }
    return [mutableArray copy];
}

+(TRCategory *)getCategoryWithDeal:(TRDeal *)deal
{
    //1.获取服务器返回回来的分类数组
    NSArray *categoryArray = deal.categories;
    //2.获取categories.plist所有分组
    NSArray *categoryArrayFromPlist = [self getAllCategories];
    //3.两层循环
    //服务器返回的分类数据
    for (NSString *categoryStr in categoryArray) {
        //两层循环，plist数组
        for(TRCategory *category in categoryArrayFromPlist){
            //4.判断catrgoryStr是否等于分类的名字，是否等于子分类的名字；如果相等（找到了），返回category对象
            if([categoryStr isEqualToString:category.name]){
                return category;
            }//从子分类数组找
        if ([category.subcategories containsObject:categoryStr]) {
            return category;
        }
        
        }
        
    }
    return nil;
    //4.
}

//存储城市名字静态变量
static NSString* _cityName = nil;
+(void)setSelectedCityName:(NSString *)cityName
{
    _cityName = cityName;
}

+(NSString *)getSelectedCityName
{
    return _cityName;
}

@end
