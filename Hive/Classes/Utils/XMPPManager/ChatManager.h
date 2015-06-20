//
//  ChatManager.h
//  Hive
//
//  Created by mac on 15/5/16.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MessageModel;
@class Message_Model;
@interface ChatManager : NSObject


+ (instancetype)sharedInstace;

- (void)addMessageModel:(Message_Model *)message;

+ (void)insertChatMessageToUserID:(NSString *)toUserID
                       ToUserName:(NSString *)toUserName
                   ToUserIconPath:(NSString *)toIconPath
                        MessageID:(NSString *)msgID
                   MessageContent:(NSString *)msg_Content
                      MessageTime:(NSString *)msg_time isShow:(BOOL)isShow;


+ (NSString *)chatMessageUnreadCount;

+ (void)clearUnReadCountWith:(NSString *)userID;
@end

@interface Message_Model : NSObject
@property (nonatomic, strong) NSString * cur_userID;
@property (nonatomic, strong) NSString * msg_content;
@property (nonatomic, strong) NSString * msg_ID;
@property (nonatomic, strong) NSString * msg_time;
@property (nonatomic, strong) NSString * toUser_IconPath;
@property (nonatomic, strong) NSString * toUserID;
@property (nonatomic, strong) NSString * toUserName;
@property (nonatomic, strong) NSNumber * is_flag;
@end