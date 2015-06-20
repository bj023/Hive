//
//  ChatSendMessage.m
//  Hive
//
//  Created by 那宝军 on 15/5/20.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ChatSendMessage.h"
#import "NSTimeUtil.h"
#import "Utils.h"
#import "XMPPManager.h"

#define LITTLEBIRD @"ay130718210956811b81z"

@implementation ChatSendMessage

#pragma -mark 大厅发送消息
+ (void)sendTextMessageWithString:(NSString *)str
                  SendMessageTime:(NSString *)msg_time
                    SendMessageID:(NSString *)msgID
                         AtUserID:(NSString *)msg_at_userID
                        IsChatIMG:(BOOL)isIMG
                         CallBack:(SendChatMessageSuccess)result
{
    NSXMLElement *body;
    NSXMLElement *mes;
    
    BOOL isSend = NO;
    
    for (NSString *toUserID in [[NSTimeUtil sharedInstance] getChatUserIDs]) {
        
        //生成<body>文档
        body = [NSXMLElement elementWithName:@"body"];
        //生成XML消息文档
        mes = [NSXMLElement elementWithName:@"message"];
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"chat"];
        [mes addAttributeWithName:@"flag" stringValue:@"public"];
        [mes addAttributeWithName:@"time" stringValue:msg_time];
        [mes addAttributeWithName:@"messageID" stringValue:msgID];
        [mes addAttributeWithName:@"messageType" stringValue:isIMG?@"2":@"1"];

        NSString *longitude = [[NSTimeUtil sharedInstance] getCoordinateLongitude];
        NSString *latitude = [[NSTimeUtil sharedInstance] getCoordinateLatitude];
        
        [mes addAttributeWithName:@"longitude" stringValue:longitude];
        [mes addAttributeWithName:@"latitude" stringValue:latitude];
        [mes addAttributeWithName:@"at" stringValue:IsEmpty(msg_at_userID)?@"":msg_at_userID];

        //用户名
        [mes addAttributeWithName:@"name" stringValue:[[UserInfoManager sharedInstance] getCurrentUserInfo].userName];
        //隐身
        [mes addAttributeWithName:@"isStealth" stringValue:[[UserInfoManager sharedInstance] getCurrentUserInfo].isStealth];
        [body setStringValue:[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@%@",[[UserInfoManager sharedInstance] getCurrentUserInfo].userID,LITTLEBIRD]];
        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@/%@",toUserID,LITTLEBIRD,toUserID]];
        //组合
        [mes addChild:body];
        //发送消息
        XMPPElementReceipt *receipt = [[XMPPElementReceipt alloc] init];
        [[[XMPPManager sharedInstance] getXMPPStream] sendElement:mes andGetReceipt:&receipt];
        BOOL messageState =[receipt wait:-1];
        if (messageState && !isSend) {
            isSend = YES;
            NSLog(@"chatRoom->消息已发送");
        }
        //debugLog(@"%@",mes);
    }
    
    if (isSend) {
        result(SendChatMessageSuccessState,msgID);
    }else
        result(SendChatMessageFailState,msgID);
}

#pragma -mark 单聊
+ (void)sendTextMessageWithString:(NSString *)str
                  SendMessageTime:(NSString *)msg_time
                    SendMessageID:(NSString *)msgID
                         ToUserID:(NSString *)msg_to_userID
                        IsChatIMG:(BOOL)isIMG
                         CallBack:(SendChatMessageSuccess)result
{
    NSXMLElement *body;
    NSXMLElement *mes;
    //生成<body>文档
    body = [NSXMLElement elementWithName:@"body"];
    //生成XML消息文档
    mes = [NSXMLElement elementWithName:@"message"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    [mes addAttributeWithName:@"flag" stringValue:@"pravite"];
    [mes addAttributeWithName:@"time" stringValue:msg_time];
    [mes addAttributeWithName:@"messageID" stringValue:msgID];
    NSString *longitude = [[NSTimeUtil sharedInstance] getCoordinateLongitude];
    NSString *latitude = [[NSTimeUtil sharedInstance] getCoordinateLatitude];
    [mes addAttributeWithName:@"longitude" stringValue:longitude];
    [mes addAttributeWithName:@"latitude" stringValue:latitude];
    [mes addAttributeWithName:@"messageType" stringValue:isIMG?@"2":@"1"];
    [mes addAttributeWithName:@"iconPath" stringValue:[[UserInfoManager sharedInstance] getCurrentUserInfo].userHead];

    //用户名
    [mes addAttributeWithName:@"name" stringValue:[[UserInfoManager sharedInstance] getCurrentUserInfo].userName];
    //隐身
    [mes addAttributeWithName:@"isStealth" stringValue:[[UserInfoManager sharedInstance] getCurrentUserInfo].isStealth];
    [body setStringValue:[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@%@",[[UserInfoManager sharedInstance] getCurrentUserInfo].userID,LITTLEBIRD]];
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@/%@",msg_to_userID,LITTLEBIRD,msg_to_userID]];
    //组合
    [mes addChild:body];
    //发送消息
    XMPPElementReceipt *receipt = [[XMPPElementReceipt alloc] init];
    [[[XMPPManager sharedInstance] getXMPPStream] sendElement:mes andGetReceipt:&receipt];
    BOOL messageState =[receipt wait:-1];
    
    result(messageState?SendChatMessageSuccessState:SendChatMessageFailState,msgID);
}

+ (void)ReplyToChatMessageWithMessageID:(NSString *)msg_id
                               ToUserID:(NSString *)msg_to_uesrID
                               CallBack:(SendChatMessageSuccess)result
{
    NSXMLElement *body;
    NSXMLElement *mes;
    
    //生成<body>文档
    body = [NSXMLElement elementWithName:@"body"];
    //生成XML消息文档
    mes = [NSXMLElement elementWithName:@"message"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    [mes addAttributeWithName:@"flag" stringValue:@"receipts"];
    //[mes addAttributeWithName:@"time" stringValue:time];
    [mes addAttributeWithName:@"messageID" stringValue:msg_id];
    [mes addAttributeWithName:@"receipts" stringValue:@"YES"];
    //用户名
    [mes addAttributeWithName:@"name" stringValue:[[UserInfoManager sharedInstance] getCurrentUserInfo].userName];
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@%@",[[UserInfoManager sharedInstance] getCurrentUserInfo].userID,LITTLEBIRD]];
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@/%@",msg_to_uesrID,LITTLEBIRD,msg_to_uesrID]];
    //组合
    [mes addChild:body];
    
    //发送消息
    XMPPElementReceipt *receipt = [[XMPPElementReceipt alloc] init];
    [[[XMPPManager sharedInstance] getXMPPStream] sendElement:mes andGetReceipt:&receipt];
    BOOL messageState =[receipt wait:-1];
    
    result(messageState?SendChatMessageSuccessState:SendChatMessageFailState,msg_id);
}

/** 发送二进制文件 */
- (void)sendMessageWithData:(NSData *)data bodyName:(NSString *)name
{
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:@"123"];
    [message addBody:name];
    // 转换成base64的编码
    NSString *base64str = [data base64EncodedStringWithOptions:0];
    // 设置节点内容
    XMPPElement *attachment = [XMPPElement elementWithName:@"attachment" stringValue:base64str];
    // 包含子节点
    [message addChild:attachment];
    // 发送消息
    [[[XMPPManager sharedInstance] getXMPPStream] sendElement:message];
}

@end
