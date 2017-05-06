//
//  MainViewController.m
//  test-2
//
//  Created by hundred wang on 17/4/13.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "MainViewController.h"
#import "FlodingLayout.h"
#import "MainCollectionViewCell.h"
#import "AFNetworkTool.h"
#import "YYMainArticalModel.h"
#import "SDWebImageDownloader.h"
#import "YYSettingView.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "ActivityViewController.h"
#import "NewActivityViewController.h"

#import "YYCategoryModel.h"

#import "TestScrollView.h"
#import "YYCategoryView.h"

static NSString* const reuseIdentifier = @"cell";

static CGFloat const kleftViewWidth = 100;

@interface MainViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, YYCategoryViewDelegate>{
    CGPoint _startPt;
    int16_t _pagenum;
}

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) YYCategoryView * leftView;

@property (nonatomic, strong) YYSettingView * rightView;

@property (nonatomic, strong) UIScrollView * topView;


@end

@implementation MainViewController

#pragma mark - lazy method

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (YYCategoryView *)leftView{
    if (!_leftView) {
        _leftView = [[YYCategoryView alloc] initWithFrame:CGRectMake(-Screen_Width * 0.5, 0, Screen_Width * 0.5, Screen_Height)];
        _leftView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:_leftView];
    }
    return _leftView;
}


- (YYSettingView *)rightView{
    if (!_rightView) {
//        _rightView = [[YYSettingView alloc] init];
//        _rightView.frame = CGRectMake(Screen_Width, 0, Screen_Width, Screen_Height);

        _rightView = [[YYSettingView alloc] initWithFrame:CGRectMake(Screen_Width, 0, Screen_Width, Screen_Height)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
           [UIView animateWithDuration:0.2 animations:^{
               _rightView.left = Screen_Width;
           } completion:^(BOOL finished) {
               //重置动画
               [_rightView reset];
           }];
        }];
        [_rightView addGestureRecognizer:tap];
        
    }
    return _rightView;
}

- (UIScrollView *)topView{
    if (!_topView) {
        _topView = [[TestScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        _topView.contentSize = CGSizeMake(kleftViewWidth + Screen_Width * 2, Screen_Height - 20);
        [_topView.panGestureRecognizer addTarget:self action:@selector(scrollTopView:)];
        [_topView setContentOffset:CGPointMake(kleftViewWidth, 0)];
        //        _topView.panGestureRecognizer.delegate = self;
        [_collectionView.panGestureRecognizer requireGestureRecognizerToFail:_topView.panGestureRecognizer];
        [[UIApplication sharedApplication].keyWindow addSubview:_topView];
        
        _topView.userInteractionEnabled = NO;
    }
    return _topView;
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupNav];
    
    [self addUserAgentForSDWeb];
    
    [self initCollectionView];
    
    [self getCatList];
    
//    [self.topView addSubview:self.rightView];
    
    NSLog(@"Test");
    
}

- (void)setupNav{
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    UIImageView *centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 154, 24)];
    centerImageView.image = [UIImage imageNamed:@"logo_red"];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 25, 25)];
    [leftBtn setImage:[UIImage imageNamed:@"leftbut"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 25, 25)];
    [rightBtn setImage:[UIImage imageNamed:@"rightbut"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [leftBtn addTarget:self action:@selector(showCategoryView) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn  addTarget:self action:@selector(showSettingView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = centerImageView;
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)addUserAgentForSDWeb{
    //    @"ELLEMEN%E7%9D%BF%E5%A3%AB/2.5 CFNetwork/711.1.16 Darwin/14.0.0"
    
    //这里shezhi代理
    //    [[SDWebImageDownloader sharedDownloader] setValue:@"ELLEMEN%E7%9D%BF%E5%A3%AB/2.5 CFNetwork/711.1.16 Darwin/14.0.0" forHTTPHeaderField:@"User-Agent"];
    
    
    NSString* userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", @"ELLEMEN%E7%9D%BF%E5%A3%AB", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    
    [[SDWebImageDownloader sharedDownloader] setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
}

- (void)initCollectionView{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[[FlodingLayout alloc] init]];
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerClass:[MainCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    @weakify(self)
    collectionView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weak_self getRecentData];
    }];
    
    [collectionView.mj_header beginRefreshing];
    
}

/*
#pragma mark - UITouch-Event

//it not work
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.leftView.left == 0) [self hiddenCategoryView];
}
*/

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    
    //这里开启加载更多
    if (indexPath.row == self.dataArray.count - 2) [self getMoreData];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.leftView.left == 0) [self hiddenCategoryView];
    
    YYMainArticalModel *model = self.dataArray[indexPath.row];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - YYCategoryViewDelegate

