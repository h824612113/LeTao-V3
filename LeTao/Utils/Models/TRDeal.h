//
//  TRDeal.h
//  LeTao
//
//  Created by tarena on 16/5/26.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRDeal : NSObject
//声明10个属性(界面需要10个)
/** 订单的标题*/
@property (nonatomic, copy) NSString *title;
///** 订单的详细描述*/
@property (nonatomic, copy) NSString *desc;
/** 订单的原价格*/
@property (nonatomic, strong) NSNumber *list_price;
/** 订单的团购价格*/
@property (nonatomic, strong) NSNumber *current_price;
/** 订单所属分类数组*/
@property (nonatomic, strong) NSArray *categories;
/** 订单购买数量*/
@property (nonatomic, strong) NSNumber *purchase_count;
/** 订单大图*/
@property (nonatomic, copy) NSString *image_url;
/** 订单小图*/
@property (nonatomic, copy) NSString *s_image_url;
/** 订单详情h5页面*/
@property (nonatomic, copy) NSString *deal_h5_url;
/** 订单可使用的商家数组*/
@property (nonatomic, strong) NSArray *businesses;













@end
