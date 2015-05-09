//
//  DataBaseModel.m
//  Hive
//
//  Created by 那宝军 on 15/4/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "DataBaseModel.h"
#import "Utils.h"

@implementation DataBaseModel

+ (NSArray *)NSManagedObject:(Class)manager findStart:(NSInteger)start andCount:(NSInteger)count
{
    return [manager MR_findAllSortedBy:@"id" ascending:YES withPredicate:[self predicateForStart:start andCount:count]];
}

+ (NSPredicate *)predicateForStart:(NSInteger )start andCount:(NSInteger)count
{
    return [NSPredicate predicateWithFormat:@"id > %d and id < %d", start, start + count];
}

@end
