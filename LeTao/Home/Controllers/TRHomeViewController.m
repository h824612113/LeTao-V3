//
//  TRHomeViewController.m
//  LeTao
//
//  Created by tarena on 16/5/26.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRHomeViewController.h"
#import "TRMapViewController.h"
#import "TRMenuData.h"
#import "TRMetaDataTool.h"
#import "TRCollectionViewCell.h"
#import "TRLocationManager.h"
#import "TRCityGroupTableViewController.h"
#import "TRBaseNavController.h"
#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
static const CGFloat itemWidth = 60;
static const CGFloat topBottomInset = 15;
static const CGFloat interItemSpace  = 10;


@interface TRHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
/**
 *  记录所有菜单数组
 */
@property(nonatomic,strong)NSArray* menuDataArray;
@property(nonatomic,strong)UICollectionView *collectionView;
//记录用户点击label的文本
@property(nonatomic,copy)NSString *categoryName;
//记录用户所在城市的名字
@property(nonatomic,copy)NSString *cityName;
//**pageControl **/
@property(nonatomic,strong)UIPageControl* pageControl;

//记录左上角的item;
@property(nonatomic,strong)UIBarButtonItem *cityItem;
@end


@implementation TRHomeViewController
-(NSArray *)menuDataArray
{
    if (!_menuDataArray) {
        _menuDataArray = [TRMetaDataTool getAllMenuData];
    }
    return _menuDataArray;
}

-(void)viewWillAppear:(BOOL)animated
{
   //使用工具类获取用户选择自定义的城市
    NSString *cityName = [TRMetaDataTool getSelectedCityName];
    if(cityName){
         //更新cityItem的文本
        self.cityItem.title = cityName;
         //更新cityName
        self.cityName = cityName;
            //重新发送请求
        [self loadNewDeals];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //使用子线程定位用户的位置所在的城市
    [self getUserCityName];
    
    
    NSLog(@"%@",self.menuDataArray);
    //创建并添加item
    [self setUpItems];
    
    [self setUpCollectionCiew];
    
}

#pragma mark -----定位相关方法
-(void)getUserCityName{
    //1.创建单例对象
    TRLocationManager *locationMgr = [TRLocationManager sharedLocationManager];
    //2.获取城市的名字，赋值给属性
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [locationMgr updateCityWithCompletionHandler:^(NSString *cityName, NSError *error) {
            if (!error) {
                self.cityName = cityName;
                //使用工具类存储称呼四名字（静态变量）
                [TRMetaDataTool setSelectedCityName:cityName];
                //更新左上角的item的文本？？？
                //重新发送请求（设置参数）
                [self loadNewDeals];
                self.cityItem.title = cityName;
            }else{
                NSLog(@"无法定位位置：%@",error);
            }
        }];
    
}

#pragma mark -- 和界面相关的方法
-(void)setUpCollectionCiew{

    //2.collectionView  高？？？？
    //创建流水布局对象
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    //坑：默认流水布局对应的item的大小为50x50;需要重新把item的大小赋值为期望大小
    
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    [layout setScrollDirection:  UICollectionViewScrollDirectionHorizontal];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, itemWidth*2+2*topBottomInset+interItemSpace+50) collectionViewLayout:layout];
    //1.创建一个UIView(两个控件：collectionView+pageControll)
    
    
    //？？？？高不对
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, self.collectionView.bounds.size.height+30)];
//    view.backgroundColor = [UIColor redColor];
    
    self.collectionView.dataSource= self;
    self.collectionView.delegate = self;
    //隐藏水平滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    //paging属性
    self.collectionView.pagingEnabled = YES;
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"TRCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
//    self.collectionView.backgroundColor = [UIColor blueColor];
    //添加view上
    [view addSubview:self.collectionView];
    //3.pageControl
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2, view.bounds.size.height -30, 20, 20)];
    //设置页总数/当前页
    self.pageControl.numberOfPages = 2;
    self.pageControl.currentPage        =0;
    //设置点dot高亮颜色/非高亮颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    self.pageControl.pageIndicatorTintColor             =  [UIColor grayColor];
    //添加到view
    [view addSubview:self.pageControl];
    //把view设置成tableview的头部视图
    self.tableView.tableHeaderView = view;
    
    
}


- (void)setUpItems {
    //左上角（触发事件+更新item的文本）
    self.cityItem = [[UIBarButtonItem alloc]initWithTitle:@"位置" style:(UIBarButtonItemStyleDone) target:self action:@selector(clickCityItem)];
    self.navigationItem.leftBarButtonItem = self.cityItem;
    
    
    
    //右上角item
    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_map"] style:UIBarButtonItemStyleDone target:self action:@selector(clickMapItem)];
    self.navigationItem.rightBarButtonItem = mapItem;
}
-(void)clickCityItem{
    //创建城市组控制器
    TRBaseNavController *navController = [[TRBaseNavController alloc]initWithRootViewController:[TRCityGroupTableViewController new]];
    //显示
    [self presentViewController:navController animated:YES completion:nil];


}



- (void)clickMapItem {
    TRMapViewController *mapViewController = [TRMapViewController new];
    [self.navigationController pushViewController:mapViewController animated:YES];
}

//实现父类声明的设置请求参数的方法
- (void)settingRequestParams:(NSMutableDictionary *)params {
#warning TODO:city和category是hard code(硬编码)
    if (self.cityName) {
        params[@"city"] = self.cityName;
    }else{
//        默认推送北京
            params[@"city"] = @"上海";
    }
    if (self.categoryName) {
        //如果用户选择了分类，赋值给category参数
        params[@"category"] = self.categoryName;
    }else{
        //默认推送美食这个分类
            params[@"category"] = @"美食";
    }
    

}


#pragma mark------UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //需求：设定currentPage是0还是1；
    int pageValue = scrollView.contentOffset.x /scrollView.frame.size.width +0.5;
    self.pageControl.currentPage = pageValue;
}


#pragma mark--------UICollectionView相关方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.menuDataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TRCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
//数据源
       TRMenuData *menuData = self.menuDataArray[indexPath.row];
    //设置cell的image和label
    cell.cellImageView.image = [UIImage imageNamed:menuData.image];
    cell.cellLabel.text = menuData.title;
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //取出用户点击的TRMenuData
    TRMenuData *memuData = self.menuDataArray[indexPath.row];
    //赋值给分类属性
    self.categoryName = memuData.title;
    //重新发送请求（调动settingRequestParams方法）
    [self loadNewDeals];
}

#pragma mark ----------FlowLayout Delegate

//如何区分
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    //需求：横着只有四个item;竖着是两个
//行间距是横着的两个item的距离；（水平滑动）
    //8x+4*
    return kSCREEN_WIDTH*0.25 - itemWidth;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    //垂直方向的两个item的最小间距
    return interItemSpace;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat halfLineSpaceing = kSCREEN_WIDTH/8 - itemWidth/2;
    return     UIEdgeInsetsMake(topBottomInset, halfLineSpaceing, topBottomInset, halfLineSpaceing);
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
