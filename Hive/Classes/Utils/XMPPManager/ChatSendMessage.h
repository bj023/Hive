//
//  ChatSendMessage.h
//  Hive
//
//  Created by 那宝军 on 15/5/20.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>

// 私聊发送类型
typedef enum{

    SendChatMessageChatTextType = 1,
    SendChatMessageChatIMGType = 2,
    SendChatMessageChatPhotoType = 3,
    
} SendChatMessageType;

typedef enum{
    SendCHatMessageNomal = 0,
    SendChatMessageSuccessState = 1,
    SendChatMessageReadState = 2,
    SendChatMessageFailState = 3,
    SendChatMessageNoReadState = 4,

} SendChatMessageStateType;



typedef void(^SendChatMessageSuccess)(SendChatMessageStateType sendState ,NSString *msg_ID);

@interface ChatSendMessage : NSObject

/**
 *  大厅发送文本消息
 *
 *  @param str           文本消息
 *  @param msg_time      消息时间
 *  @param msgID         消息ID
 *  @param msg_at_userID @ 用户ID
 *  @param result        回调
 */
+ (void)sendTextMessageWithString:(NSString *)str
                  SendMessageTime:(NSString *)msg_time
                    SendMessageID:(NSString *)msgID
                         AtUserID:(NSString *)msg_at_userID
                        IsChatIMG:(BOOL)isIMG
                         CallBack:(SendChatMessageSuccess)result;

/**
 *  单聊
 *
 *  @param str           文本消息
 *  @param msg_time      消息时间
 *  @param msgID         消息ID
 *  @param msg_to_userID 接收方
 *  @param isIMG         是否发送图片
 *  @param result        回调
 */
+ (void)sendTextMessageWithString:(NSString *)str
                  SendMessageTime:(NSString *)msg_time
                    SendMessageID:(NSString *)msgID
                         ToUserID:(NSString *)msg_to_userID
                      ChatIMGType:(SendChatMessageType)imgType
                         CallBack:(SendChatMessageSuccess)result;

/**
 *  已读回复
 *
 *  @param msg_id        消息ID
 *  @param msg_to_uesrID 接收文
 *  @param result        回调
 */
+ (void)ReplyToChatMessageWithMessageID:(NSString *)msg_id
                               ToUserID:(NSString *)msg_to_uesrID
                               CallBack:(SendChatMessageSuccess)result;

@end
