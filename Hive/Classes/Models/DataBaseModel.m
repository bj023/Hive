//
//  DataBaseModel.m
//  Hive
//
//  Created by mac on 15/4/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "DataBaseModel.h"
#import "Utils.h"
#import "ChatRoomModel.h"

@implementation DataBaseModel

+ (NSPredicate *)predicateForStart:(NSInteger )start andCount:(NSInteger)count
{
    return [NSPredicate predicateWithFormat:@"id < %d and id > %d", start, start - count];
}

// 获取聊天大厅的数据
+ (NSArray *)getChatRoomWithStart:(NSInteger)start andCount:(NSInteger)count
{
    NSInteger startCount = [[ChatRoomModel MR_numberOfEntities] longValue] - start;
    return [ChatRoomModel MR_findAllWithPredicate:[DataBaseModel predicateForStart:startCount andCount:count]];
}



+ (NSArray *)NSManagedObject:(Class)manager Start:(ChatRoomModel *)chatRoom
{
    return [manager MR_findAllSortedBy:@"msg_Interval_time" ascending:YES withPredicate:[self predicateForStart:chatRoom]];
}

+ (NSPredicate *)predicateForStart:(ChatRoomModel *)chatRoom
{
    return [NSPredicate predicateWithFormat:@"msg_Interval_time < %@", chatRoom.msg_Interval_time];
}

+ (NSArray *)getChatWithStart:(NSArray *)startArr andCount:(NSInteger)count
{
    NSMutableArray *array = [NSMutableArray array];
    if (startArr.count < count) {
        return startArr;
    }
    for (NSInteger  i = 0 ;i < count; i ++ ) {
        ChatRoomModel *model = startArr[i];
        debugLog(@"-%@",model.msg_Interval_time);
        [array addObject:model];
    }
    return array;
}

+ (NSArray *)getChatWithStartChatRoom:(ChatRoomModel *)model andCount:(NSInteger)count
{
    if (!model) {
        NSArray *chatArray = [ChatRoomModel MR_findAllSortedBy:@"msg_Interval_time" ascending:YES];
        return [DataBaseModel getChatWithStart:chatArray andCount:count];
    }
    
    NSArray *chatArray = [DataBaseModel NSManagedObject:[ChatRoomModel class] Start:model];
    return [DataBaseModel getChatWithStart:chatArray andCount:count];
}

@end
