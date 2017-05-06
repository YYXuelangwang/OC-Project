//
//  YYCategoryView.h
//  test-2
//
//  Created by yinyong on 17/5/2.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYCategoryView;
@class YYCategoryModel;

@protocol YYCategoryViewDelegate <NSObject>

@optional
- (void)categoryView:(YYCategoryView*)categoryView didSelectRowAtIndexPath:(NSInteger)index;

@end

@interface YYCategoryView : UIView

@property (nonatomic, strong) NSArray<YYCategoryModel*> *dataArray;

@property (nonatomic, weak) id<YYCategoryViewDelegate> delegate;

- (void)reloadData;

@end
