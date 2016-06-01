//
//  TRDeal.m
//  LeTao
//
//  Created by tarena on 16/5/26.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRDeal.h"

@implementation TRDeal
//手动的方式把字典的description的key，绑定/对应到desc这个属性
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    //key是字典的key； value是字典的key对应的值
    if ([key isEqualToString:@"description"]) {
        //value赋值给desc属性
        self.desc = value;
    }
}







@end
