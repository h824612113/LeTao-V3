//
//  TRRegionViewController.m
//  LeTao
//
//  Created by tarena on 16/5/27.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRRegionViewController.h"
#import "TRMetaDataTool.h"
#import "TRMetaDataView.h"
#import "TRRegion.h"
#import "TRTableViewCell.h"

@interface TRRegionViewController ()<UITableViewDataSource, UITableViewDelegate>
//记录某个城市的所有区域数据
@property (nonatomic, strong) NSArray *regionArray;
//视图
@property (nonatomic, strong) TRMetaDataView *metaDataView;
//记录用户左边选中的区域对象
@property (nonatomic, strong) TRRegion *selectedRegion;
@end
@implementation TRRegionViewController

//获取城市的名自，更新数据源；刷新两个表视图
-(void)viewWillAppear:(BOOL)animated{
    NSString *cityName = [TRMetaDataTool getSelectedCityName];
    if (cityName) {
           self.regionArray = [TRMetaDataTool getRegionsByCityName:cityName];
    }else{
        //默认推送北京城市
            self.regionArray = [TRMetaDataTool getRegionsByCityName:@"南京"];
    }
//常熟市没有任何区
    if(self.regionArray.count>0){
        //刷新数据
        [_metaDataView.mainTableView reloadData];
        [_metaDataView.subTableView reloadData];
    }
        
}
- (void)viewDidLoad {
    [super viewDidLoad];
#warning TODO: 设置城市

    //实例化并添加自定义视图
    [self addMetaDataView];
}
#pragma mark -- 和界面相关的方法
- (void)addMetaDataView {
    //添加
    self.metaDataView = [[[NSBundle mainBundle] loadNibNamed:@"TRMetaDataView" owner:self options:nil] firstObject];
    _metaDataView.frame = self.view.bounds;
    //设置tableView的属性
    _metaDataView.mainTableView.dataSource = self;
    _metaDataView.mainTableView.delegate   = self;
    _metaDataView.subTableView.dataSource  = self;
    _metaDataView.subTableView.delegate    = self;
    
    [self.view addSubview:_metaDataView];
}

#pragma mark -- UITableView相关协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //如果是左边的表视图
    if (tableView == self.metaDataView.mainTableView) {
        return self.regionArray.count;
    } else {
        //V2:
//        return self.selectedRegion.subregions.count;
        //右边的表视图
        //获取左边用户点击的行号(行号和数组下标一一对应)
        NSInteger selectedRow = [_metaDataView.mainTableView indexPathForSelectedRow].row;
        //取出选中行对应的TRRegion
        TRRegion *region = self.regionArray[selectedRow];
        return region.subregions.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //namespace:命名空间
    if (tableView == _metaDataView.mainTableView) {
        //左表视图
        TRTableViewCell *cell = [TRTableViewCell cellWithTableView:tableView withImageName:@"bg_dropdown_leftpart" withSelectedName:@"bg_dropdown_left_selected"];
        //数据源
        TRRegion *region = self.regionArray[indexPath.row];
        //设置cell
        cell.textLabel.text = region.name;
        
        if (region.subregions.count > 0) {
            //有子区域(右箭头)
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
        
    } else {
        //右表视图
        //cell背景图片
        TRTableViewCell *cell = [TRTableViewCell cellWithTableView:tableView withImageName:@"bg_dropdown_rightpart" withSelectedName:@"bg_dropdown_right_selected"];
        //V2:
//        cell.textLabel.text = self.selectedRegion.subregions[indexPath.row];
//        return cell;
        
        //cell文本
        NSInteger selectedRow = [_metaDataView.mainTableView indexPathForSelectedRow].row;
        TRRegion *region = self.regionArray[selectedRow];
        cell.textLabel.text = region.subregions[indexPath.row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //V2:和下面if和else关系
//    self.selectedRegion = self.regionArray[indexPath.row];
    
    //两件事情：发送通知(带参数)+收回控制器
    if (tableView == _metaDataView.mainTableView) {
        //刷新右边tableView
        [_metaDataView.subTableView reloadData];
        //情况一：没有子区域(参数：主区域对象)
        //获取用户选中左边的区域对象
        TRRegion *region = self.regionArray[indexPath.row];
        if (region.subregions.count == 0) {
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TRRegionDidChange" object:self userInfo:@{@"TRRegion" : region}];
            //收回控制器
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        //情况二：有子区域(参数：主区域对象+子区域对象)
        //左边的行号
        NSInteger leftRow = [_metaDataView.mainTableView indexPathForSelectedRow].row;
        //右边的行号
        NSInteger rightRow = [_metaDataView.subTableView indexPathForSelectedRow].row;
        //主区域的对象
        TRRegion *region = self.regionArray[leftRow];
        //子区域的名字(cities.plist)
        NSString *subRegion = region.subregions[rightRow];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TRRegionDidChange" object:self userInfo:@{@"TRRegion" : region, @"TRSubRegion" : subRegion}];
        
        //收回控制器
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
