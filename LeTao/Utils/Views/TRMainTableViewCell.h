//
//  TRMainTableViewCell.h
//  LeTao
//
//  Created by Xiao on 16/1/31.
//  Copyright © 2016年 Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRDeal.h"

@interface TRMainTableViewCell : UITableViewCell
//父类控制器的数据源就是TRDeal类型
@property (nonatomic, strong) TRDeal *deal;








@end
