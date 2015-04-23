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
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return  locationString;
}

+(NSString *)getCurrentSendTime
{
    //获得系统时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return  locationString;
}
@end
