//
//  ViewController.m
//  LeTao
//
//  Created by tarena on 16/5/26.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ViewController.h"
#import "DPAPI.h"
#import "TRMetaDataTool.h"

@interface ViewController ()<DPRequestDelegate>
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //1.创建DPAPI对象
    DPAPI *api = [[DPAPI alloc] init];
    //2.设置请求参数
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    //2.1 city参数必须设置(默认请求第一页；默认返回20条数据)
    paramsDic[@"city"] = @"北京";
    //2.2 添加第三组可选参数
    paramsDic[@"region"]   = @"朝阳区";
    paramsDic[@"category"] = @"美食";
    paramsDic[@"sort"]     = @2; //API文档设置好的
    //3.发送请求
    [api requestWithURL:@"v1/deal/find_deals" params:paramsDic delegate:self];
}

//成功返回
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
//    NSLog(@"线程:%@; result:%@", [NSThread currentThread], result);
    NSArray *dealsArray = [TRMetaDataTool parseDealsResult:result];
    //显示在界面上

}
//失败返回
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"返回失败:%@", error);
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
