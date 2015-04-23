//
//  NSDataUtil.m
//  Hive
//
//  Created by 那宝军 on 15/4/9.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "NSDataUtil.h"

@implementation NSDataUtil

+ (void)setHidingWithValue:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"Hiding"];
}

+ (NSString *)getHidingValue
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Hiding"];
}

+ (BOOL)valueHiding
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"Hiding"];
    if ([value isEqualToString:@"1"]) {
        return YES;
    }else
        return NO;
}


+ (void)setBeFollowWithValue:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"BeFollow"];
}

+ (NSString *)getBeFollowValue
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"BeFollow"];
}

+ (BOOL)beFollow
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"BeFollow"];
    if ([value isEqualToString:@"1"]) {
        return YES;
    }else
        return NO;
}
@end
