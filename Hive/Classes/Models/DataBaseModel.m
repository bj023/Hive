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
    NSArray *array = [ChatRoomModel MR_findAllSortedBy:@"msg_Interval_time" ascending:NO];
    self.dataSource = [NSMutableArray arrayWithArray:array];
}

#pragma -mark 单一查询
- (NSArray *)getChatsCount:(NSInteger)count
{
    NSMutableArray *array = [NSMutableArray array];
    
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




+ (NSPredicate *)predicateForStart:(NSInteger )start andCount:(NSInteger)count
{
    return [NSPredicate predicateWithFormat:@"id < %d and id > %d", start, start - count];
}

@end
