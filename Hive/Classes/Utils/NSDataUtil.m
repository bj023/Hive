//
//  NSDataUtil.m
//  Hive
//
//  Created by mac on 15/4/9.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "NSDataUtil.h"
#import "Utils.h"

@implementation NSDataUtil
#define kHiding @"Hiding"
+ (void)setHidingWithValue:(NSString *)value
{
    //[[NSUserDefaults standardUserDefaults] setObject:value forKey:kHiding];
    
    CurrentUserInfo *infor = [[UserInfoManager sharedInstance] getCurrentUserInfo];
    debugLog(@"----%@",value);
    infor.isStealth = value;
 
    [[UserInfoManager sharedInstance] saveUserInfoToDisk:infor];
}

+ (NSString *)getHidingValue
{
    //return [[NSUserDefaults standardUserDefaults] objectForKey:kHiding];
    NSString *value = [[UserInfoManager sharedInstance] getCurrentUserInfo].isStealth;
    return value;
}

// 1 隐身 0 不隐身
+ (BOOL)valueHiding
{
    //NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kHiding];
    NSString *value = [[UserInfoManager sharedInstance] getCurrentUserInfo].isStealth;
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
#define ChatRoomDataID @"ChatRoomDataID"
+ (NSNumber *)setChatRoomDataID
{
    NSNumber *number = [NSNumber numberWithLong:([NSDataUtil getChatRoomDataID]+1)];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:ChatRoomDataID];
    return [[NSUserDefaults standardUserDefaults] objectForKey:ChatRoomDataID];
}

+ (long)getChatRoomDataID
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:ChatRoomDataID] longValue];
}
@end
