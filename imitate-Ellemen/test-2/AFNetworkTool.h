//
//  AFNetworkTool.h
//  test_1
//
//  Created by hundred wang on 17/4/12.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFNetworkTool : AFHTTPSessionManager

+ (instancetype)sharedTool;

+ (instancetype)stringResponserTool;

@end
