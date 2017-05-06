//
//  YYCategoryView.m
//  test-2
//
//  Created by yinyong on 17/5/2.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "YYCategoryView.h"
#import "YYCategoryModel.h"

@interface YYCategoryView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YYCategoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTableView];
        self.backgroundColor = [UIColorHex(0x161617) colorWithAlphaComponent:0.8];
    }
    return self;
}

- (void)setupTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.width, self.height - 20) style:UITableViewStylePlain];
    [self addSubview:_tableView];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 80;
    _tableView.backgroundColor = [UIColor clearColor];
}

- (void)reloadData{
    [_tableView reloadData];
}

#pragma mark - UITablViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    UILabel *label = [cell.contentView viewWithTag:101];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 80)];
        label.tag = 101;
        [cell.contentView addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor redColor];
    }
    
    YYCategoryModel *model = _dataArray[indexPath.row];
    label.text = model.cat_title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(categoryView:didSelectRowAtIndexPath:)]) {
        [_delegate categoryView:self didSelectRowAtIndexPath:indexPath.row];
    }
}


@end
