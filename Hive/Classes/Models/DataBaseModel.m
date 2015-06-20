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
#import "ChatModel.h"

static DataBaseModel *sharedInstance;

@interface DataBaseModel ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation DataBaseModel

+ (DataBaseModel *)shareInstance
{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        sharedInstance = [[DataBaseModel alloc] init];
        [sharedInstance setUpDataSource];
    });
    return sharedInstance;
}

- (void)setUpDataSource
{
    //NSArray *array = [ChatRoomModel MR_findAllSortedBy:@"msg_Interval_time" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cur_userID = %@",[[UserInfoManager sharedInstance] getCurrentUserInfo].userID];
    NSArray *array = [ChatRoomModel MR_findAllSortedBy:@"msg_Interval_time" ascending:NO withPredicate:predicate];
    self.dataSource = [NSMutableArray arrayWithArray:array];
}

#pragma -mark 单一查询
- (NSArray *)getChatsCount:(NSInteger)count
{
    NSMutableArray *array = [NSMutableArray array];
    
    if (self.dataSource.count == 0) {
        return array;
    }
    
    for (ChatRoomModel *model in self.dataSource) {
        
        if (array.count == count) {
            break;
        }
        
        [array addObject:model];
    }
    
    [_dataSource removeObjectsInArray:array];
    
    array = (NSMutableArray *)[[array reverseObjectEnumerator] allObjects];
    
    return array;
}

#pragma mark 删除会话
- (void)deleteCurrentChatMessage:(NSString *)toUserID
{
    NSString *currentUser = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_ID = %@ and msg_userID = %@",currentUser,toUserID];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [ChatModel MR_deleteAllMatchingPredicate:predicate inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
        debugLog(@"删除当前会话-记录成功");
    }];
}


+ (NSPredicate *)predicateForStart:(NSInteger )start andCount:(NSInteger)count
{
    return [NSPredicate predicateWithFormat:@"id < %d and id > %d", start, start - count];
}

@end
