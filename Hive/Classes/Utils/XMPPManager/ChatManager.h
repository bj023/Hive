//
//  ChatManager.h
//  Hive
//
//  Created by mac on 15/5/16.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MessageModel;
@interface ChatManager : NSObject

+ (void)insertChatMessageWith:(NSString *)toUserID
                     UserName:(NSString *)toUserName
                    MessageID:(NSString *)msgID
               MessageContent:(NSString *)msg_Content
                  MessageTime:(NSString *)msg_time isShow:(BOOL)isShow;


+ (NSString *)chatMessageUnreadCount;

+ (void)clearUnReadCountWith:(NSString *)userID;
@end
