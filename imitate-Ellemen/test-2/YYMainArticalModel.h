//
//  YYMainArticalModel.h
//  test-2
//
//  Created by hundred wang on 17/4/13.
//  Copyright © 2017年 hundred wang. All rights reserved.
//
/*
 model:
{
    "catid": "44",
    "title": "\u6258\u6bdb\u4e3b\u5e2d\u7684\u798f",
    "modelid": 1,
    "thumb": "http:\/\/cp.hearst.com.cn\/tool\/crop?width=828&height=828&container=yes&source=http:\/\/upload.ellemen.com\/2017\/0405\/1491384422937.jpg",
    "contentid": "15895",
    "url": "http:\/\/www.ellemen.com\/story\/20170405-15895.shtml",
    "subtitle": "",
    "tags": "",
    "description": "\u4f60\u4fe1\u6bdb\u4e3b\u5e2d\u662f\u795e\u4e48\uff1f",
    "published": "2017.04.05",
    "cat_logo": null,
    "cat_title": "\u4e13\u9898\u62a5\u9053",
    "english_title": "story",
    "home_contentid": "15896"
}
*/

#import <Foundation/Foundation.h>

@class YYMainArticalModelImageLayout;

@interface YYMainArticalModel : NSObject

@property (nonatomic, copy) NSString * catid;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString* modelid;

@property (nonatomic, copy) NSString * thumb;

@property (nonatomic, copy) NSString * contentid;

@property (nonatomic, copy) NSString * url;

@property (nonatomic, copy) NSString * subtitle;

@property (nonatomic, copy) NSString * tags;

@property (nonatomic, copy) NSString * detail_description;

@property (nonatomic, copy) NSString * published;

@property (nonatomic, copy) NSString * cat_logo;

@property (nonatomic, copy) NSString * cat_title;

@property (nonatomic, copy) NSString * english_title;

@property (nonatomic, copy) NSString * home_contentid;

@property (nonatomic, strong) YYMainArticalModelImageLayout * imageLayout;

@end

@interface YYMainArticalModelImageLayout : NSObject

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, copy) NSString * container;

/**
 url
 */
@property (nonatomic, copy) NSString * source;

@end
