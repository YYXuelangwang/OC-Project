//
//  ActivityCollectionViewCell.m
//  test-2
//
//  Created by hundred wang on 17/5/3.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "ActivityCollectionViewCell.h"
#import "YYActivityModel.h"
#import "UIImageView+WebCache.h"
#import <CoreGraphics/CGColor.h>


@interface ActivityCollectionViewCell(){
    UIImageView *_largeImageView;
    UILabel     *_titleLabel;
    UILabel     *_dateLabel;
    UILabel     *_themeLabel;
    UIImageView *_smallImageView;
    UIImageView *_newImageView;
}

@end

@implementation ActivityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setUpSubViews{
    
    CGFloat height = Screen_Width * (300 / 640.0);
    
     _largeImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_largeImageView];
    [_largeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    
     _dateLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_largeImageView.mas_bottom).mas_equalTo(12);
        make.left.mas_equalTo(10);
    }];
    
     _titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(_largeImageView.mas_bottom).mas_equalTo(-12);
        make.right.mas_equalTo(50);
    }];
    
     _smallImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_smallImageView];
    [_smallImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_largeImageView.mas_bottom).mas_equalTo(0);
        make.width.height.mas_equalTo(50);
    }];
    
     _themeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_themeLabel];
    [_themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(_dateLabel.mas_centerY).mas_equalTo(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(15);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_dateLabel.mas_left).mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.right.mas_equalTo(_dateLabel.mas_right).mas_equalTo(15);
    }];
    
     _newImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_newImageView];
    [_newImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineView.mas_right).mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(12);
    }];
    
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor whiteColor];
    
    _dateLabel.font = [UIFont systemFontOfSize:14];
    
    lineView.backgroundColor = [UIColor redColor];
    
    _themeLabel.layer.borderWidth = 1;
    _themeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _themeLabel.font = [UIFont systemFontOfSize:9];
    _themeLabel.textAlignment = NSTextAlignmentCenter;
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.bounds = CGRectMake(0, 0, Screen_Width, Screen_Width * (300 / 640.0));
    layer.position = CGPointMake((Screen_Width)* 0.5, Screen_Width * (300 / 640.0) * 0.5);
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.colors = @[(id)(UIColorHex(0xFFFFFF80).CGColor), (id)(UIColorHex(0x42424280).CGColor)];
    layer.startPoint = CGPointMake(0.5, 0.5);
    layer.endPoint = CGPointMake(0.5, 1.0);
    [_largeImageView.layer addSublayer:layer];
    
}

- (void)setModel:(YYActivityModel *)model{
    _model = model;
    
    _titleLabel.text = model.activity_title;
    _dateLabel.text = model.start_time;
    _themeLabel.text = model.activity_tag;
    
    [_largeImageView sd_setImageWithURL:[NSURL URLWithString:model.activity_thumbnail] placeholderImage:nil];
    
}

@end
