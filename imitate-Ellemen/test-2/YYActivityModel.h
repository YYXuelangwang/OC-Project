//
//  YYActivityModel.h
//  test-2
//
//  Created by hundred wang on 17/5/3.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "activity_id": "176",
 "activity_title": "\u9b54\u90fd\u54c1\u9152\u4f1a\uff0c\u5e26\u4f60\u89c1\u8bc6\u5168\u65b0\u201c\u9955\u992e\u54c1\u9274\u201d\uff01",
 "activity_thumbnail": "http:\/\/cp.hearst.com.cn\/tool\/crop?width=640&height=300&container=yes&source=http:\/\/activity.ellemen.com\/public\/upload\/thumb\/ebbcde3e99b1ab7e95b53cc3d300b814.png",
 "activity_tag": "\u4f53\u9a8c",
 "activity_date": "1494144000",
 "start_time": "1494144000",
 "end_time": "1494147600",
 "address": "\u97f3\u6631\u542c\u5802\uff0c\u4e0a\u6d77\u5e02\u5efa\u56fd\u897f\u8def357\u53f7\uff08\u8fd1\u592a\u539f\u8def\uff09",
 "enroll_overday": "1494147600"
 */

@interface YYActivityModel : NSObject

@property (nonatomic, copy) NSString * activity_id;

@property (nonatomic, copy) NSString * activity_title;

@property (nonatomic, copy) NSString * activity_thumbnail;

@property (nonatomic, copy) NSString * activity_tag;

@property (nonatomic, copy) NSString * activity_date;

@property (nonatomic, copy) NSString * start_time;

@property (nonatomic, copy) NSString * end_time;

@property (nonatomic, copy) NSString * address;

@property (nonatomic, copy) NSString * enroll_overday;

@property (nonatomic, strong) NSString * overdue;

@end
