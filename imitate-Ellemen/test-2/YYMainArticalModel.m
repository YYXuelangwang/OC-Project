//
//  YYMainArticalModel.m
//  test-2
//
//  Created by hundred wang on 17/4/13.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "YYMainArticalModel.h"

@implementation YYMainArticalModel

+(NSDictionary *)modelCustomPropertyMapper
{
    return @{@"detail_description":@"description"};
}

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist{
    return @[@"imageLayout"];
}

+ (instancetype)parseDic:(NSDictionary *)dic{
    YYMainArticalModel *model = [self modelWithJSON:dic];
    NSRange range = [model.thumb rangeOfString:@"?"];
    if (range.length < 1) return model;
    
    NSString *orignStr = [model.thumb substringFromIndex:range.location + 1];
    NSArray *strArr = [orignStr componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    for (NSString *str in strArr) {
        NSRange litRange = [str rangeOfString:@"="];
        NSString *key = [str substringToIndex:litRange.location];
        NSString *value = [str substringFromIndex:litRange.location + 1];
        mutDic[key] = value;
    }
    
    //解析图片字典
    model.imageLayout = [YYMainArticalModelImageLayout modelWithJSON:mutDic];
    
    return model;
}



@end

@implementation YYMainArticalModelImageLayout

@end
