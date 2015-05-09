//
//  UtilDate.m
//  Hive
//
//  Created by 那宝军 on 15/4/19.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "UtilDate.h"



@implementation UtilDate
+(NSString *)getCurrentTime
{
    //获得系统时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:DateFormat_YMD_HM];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return  locationString;
}

+(NSString *)getCurrentSendTime
{
    //获得系统时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:DateFormat_HM];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return  locationString;
}

+ (NSString *)dateFromString:(NSString *)dateString withFormat:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DateFormat_YMD_HM];
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat: format];
    NSString *locationString=[dateFormatter stringFromDate:destDate];
    return locationString;
}


+ (NSString *)getMinutesWithTime:(NSString *)time ForMat:(NSString *)format
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DateFormat_YMD_HM];
    NSDate *date = [dateFormatter dateFromString:time];
    [dateFormatter setDateFormat:format];
    NSString *Str=[dateFormatter stringFromDate:date];
    return Str;
}

+ (NSString *)getWeekWithDate:(NSString *)dateString
{
    //获取日期
    NSArray * arrWeek=[NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DateFormat_YMD_HM];
    NSDate *date = [dateFormatter dateFromString:dateString];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger weekNumber =  [calendar component:NSCalendarUnitWeekday fromDate:date];

    return arrWeek[weekNumber-1];
}

@end
