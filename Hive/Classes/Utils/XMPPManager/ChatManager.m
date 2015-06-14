//
//  ChatManager.m
//  Hive
//
//  Created by mac on 15/5/16.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ChatManager.h"
#import "Utils.h"
#import "MessageModel.h"

@implementation ChatManager
+ (NSPredicate*)predicateForToUserID:(NSString *)toUserID
{
    NSString *userID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"toUserID = %@ and cur_userID = %@",toUserID,userID];

    return predicate;
}

+ (MessageModel *)chatMessage:(NSString *)toUserID
{
    MessageModel *chat = [MessageModel MR_findFirstWithPredicate:[ChatManager predicateForToUserID:toUserID]];
    return chat;
}

+ (void)updateChatMessage:(NSString *)msg_Content
                MessageID:(NSString *)msgID
              MessageTime:(NSString *)msg_time
                 ToUserID:(NSString *)toUserID isShow:(BOOL)show
{
    debugLog(@"需要修改->%@",toUserID);
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        //MessageModel *message = [MessageModel MR_findFirstByAttribute:@"toUserID" withValue:toUserID inContext:localContext];
        MessageModel *message  = [MessageModel MR_findFirstWithPredicate:[ChatManager predicateForToUserID:toUserID] inContext:localContext];
        
        message.msg_ID = msgID;
        message.msg_time = msg_time;
        message.msg_content = msg_Content;
        message.unReadCount = show?message.unReadCount:[NSString stringWithFormat:@"%d",[message.unReadCount intValue]+1];
        
    } completion:^(BOOL success, NSError *error) {
        debugLog(@"messagelist->消息记录修改成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadChatMessage" object:nil];
    }];
}

+ (void)insertChatMessageUserID:(NSString *)toUserID
                       UserName:(NSString *)toUserName
                      MessageID:(NSString *)msgID
                 MessageContent:(NSString *)msg_Content
                    MessageTime:(NSString *)msg_time Count:(NSString *)count
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        MessageModel *message = [MessageModel MR_createInContext:localContext];
        message.msg_ID = msgID;
        message.msg_time = msg_time;
        message.msg_content = msg_Content;
        message.toUserID = toUserID;
        message.toUserName = toUserName;
        message.unReadCount = count;
        message.cur_userID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
    } completion:^(BOOL success, NSError *error) {
        debugLog(@"messagelist->消息记录插入成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadChatMessage" object:nil];

    }];
}

+ (void)insertChatMessageWith:(NSString *)toUserID
                     UserName:(NSString *)toUserName
                    MessageID:(NSString *)msgID
               MessageContent:(NSString *)msg_Content
                  MessageTime:(NSString *)msg_time isShow:(BOOL)isShow
{
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        if ([ChatManager chatMessage:toUserID]) {
            debugLog(@"messagelist->消息记录已经存在");
            [ChatManager updateChatMessage:msg_Content MessageID:msgID MessageTime:msg_time ToUserID:toUserID isShow:isShow];
        }else{
            debugLog(@"messagelist->消息记录未存在");
            [ChatManager insertChatMessageUserID:toUserID
                                        UserName:toUserName
                                       MessageID:msgID
                                  MessageContent:msg_Content
                                     MessageTime:msg_time
                                           Count:isShow?@"0":@"1"];
        }
    });    
}

+ (NSString *)chatMessageUnreadCount
{
    NSInteger unReadCount = 0;
    NSString * cur_userID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;

    NSArray *readArr = [MessageModel MR_findByAttribute:@"cur_userID" withValue:cur_userID];
    for (MessageModel *model in readArr) {
        unReadCount = unReadCount + [model.unReadCount intValue];
    }
    
    return [NSString stringWithFormat:@"%ld",unReadCount];
}

+ (void)clearUnReadCountWith:(NSString *)userID
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        //MessageModel *messsage = [MessageModel MR_findFirstByAttribute:@"toUserID" withValue:userID inContext:localContext];
        MessageModel *messsage = [MessageModel MR_findFirstWithPredicate:[ChatManager predicateForToUserID:userID] inContext:localContext];
        messsage.unReadCount = @"0";
        
    } completion:^(BOOL success, NSError *error) {
        debugLog(@"未读条数清零成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadChatMessage" object:nil];

    }];
}

@end
