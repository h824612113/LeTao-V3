//
//  TRSearchViewController.m
//  LeTao
//
//  Created by tarena on 16/5/26.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRSearchViewController.h"
#import "TRMetaDataTool.h"
@interface TRSearchViewController ()<UISearchBarDelegate>
@property(nonatomic,copy)NSString *cityName;
@end

@implementation TRSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//.直接调用工具类get的方法（每次push进来都会重新创建控制器对象）
    self.cityName = [TRMetaDataTool getSelectedCityName];
    //UISearchBar添加一个假的item(占位)
    UIBarButtonItem *fakeItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem = fakeItem;
    
    //1.创建UISearchBar控件；添加到navigationItem上
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    //设置提示文本
    searchBar.placeholder = @"请输入商户名、商品名或地址";
    searchBar.delegate = self;
    //添加
    self.navigationItem.titleView = searchBar;
}
//3.发送请求(用户点击软键盘的search搜索按钮的时机)
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //发送请求
    [self loadNewDeals];
    //收回软键盘
    [searchBar resignFirstResponder];
}
//2.获取用户界面上输入的关键词; 设置参数(settingRequestParams方法)
- (void)settingRequestParams:(NSMutableDictionary *)params {
    //硬编码city
#warning TODO: 设置城市的名字
    if (self.cityName) {
        params[@"city"] = @"南京";
    }else {
        //默认推送北京市的订单
        params[@"city"] = @"北京";
    }
    //获取用户界面上输入的文本(keyword)
    UISearchBar *searchBar = (UISearchBar *)self.navigationItem.titleView;
    //如果用户输入了文本
    if (searchBar.text.length) {
        params[@"keyword"] = searchBar.text;
    } else {
        //默认推送一个关键词(用户没有输入文本)
        params[@"keyword"] = @"ktv";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
