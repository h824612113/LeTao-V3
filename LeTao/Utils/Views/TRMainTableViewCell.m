//
//  TRMainTableViewCell.m
//  LeTao
//
//  Created by Xiao on 16/1/31.
//  Copyright © 2016年 Xiao. All rights reserved.
//

#import "TRMainTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface TRMainTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *dealImageView;
@property (weak, nonatomic) IBOutlet UILabel *dealDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *discountButton;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;

@end

@implementation TRMainTableViewCell

- (void)setDeal:(TRDeal *)deal {
    //整个cell的背景图片
//    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
    //图片
    [self.dealImageView sd_setImageWithURL:[NSURL URLWithString:deal.s_image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    //订单描述
    self.dealDescLabel.text = deal.title;
    //团购价格
    self.currentPriceLabel.text = [NSString stringWithFormat:@"¥%@", deal.current_price];
    //原价
    self.listPriceLabel.text = [NSString stringWithFormat:@"¥%@", deal.list_price];
    //计算折扣
    float discountValue = [deal.current_price floatValue] / [deal.list_price floatValue] * 100;
    [self.discountButton setTitle:[NSString stringWithFormat:@"%.02f%%折扣", discountValue] forState:UIControlStateNormal];
    //已售出
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售%@", deal.purchase_count];
}

- (void)awakeFromNib {
    // Initialization code
    
    //取消discountButton的交互
//    self.discountButton.enabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
