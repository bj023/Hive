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

//宏定义全局并发队列
#define global_quque    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

static ChatManager *sharedInstance;

@interface ChatManager ()
{
    dispatch_queue_t _messageListQueue;
    BOOL _isSaving;
}
@property (nonatomic, strong) NSMutableArray *messageArr;
@end

@implementation ChatManager


+ (instancetype)sharedInstace
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ChatManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self configQueue];
        [self configArray];
        [self runingCustomQueue];
    }
    return self;
}

- (void)configQueue
{
    _messageListQueue = dispatch_queue_create("example.MyMessageCustomQueue", NULL);
}

- (void)configArray
{
    _messageArr = [NSMutableArray array];
}

- (void)addMessageModel:(Message_Model *)message
{
    [_messageArr addObject:message];
    debugLog(@"添加一个实体类-%ld",_messageArr.count);
}

- (void)runingCustomQueue
{
    dispatch_async(_messageListQueue, ^{
        while (1) {
            
            if (!_isSaving && _messageArr.count>0) {
                
                debugLog(@"需要插入数据");
                
                _isSaving = YES;
                
                MessageModel *cur_messageModel = [_messageArr firstObject];
                [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
                    
                    MessageModel *the_message = [MessageModel MR_findFirstWithPredicate:[self predicateForToUserID:cur_messageModel.toUserID] inContext:localContext];
                    
                    if (the_message) {
                        NSInteger cur_readCount = [the_message.unReadCount integerValue];
                        the_message.msg_ID = cur_messageModel.msg_ID;
                        the_message.msg_time = cur_messageModel.msg_time;
                        the_message.msg_content = cur_messageModel.msg_content;
                        the_message.unReadCount = [cur_messageModel.is_flag boolValue]?[NSString stringWithFormat:@"%ld",(cur_readCount+1)]:the_message.unReadCount;
                        debugLog(@"当前未读数---->%@",the_message.unReadCount);
                    }else{
                        
                        MessageModel *message = [MessageModel MR_createInContext:localContext];
                        message.msg_ID = cur_messageModel.msg_ID;
                        message.msg_time = cur_messageModel.msg_time;
                        message.msg_content = cur_messageModel.msg_content;
                        message.toUserID = cur_messageModel.toUserID;
                        message.toUserName = cur_messageModel.toUserName;
                        message.unReadCount = [cur_messageModel.is_flag boolValue]?@"1":@"0";
                        message.cur_userID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
                    }
                    
                } completion:^(BOOL success, NSError *error) {
                    
                    _isSaving = NO;
                    
                    [_messageArr removeObject:cur_messageModel];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadChatMessage" object:nil];
                    
                    debugLog(@"messagelist->消息记录------成功");
                    
                }];
                
            }
        }
    });
}


- (NSPredicate*)predicateForToUserID:(NSString *)toUserID
{
    NSString *userID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"toUserID = %@ and cur_userID = %@",toUserID,userID];
    
    return predicate;
}

#pragma -mark 旧的写法---------------------------------------------------------------------------------------------
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
        message.unReadCount = show?message.unReadCount:[NSString stringWithFormat:@"%ld",([message.unReadCount integerValue]+1)];

    } completion:^(BOOL success, NSError *error) {
        debugLog(@"messagelist->消息记录修改成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadChatMessage" object:nil];
    }];
}

+ (void)insertChatMessageToUserID:(NSString *)toUserID
                       ToUserName:(NSString *)toUserName
                   ToUserIconPath:(NSString *)toIconPath
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

+ (void)insertChatMessageToUserID:(NSString *)toUserID
                       ToUserName:(NSString *)toUserName
                   ToUserIconPath:(NSString *)toIconPath
                        MessageID:(NSString *)msgID
                   MessageContent:(NSString *)msg_Content
                      MessageTime:(NSString *)msg_time isShow:(BOOL)isShow
{
    //static dispatch_queue_t _chatMessageManagerQueue;
    //dispatch_queue_create("chatMessage.com", NULL);

    dispatch_async(global_quque, ^{
        if ([ChatManager chatMessage:toUserID]) {
            debugLog(@"messagelist->消息记录已经存在");
            [ChatManager updateChatMessage:msg_Content MessageID:msgID MessageTime:msg_time ToUserID:toUserID isShow:isShow];
        }else{
            debugLog(@"messagelist->消息记录未存在");
            [ChatManager insertChatMessageToUserID:toUserID
                                        ToUserName:toUserName
                                    ToUserIconPath:toIconPath
                                         MessageID:msgID
                                    MessageContent:msg_Content
                                       MessageTime:msg_time
                                             Count:isShow?@"0":@"1"];
            /*
            [ChatManager insertChatMessageUserID:toUserID
                                        UserName:toUserName
                                       MessageID:msgID
                                  MessageContent:msg_Content
                                     MessageTime:msg_time
                                           Count:isShow?@"0":@"1"];
             */
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


@implementation Message_Model
@end