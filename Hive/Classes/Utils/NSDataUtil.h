//
//  NSDataUtil.h
//  Hive
//
//  Created by 那宝军 on 15/4/9.
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
@end
