//
//  MainCollectionViewCell.m
//  test-2
//
//  Created by hundred wang on 17/4/13.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "MainCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface MainCollectionViewCell(){
    UIImageView     *_imageView;
    UILabel         *_themeLabel;
    UILabel         *_publishTimeLabel;
    UILabel         *_titleLabel;
    UILabel         *_detailLabel;
}

@end

@implementation MainCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
     _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
     _detailLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(-25);
        make.right.mas_equalTo(-40);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(_detailLabel.mas_top).mas_equalTo(-3);
    }];
    
     _titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(lineView.mas_top).mas_equalTo(-3);
    }];
    
     _themeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_themeLabel];
    [_themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(_titleLabel.mas_top).mas_equalTo(-2);
    }];
    
    UIImageView *clickImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:clickImageView];
    [clickImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_themeLabel.mas_right).mas_equalTo(12);
        make.centerY.mas_equalTo(_themeLabel.mas_centerY).mas_equalTo(0);
        make.width.height.mas_equalTo(12);
    }];
    
     _publishTimeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_publishTimeLabel];
    [_publishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(clickImageView.mas_right).mas_equalTo(8);
        make.centerY.mas_equalTo(_themeLabel.mas_centerY).mas_equalTo(0);
    }];
    
    UIButton *loveBtn = [[UIButton alloc] init];
    [self.contentView addSubview:loveBtn];
    [loveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(2);
        make.width.mas_equalTo(17);
        make.height.mas_equalTo(22);
    }];
    
    UILabel *percentLabel = [[UILabel alloc] init];
    [self.contentView addSubview:percentLabel];
    [percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loveBtn.mas_bottom).mas_equalTo(2);
        make.right.mas_equalTo(-12);
    }];
    
    _detailLabel.font = [UIFont systemFontOfSize:11];
    _detailLabel.textColor = [UIColor whiteColor];
    
    _titleLabel.font = [UIFont systemFontOfSize:13];
    _titleLabel.textColor = [UIColor whiteColor];
    
    lineView.backgroundColor = [UIColor whiteColor];
    
    _themeLabel.font = [UIFont systemFontOfSize:12];
    _themeLabel.textColor = [UIColor whiteColor];
    
    _publishTimeLabel.font = [UIFont systemFontOfSize:11];
    _publishTimeLabel.textColor = [UIColor whiteColor];
    
    clickImageView.image = [UIImage imageNamed:@"time_black"];
    
    [loveBtn setImage:[UIImage imageNamed:@"love_off"] forState:UIControlStateNormal];
    
    percentLabel.font = [UIFont systemFontOfSize:11];
    percentLabel.textColor = [UIColor whiteColor];
    percentLabel.text = @"100%";
    
    //NOTE:test code
//    _imageView.backgroundColor = [UIColor lightGrayColor];
    _detailLabel.text = @"着真的是个好天气啊";
    _titleLabel.text = @"中国的负伤都赶着香国外跑";
    _themeLabel.text = @"政治";
    _publishTimeLabel.text = @"2017.13.12";
}

- (void)setModel:(YYMainArticalModel *)model{
    _model = model;

    _detailLabel.text = model.detail_description;
    _titleLabel.text = model.title;
    _themeLabel.text = model.tags;
    _publishTimeLabel.text = model.published;
//    [_imageView setImageWithURL:[NSURL URLWithString:model.imageLayout.source] placeholder:nil];
//    [_imageView setImageWithURL:[NSURL URLWithString:model.imageLayout.source] options:YYWebImageOptionShowNetworkActivity];
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.imageLayout.source] placeholderImage:nil options:SDWebImageRetryFailed];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:nil options:SDWebImageRetryFailed];
    
}

@end
