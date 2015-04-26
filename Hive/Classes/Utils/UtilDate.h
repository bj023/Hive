//
//  UtilDate.h
//  Hive
//
//  Created by 那宝军 on 15/4/19.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *DateFormatHM = @"HH:mm";


@interface UtilDate : NSObject
+(NSString *)getCurrentTime;

+(NSString *)getCurrentSendTime;

+ (NSString *)dateFromString:(NSString *)dateString withFormat:(NSString*)format;

@end
