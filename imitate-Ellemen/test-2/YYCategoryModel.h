//
//  YYCategoryModel.h
//  test-2
//
//  Created by yinyong on 17/5/2.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCategoryModel : NSObject
/*
 "catid": "26",
 "cat_title": "\u4eba\u554a\u4eba",
 "english_title": "person",
 "cat_logo": null,
 "title": "\u3010\u4eba\u554a\u4eba\u3011\u540d\u4eba\u80cc\u540e\u7684\u6545\u4e8b-ELLEMEN|\u777f\u58eb\u5b98\u65b9\u7f51\u7ad9",
 "number": "50"
 */

@property (nonatomic, copy) NSString *catid;

@property (nonatomic, copy) NSString *cat_title;

@property (nonatomic, copy) NSString *english_title;

@property (nonatomic, copy) NSString *cat_logo;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *number;

@end