- (void)categoryView:(YYCategoryView *)categoryView didSelectRowAtIndexPath:(NSInteger)index{
    [self hiddenCategoryView];
    if (index == 1) {
//        ActivityViewController *vc = [[ActivityViewController alloc] init];
//        [self presentViewController:vc animated:YES completion:nil];
        
        NewActivityViewController *newVC = [[NewActivityViewController alloc] init];
        [self presentViewController:newVC animated:YES completion:nil];
    }
}

#pragma mark - Button-Method

- (void)showCategoryView{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.leftView.left = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hiddenCategoryView{
    [UIView animateWithDuration:0.2 animations:^{
        self.leftView.left = -Screen_Width * 0.5;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showSettingView{
    
    if (self.leftView.left == 0) [self hiddenCategoryView];
    
    if (!self.rightView.superview) [[UIApplication sharedApplication].keyWindow addSubview:self.rightView];
    [UIView animateWithDuration:0.2 animations:^{
        self.rightView.left = 0;
    } completion:^(BOOL finished) {
        [self.rightView showAnimation];
    }];
}

#pragma mark - PanGesture-Method

- (void)scrollTopView:(UIPanGestureRecognizer*)gesture{
    
}

#pragma mark - network-request

- (void)getRecentData{
    
    NSDictionary *params = @{
                             @"app" : @"rss",
                             @"controller" : @"elleplus",
                             @"action" : @"elleplus_homelist",
                             @"pagenum" : @"1",
                             @"num" : @"10"
                             };
    @weakify(self)
    [[AFNetworkTool sharedTool] GET:@"http://app.ellemen.com/?" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [weak_self.collectionView.mj_header endRefreshing];
        if ([responseObject[@"status"] isEqualToString:@"true"]) {
            _pagenum = 2;
            NSArray *array = [YYMainArticalModel parseArray:responseObject[@"data"]];
            if (array && array.count > 0) {
                if (weak_self.dataArray.count > 0) [weak_self.dataArray removeAllObjects];
                weak_self.dataArray = [NSMutableArray arrayWithArray:array];
                [weak_self.collectionView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weak_self.collectionView.mj_header endRefreshing];
        DLog(@"更新第一个页面失败%@", error);
    }];
}

//加载更多
- (void)getMoreData{
    NSDictionary *params = @{
                             @"app" : @"rss",
                             @"controller" : @"elleplus",
                             @"action" : @"elleplus_homelist",
                             @"pagenum" : @(_pagenum),
                             @"num" : @"10"
                             };
    @weakify(self)
    [[AFNetworkTool sharedTool] GET:@"http://app.ellemen.com/?" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [weak_self.collectionView.mj_header endRefreshing];
        if ([responseObject[@"status"] isEqualToString:@"true"]) {
            NSArray *array = [YYMainArticalModel parseArray:responseObject[@"data"]];
            if (array && array.count > 0) {
                _pagenum++;
                [weak_self.dataArray addObjectsFromArray:array];
                [weak_self.collectionView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weak_self.collectionView.mj_header endRefreshing];
        DLog(@"更新第一个页面失败%@", error);
    }];
}

- (void)getCatList{
    NSDictionary *params = @{
                             @"app" : @"rss",
                             @"controller" : @"elleplus",
                             @"action" : @"elleplus_getcatlist"
                             };
    @weakify(self)
    [[AFNetworkTool sharedTool] GET:@"http://app.ellemen.com/?" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"true"]) {
            NSArray *array = [YYCategoryModel parseArray:responseObject[@"data"]];
            if (array && array.count > 0) {
                weak_self.leftView.dataArray = array;
                [weak_self.leftView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
