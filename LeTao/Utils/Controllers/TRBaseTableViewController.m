//
//  TRBaseTableViewController.m
//  LeTao
//
//  Created by tarena on 16/5/26.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRBaseTableViewController.h"
#import "DPAPI.h"
#import "TRMetaDataTool.h"
#import "TRDeal.h"
#import "MJRefresh.h"
#import "TRMainTableViewCell.h"

@interface TRBaseTableViewController ()<UITableViewDataSource, UITableViewDelegate, DPRequestDelegate>
//存储服务器返回的所有订单(可变：适应上拉加载逻辑)
@property (nonatomic, strong) NSMutableArray *dealsArray;
//记录当前的页数
@property (nonatomic, assign) int page;
//记录用户最后一次(最新)请求对象
@property (nonatomic, strong) DPRequest *latestRequest;
@end
/* 功能：设置参数；发送请求；获取数据；显示tableView上
 */
@implementation TRBaseTableViewController
- (NSMutableArray *)dealsArray {
    if (!_dealsArray) {
        _dealsArray = [NSMutableArray array];
    }
    return _dealsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建tableView并添加
    [self setUpTableView];
    //注册单元格(自定义)
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"deal"];

    [self.tableView registerNib:[UINib nibWithNibName:@"TRMainTableViewCell" bundle:nil] forCellReuseIdentifier:@"deal"];
    //创建并添加上拉/下拉控件
    [self addRefreshControl];
//    //发送请求
//    [self sendRequestToServer];
}
#pragma mark -- 和界面相关的方法
- (void)addRefreshControl {
    //下拉控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDeals)];
    //添加完之后，同时执行selector
    [self.tableView.mj_header beginRefreshing];
    //上拉控件(加载新数据)
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
}

- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    [self.view addSubview:self.tableView];
}

#pragma mark -- 和网络相关的方法
//下拉触发方法
- (void)loadNewDeals {
    self.page = 1;
    //发送请求
    [self sendRequestToServer];
}
//上拉触发方法
- (void)loadMoreDeals {
    self.page++;
    [self sendRequestToServer];
}
- (void)sendRequestToServer {
    DPAPI *api = [DPAPI new];
    //2.创建可变字典，设置发送请求的参数
    /*首页控制器参数: city+category
      商家控制器参数：city+category+region+sort
      搜索控制器参数：city+keyword
     */
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    [self settingRequestParams:mutableDic];
    //设置page参数
    mutableDic[@"page"] = @(self.page);
    NSLog(@"请求的参数是:%@", mutableDic);
    //3.发送请求
    self.latestRequest = [api requestWithURL:@"v1/deal/find_deals" params:mutableDic delegate:self];
}
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    //如果服务器返回的request不是最新的，直接返回
    if (self.latestRequest != request) {
        return;
    }
    NSArray *array = [TRMetaDataTool parseDealsResult:result];
    if (self.page == 1) {
        //是新发送的请求，不是上拉的请求
        [self.dealsArray removeAllObjects];
    }
    //array添加到可变数组中
    [self.dealsArray addObjectsFromArray:array];
    //刷新数据源
    [self.tableView reloadData];
    //停止下拉刷新控件动画
    [self.tableView.mj_header endRefreshing];
    //停止上拉刷新控件动画
    [self.tableView.mj_footer endRefreshing];
}
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"服务器返回失败");
    //停止下拉刷新控件动画
    [self.tableView.mj_header endRefreshing];
    //停止上拉刷新控件动画
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark -- UITableView相关方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dealsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TRMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deal" forIndexPath:indexPath];
    //数据源
    TRDeal *deal = self.dealsArray[indexPath.row];
    //deal对象直接给TRMainTableViewCell的deal属性
    cell.deal = deal;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}





@end
