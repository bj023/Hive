//
//  UtilDate.h
//  Hive
//
//  Created by mac on 15/4/19.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *DateFormat_YMD_HM = @"yyyy-MM-dd HH:mm";
static NSString *DateFormat_HM = @"HH:mm";
static NSString *DateFormat_MM_dd = @"MM-dd";

static NSString *DateFormat_MM = @"MM";
static NSString *DateFormat_DD = @"dd";

static NSString *DateFormat_HH = @"HH";
static NSString *DateFormat_mm = @"mm";


@interface UtilDate : NSObject
+(NSString *)getCurrentTime;

+(NSString *)getCurrentSendTime;

+ (NSString *)dateFromString:(NSString *)dateString withFormat:(NSString*)format;

+ (NSString *)getWeekWithDate:(NSString *)dateString;

@end
