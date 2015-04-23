//
//  NearByModel.m
//  Hive
//
//  Created by 那宝军 on 15/4/7.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "NearByModel.h"

@implementation NearByModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"lastUpdateTime.date"  : @"date",
                                                       @"lastUpdateTime.month" : @"month",
                                                       @"lastUpdateTime.hours" : @"hours",
                                                       @"lastUpdateTime.minutes":@"minutes"}];
}
@end
