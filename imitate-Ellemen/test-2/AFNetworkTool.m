//
//  AFNetworkTool.m
//  test_1
//
//  Created by hundred wang on 17/4/12.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "AFNetworkTool.h"

@implementation AFNetworkTool

static AFNetworkTool *_manager = nil;

+ (instancetype)sharedTool{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [AFNetworkTool manager];
        _manager.requestSerializer.timeoutInterval = 10.0;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    });
    return _manager;
}

//解决3840的问题
+ (instancetype)stringResponserTool{
    AFNetworkTool *tool = [AFNetworkTool manager];
    tool.requestSerializer = [AFHTTPRequestSerializer serializer];
    tool.responseSerializer = [AFHTTPResponseSerializer serializer];
    return tool;
}

@end
