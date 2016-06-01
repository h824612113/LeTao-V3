//
//  TRBusinessViewController.m
//  LeTao
//
//  Created by tarena on 16/5/26.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRBusinessViewController.h"
#import "TRBusinessHeaderView.h"
#import "UIView+Extension.h"
#import "TRSortViewController.h"
#import "TRRegionViewController.h"
#import "TRSort.h"
#import "TRRegion.h"
#import "TRSearchViewController.h"

@interface TRBusinessViewController ()<UIPopoverPresentationControllerDelegate>
//头部视图
@property (nonatomic, strong) TRBusinessHeaderView *headerView;
//排序控制器
@property (nonatomic, strong) TRSortViewController *sortViewController;
//区域控制器
@property (nonatomic, strong) TRRegionViewController *regionViewController;
//记录排序的值(提交代码使用int类型)
@property (nonatomic, strong) NSNumber *selectedSort;
//记录主区域的名字
@property (nonatomic, copy) NSString *selectedRegion;
//记录子区域的名字
@property (nonatomic, copy) NSString *selectedSubRegion;
@end

@implementation TRBusinessViewController
//原因：商家控制器持有排序控制器对象,在整个程序生命周期内只有一个排序控制器对象
- (TRSortViewController *)sortViewController {
    if (!_sortViewController) {
        _sortViewController = [TRSortViewController new];
    }
    return _sortViewController;
}
//懒加载创建区域控制器
- (TRRegionViewController *)regionViewController {
    if (!_regionViewController) {
        _regionViewController = [TRRegionViewController new];
    }
    return _regionViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建并添加item
    [self setUpTwoItems];
    //创建并添加自定义的头部视图
    [self setUpHeaderView];
    //为头部视图的三个按钮分别添加事件
    [self addTargetsForButton];
    //监听通知
    [self listenNotifications];
}
#pragma mark -- 和通知相关的方法
- (void)listenNotifications {
    //排序
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortDidChange:) name:@"TRSortDidChange" object:nil];
    //区域
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regionDidChange:) name:@"TRRegionDidChange" object:nil];
    //分类
    //城市
}
- (void)regionDidChange:(NSNotification *)notification {
    //取回主区域+子区域
    TRRegion *region = notification.userInfo[@"TRRegion"];
    NSString *subRegion = notification.userInfo[@"TRSubRegion"];
    //重新设置参数(排除"全部")
    if ([region.name isEqualToString:@"全部"]) {
        //左边的“全部”;赋值为nil->发送该整个城市的订单
        self.selectedRegion = nil;
    } else {
        //左边没有点"全部"；如果右边点"全部"
        if ([subRegion isEqualToString:@"全部"]) {
            //把主区域的名字赋值给属性
            self.selectedRegion = region.name;
            //Bug:把子区域的名字赋值为空
            self.selectedSubRegion = nil;
        } else {
            //和“全部”没有关系(劲松/潘家园)
            self.selectedSubRegion = subRegion;
        }
    }

    //重新发送请求
    [self loadNewDeals];
}
- (void)sortDidChange:(NSNotification *)notification {
    //取出排序的对象
    TRSort *sort = notification.userInfo[@"TRSort"];
    //重新设置参数
    self.selectedSort = sort.value;
    //重新发送请求
    [self loadNewDeals];
}

#pragma mark -- 和界面相关的方法
- (void)setUpTwoItems {
    //右上角的item
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search"] style:UIBarButtonItemStyleDone target:self action:@selector(clickSearchItem)];
    self.navigationItem.rightBarButtonItem = searchItem;
}

- (void)clickSearchItem {
    //1.创建搜索控制器对象
    TRSearchViewController *searchViewController = [TRSearchViewController new];
    //2.跳转push
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (void)addTargetsForButton {
    //为排序按钮添加action
    [self.headerView.sortButton addTarget:self action:@selector(clickSortButton) forControlEvents:UIControlEventTouchUpInside];
    //为区域按钮添加action
    [self.headerView.regionButton addTarget:self action:@selector(clickRegionButton) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setUpHeaderView {
    //1.实例化xib文件的视图对象
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"TRBusinessHeaderView" owner:self options:nil] firstObject];
    self.headerView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 50);
    //2.添加到view上
    [self.view addSubview:self.headerView];
    //3.修改父类的tableView属性的y值(第三方库)
    self.tableView.y = 50;
}

#pragma mark -- 按钮的触发方法
- (void)clickSortButton {
    //1.获取要弹出控制器
    //2.设置一些属性(指定显示哪个控件;指定具体显示在哪;箭头的方向)
    self.sortViewController.modalPresentationStyle = UIModalPresentationPopover;//带anchor锚点的样式
    //指向相对显示区域
    self.sortViewController.popoverPresentationController.sourceView = self.headerView.sortButton;
    //指定相对于排序button具体的位置
    self.sortViewController.popoverPresentationController.sourceRect = self.headerView.sortButton.bounds;
    //箭头的显示方向(默认指定Any枚举值:自动找最优的方向)
    self.sortViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    //设置代理(iPhone需要；iPad不需要)
    self.sortViewController.popoverPresentationController.delegate = self;
    //3.显示弹出控制器
    [self presentViewController:self.sortViewController animated:YES completion:nil];
}

- (void)clickRegionButton {
    self.regionViewController.modalPresentationStyle = UIModalPresentationPopover;
    _regionViewController.popoverPresentationController.sourceView = self.headerView.regionButton;
    _regionViewController.popoverPresentationController.sourceRect = self.headerView.regionButton.bounds;
    _regionViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    _regionViewController.popoverPresentationController.delegate = self;
    [self presentViewController:_regionViewController animated:YES completion:nil];
}
#pragma mark -- UIPresentationDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (void)settingRequestParams:(NSMutableDictionary *)params {
#warning TODO: 硬编码
    //city+category+region+sort
    params[@"city"]     = @"上海";
    params[@"category"] = @"美食";
    
    //最外层if判定用户是否选择了区域
    if (self.selectedRegion) {
        //选择了区域
        if (self.selectedSubRegion) {
            //有子区域
            params[@"region"] = self.selectedSubRegion;//劲松/潘家园
        } else {
            //没有子区域
            params[@"region"] = self.selectedRegion;//主区域的名字
        }
    }
    
    if (self.selectedSort) {
        //用户已经选择的排序按钮；因为默认不给sort值，服务器自动返回的是“默认排序”
        params[@"sort"] = self.selectedSort;
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
