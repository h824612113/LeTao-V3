//
//  TRCityGroupTableViewController.m
//  WeatherForecast
//
//  Created by tarena on 16/1/16.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "TRCityGroupTableViewController.h"
#import "TRMetaDataTool.h"
#import "TRCityGroup.h"
#import "AppDelegate.h"

@interface TRCityGroupTableViewController ()
@property (nonatomic, strong) NSArray *cityGroupArray;

//delegate对象
@property (nonatomic, strong) AppDelegate *delegate;

@end

@implementation TRCityGroupTableViewController

- (NSArray *)cityGroupArray {
    if (!_cityGroupArray) {
        _cityGroupArray = [TRMetaDataTool getAllCityGroups];
    }
    return _cityGroupArray;
}

- (AppDelegate *)delegate {
    if (!_delegate) {
        _delegate = [[UIApplication sharedApplication] delegate];
    }
    return _delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"城市列表";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(clickBackItem)];
    self.navigationItem.leftBarButtonItem = backItem;

}
- (void)clickBackItem {
    //收回控制器
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityGroupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TRCityGroup *cityGroup = self.cityGroupArray[section];
    return cityGroup.cities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    // Configure the cell...
    TRCityGroup *cityGroup = self.cityGroupArray[indexPath.section];
    cell.textLabel.text = cityGroup.cities[indexPath.row];
    
    return cell;
}
//返回section的头部文本
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    TRCityGroup *cityGroup = self.cityGroupArray[section];
    return cityGroup.title;
}

//返回tableViewIndex数组
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //方式一
//    NSMutableArray *titleMutablArray = [NSMutableArray array];
//    for (TRCityGroup *cityGroup in self.cityGroupArray) {
//        [titleMutablArray addObject:cityGroup.title];
//    }
//    return [titleMutablArray copy];
    //方式二
    return [self.cityGroupArray valueForKeyPath:@"title"];
    
}

//选中那一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取模型对象
    TRCityGroup *cityGroup = self.cityGroupArray[indexPath.section];
    //发送通知，包含参数(选择的城市名字) -> 这个通知只有

    //设置选择的哪个城市
    [TRMetaDataTool setSelectedCityName:cityGroup.cities[indexPath.row]];

    //收回控制器
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
