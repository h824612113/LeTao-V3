//
//  TRSortViewController.m
//  LeTao
//
//  Created by tarena on 16/5/27.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRSortViewController.h"
#import "TRMetaDataTool.h"
#import "TRSort.h"

@interface TRSortViewController ()
//记录所有的排序数组
@property (nonatomic, strong) NSArray *sortsArray;

@end

//即限定作用域，又限定是常量
static const CGFloat buttonWidth  = 100;
static const CGFloat buttonHeight = 30;
static const CGFloat inset = 20;//上下间隔

@implementation TRSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //数据源
    self.sortsArray = [TRMetaDataTool getAllSorts];
    //循环创建并添加UIButton
    for (int index = 0; index < self.sortsArray.count; index++) {
        UIButton *button = [UIButton new];
        button.frame = CGRectMake(inset, index*(buttonHeight+inset)+inset, buttonWidth, buttonHeight);
        //设置两个背景图片
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        //适当地修改一下选中的背景颜色
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        //设置文本的颜色/字体大小
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        //设置button文本
        TRSort *sort = self.sortsArray[index];
        [button setTitle:sort.label forState:UIControlStateNormal];
        //设置button的tag值
        button.tag = 1000+index;
        //添加触发事件
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        //添加button
        [self.view addSubview:button];
    }
    //设置view的宽和高
    self.preferredContentSize = CGSizeMake(2*inset+buttonWidth, self.sortsArray.count*(inset+buttonHeight)+inset);
}
//触发方法
- (void)clickButton:(UIButton *)button {
    //1.发送通知，带参数(用户选择的按钮对应的值sort)
    //for循环index -> TRSort -> sort对象
    TRSort *sort = self.sortsArray[button.tag - 1000];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRSortDidChange" object:self userInfo:@{@"TRSort" : sort}];
    //2.收回控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
