//
//  TRAnnotation.h
//  LeTao
//
//  Created by 韩浩 on 16/5/30.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface TRAnnotation : NSObject<MKAnnotation>
@property(nonatomic)CLLocationCoordinate2D coordinate;
/** 添加标题**/
@property(nonatomic,copy)NSString* title;
/** 添加副标题**/
@property(nonatomic,copy)NSString* subtitle;
//**添加自定义图片属性 **/
@property(nonatomic,strong)UIImage* image;
@end
