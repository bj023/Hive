//
//  NSString+Common.m
//  Hive
//
//  Created by 那宝军 on 15/6/17.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)

+ (NSString *)removeTrimmingWithString:(NSString *)string
{
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

@end
