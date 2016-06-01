//
//  TRCollectionViewCell.h
//  LeTao
//
//  Created by 韩浩 on 16/5/31.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRCollectionViewCell : UICollectionViewCell
//显示图片的视图
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
//系那是文本的label
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;

@end
