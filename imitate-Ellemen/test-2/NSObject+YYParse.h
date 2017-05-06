//
//  NSObject+YYParse.h
//  test-2
//
//  Created by hundred wang on 17/4/13.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YYParse)


/**
 *  解析数组，拿到存储mode的数组对象
 *
 *  @param array 需要解析的数组
 *  @return 解析后的数组
 */
+ (NSArray*)parseArray:(NSArray*)array;

/**
 *  解析字典，拿到解析后的model对象，直接调用的yy_modelWithJson;
 *
 *  @param dic 需要解析的字典
 *  @return 解析后的model对象
 */
+ (instancetype)parseDic:(NSDictionary*)dic;

@end
