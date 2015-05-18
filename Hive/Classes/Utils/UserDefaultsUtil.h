//
//  UserDefaultsUtil.h
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  UserDefaults 存储
 */
@interface UserDefaultsUtil : NSObject

/**
 *  设置第一次启动APP
 */
+ (void)setUserDefaultsFirstUse;
/**
 *  判断是否是第一次启动
 *
 *  @return 返回 YES 表示 第一次启动
 */
+ (BOOL)iSFirstUse;

+ (void)setDeviceToken:(NSString *)token;
+ (NSString *)getDeviceToken;

@end
