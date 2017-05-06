//
//  YYSettingView.h
//  test-2
//
//  Created by hundred wang on 17/4/13.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYSettingView;

@protocol YYSettingViewDelegate <NSObject>

- (void)settingView:(YYSettingView*)view DidResponseClickEventWithButtonIndex:(NSInteger)index;

@end

@interface YYSettingView : UIView

@property (nonatomic, weak) id<YYSettingViewDelegate> delegate;

//重新设置初始值
- (void)reset;

//显示子视图，展示动画
- (void)showAnimation;

@end
