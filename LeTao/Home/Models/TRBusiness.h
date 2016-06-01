//
//  TRBusiness.h
//  LeTao
//
//  Created by 韩浩 on 16/5/30.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRBusiness : NSObject
/** 添加店名**/
@property(nonatomic,copy)NSString* name;
/** 店铺ID**/
@property(nonatomic,strong)NSNumber* id;
/** 添加城市**/
@property(nonatomic,copy)NSString* city;
@property(nonatomic,strong)NSNumber *latitude;
@property(nonatomic,strong)NSNumber *longitude;
/** url**/
@property(nonatomic,copy)NSString* url;
/** h5_url**/
@property(nonatomic,copy)NSString* h5_url;
@end
