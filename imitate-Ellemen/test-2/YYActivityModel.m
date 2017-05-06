//
//  YYActivityModel.m
//  test-2
//
//  Created by hundred wang on 17/5/3.
//  Copyright © 2017年 hundred wang. All rights reserved.
//

#import "YYActivityModel.h"

@implementation YYActivityModel

+ (instancetype)parseDic:(NSDictionary *)dic{
    YYActivityModel *model = [YYActivityModel modelWithJSON:dic];
    
    NSDate *endtime = [NSDate dateWithTimeIntervalSince1970:[model.end_time integerValue]];
    if (endtime < [NSDate date]){
        model.overdue = @"YES";
    }else{
        model.overdue = @"NO";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd";
    model.start_time = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.start_time integerValue]]];
    
    return model;
}

@end
