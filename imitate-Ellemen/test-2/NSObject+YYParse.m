//
//  NSObject+YYParse.m
//  test-2
//
//  Created by hundred wang on 17/4/13.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "NSObject+YYParse.h"
#import "YYKit.h"

@implementation NSObject (YYParse)

+ (instancetype)parseDic:(NSDictionary*)dic{
    return [self modelWithJSON:dic];
}

+ (NSArray *)parseArray:(NSArray *)array{
    
    if (!array || array.count < 1 || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < array.count; i ++) {
        [result addObject:[self parseDic:array[i]]];
    }
    return [result copy];
}


@end
