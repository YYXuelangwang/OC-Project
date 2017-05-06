//
//  YYSettingView.m
//  test-2
//
//  Created by hundred wang on 17/4/13.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "YYSettingView.h"

@implementation YYSettingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
        self.backgroundColor = [UIColorHex(0x161617) colorWithAlphaComponent:0.8];
        [self setupSubViews];
        [self reset];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColorHex(0x161617) colorWithAlphaComponent:0.8];
//        [self setupSubViews];
//        [self reset];
    }
    return self;
}

- (void)didMoveToSuperview{
    if (self.subviews.count > 0) [self removeAllSubviews];
    [self setupSubViews];
    [self reset];
}

- (void)setupSubViews{
    CGFloat topMargin = 70;
    CGFloat totalHeight = Screen_Height - topMargin * 2;
    CGFloat width = totalHeight / (4 + 0.37 * 3);
    CGFloat space = width * 0.37;
    
    NSArray *imageNames = @[@"order", @"good", @"love", @"set"];
    
    for (int i = 0; i < 4; i++) {
        UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake((Screen_Width - width) * 0.5, topMargin + (width + space) * i, width, width)];
        [view setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//        view.backgroundColor = [UIColor whiteColor];
        view.tag = 100 + i;
        [self addSubview:view];
    }
}

- (void)click:(UIButton*)btn{
    if (_delegate && [_delegate respondsToSelector:@selector(settingView:DidResponseClickEventWithButtonIndex:)]) {
        [_delegate settingView:self DidResponseClickEventWithButtonIndex:btn.tag - 100];
    }
}

- (void)reset{
    for (UIView *subView in self.subviews) {
        subView.transform = CGAffineTransformMakeScale(0, 0);
        subView.hidden = YES;
    }
}

- (void)showAnimation{
    float duration = 0;
    for (UIView  *subView in self.subviews) {
        [UIView animateWithDuration:0.5 delay:duration usingSpringWithDamping:0.4 initialSpringVelocity:8 options:UIViewAnimationOptionLayoutSubviews animations:^{
            subView.hidden = NO;
            subView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
        duration += 0.1;
    }
}

@end
