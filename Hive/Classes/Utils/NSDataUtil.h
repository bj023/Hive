//
//  NSDataUtil.h
//  Hive
//
//  Created by mac on 15/4/9.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDataUtil : NSObject

+ (void)setHidingWithValue:(NSString *)value;
+ (NSString *)getHidingValue;
+ (BOOL)valueHiding;

+ (void)setBeFollowWithValue:(NSString *)value;
+ (NSString *)getBeFollowValue;
+ (BOOL)beFollow;
// 存储聊天室时间段
+ (void)setChatRoomTime:(NSString *)time;
+ (NSString *)getChatRoomTime;
// 单聊
+ (void)setChatTime:(NSString *)time ToUserID:(NSString *)userID;
+ (NSString *)getChatTimeWithToUserID:(NSString *)userID;
// 记录聊天室数据库ID
+ (NSNumber *)setChatRoomDataID;
@end
