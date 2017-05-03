//
//  ActivityViewController.m
//  test-2
//
//  Created by hundred wang on 17/5/3.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "ActivityViewController.h"
#import "YYActivityModel.h"
#import "AFNetworkTool.h"

#import "ActivityCollectionViewCell.h"

static  NSString* const reuseIdentifier = @"cell";

@interface ActivityViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    
}

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSArray * dataArray;

@end

@implementation ActivityViewController

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(Screen_Width, Screen_Width * (300 / 640.0) + 32);
        layout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        [self.view addSubview:_collectionView];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[ActivityCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self getRecentData];
    // Do any additional setup after loading the view.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    return cell;
}


- (void)getRecentData{
    
    NSDictionary *params = @{
                             @"limit" : @"5",
                             @"page" : @"1",
                             @"category_id" : @"all",
                             @"callback" : @"jQuery214043627268355339766_1493774009518",
                             @"_" : @"1493774009519"
                             };
    @weakify(self)
    [[AFNetworkTool stringResponserTool] GET:@"http://activity.ellemen.com/apiv2/user/activitylist?" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *tempData = (NSData*)responseObject;
            NSRange tempRange = [tempData rangeOfData:[@"(" dataUsingEncoding:NSUTF8StringEncoding] options:NSDataSearchBackwards range:NSMakeRange(0, tempData.length)];
            
            if (tempRange.length > 0) {
                NSData *subData = [tempData subdataWithRange:NSMakeRange(tempRange.location + 1, tempData.length - (tempRange.location + 1 + 1))];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:subData options:NSJSONReadingMutableContainers error:nil];
                weak_self.dataArray = [YYActivityModel parseArray:dic[@"activelist"]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weak_self.collectionView reloadData];
                });
                
            }
        });
        
        NSLog(@"response:%@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"更新第一个页面失败%@", error);
    }];
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
