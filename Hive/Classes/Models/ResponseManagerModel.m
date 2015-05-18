//
//  ResponseManagerModel.m
//  Hive
//
//  Created by mac on 15/4/7.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ResponseManagerModel.h"

@implementation ResponseManagerModel

@end

@implementation ResponseLoginModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"RETURN_OBJ" : @"content"}];
}
@end

@implementation ResponseNearByModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"RETURN_OBJ" : @"content"}];
}
@end

@implementation ResponseFollowModel

@end

@implementation ResponseChatUsersModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"RETURN_OBJ" : @"userIDs"}];
}

@end

@implementation ResponseChatUserInforModel

@end