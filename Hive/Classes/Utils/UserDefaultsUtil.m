//
//  UserDefaultsUtil.m
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "UserDefaultsUtil.h"

@implementation UserDefaultsUtil

+ (void)setUserDefaultsFirstUse
{
    [[NSUserDefaults standardUserDefaults] setObject:@"firstuse" forKey:@"firstuse"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)iSFirstUse
{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    return [[def objectForKey:@"firstuse"] length] == 0;
}

+ (void)setDeviceToken:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSString *)getDeviceToken
{

    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"deviceToken"];
}

@end
