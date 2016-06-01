//
//  TRRegion.h
//  LeTao
//
//  Created by tarena on 16/5/27.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRRegion : NSObject

/** 主区域的名字*/
@property (nonatomic, copy) NSString *name;
/** 对应主区域的所有子区域的数组*/
@property (nonatomic, strong) NSArray *subregions;













@end
