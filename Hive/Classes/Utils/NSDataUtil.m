//
//  NSDataUtil.m
//  Hive
//
//  Created by mac on 15/4/9.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "NSDataUtil.h"

@implementation NSDataUtil
#define kHiding @"Hiding"
+ (void)setHidingWithValue:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kHiding];
}

+ (NSString *)getHidingValue
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kHiding];
}

+ (BOOL)valueHiding
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kHiding];
    if ([value isEqualToString:@"1"]) {
        return YES;
    }else
        return NO;
}

#define kBeFollow @"BeFollow"
+ (void)setBeFollowWithValue:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kBeFollow];
}

+ (NSString *)getBeFollowValue
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kBeFollow];
}
+ (BOOL)beFollow
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kBeFollow];
    if ([value isEqualToString:@"1"]) {
        return YES;
    }else
        return NO;
}
#define ChatRoomTime @"ChatRoomTime"
+ (void)setChatRoomTime:(NSString *)time
{
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:ChatRoomTime];
}

+ (NSString *)getChatRoomTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:ChatRoomTime];
}

#define ChatTime @"ChatTime"
+ (void)setChatTime:(NSString *)time ToUserID:(NSString *)userID
{
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:[NSString stringWithFormat:@"%@_%@",ChatTime,userID]];
}
+ (NSString *)getChatTimeWithToUserID:(NSString *)userID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@",ChatTime,userID]];
}

@end
