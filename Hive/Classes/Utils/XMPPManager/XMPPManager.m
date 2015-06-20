//
//  XMPPManager.m
//  Hive
//
//  Created by mac on 15/4/5.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "XMPPManager.h"
#import "Utils.h"
#import "NSTimeUtil.h"
#import "NSDataUtil.h"
#import "ChatRoomModel.h"
#import "ChatModel.h"
#import "ChatManager.h"
#import "UIAlertView+Block.h"
#import "MessageModel.h"

#define kXMPPHost @"115.28.51.196"
#define LITTLEBIRD @"ay130718210956811b81z"

static XMPPManager *sharedManager;

@interface XMPPManager ()<UIAlertViewDelegate>
{
    dispatch_queue_t myCustomQueue;
    dispatch_queue_t myCustomChatQueue;
    dispatch_queue_t readCustomChatQueue;

}
@end

@implementation XMPPManager

+ (XMPPManager *)sharedInstance
{
    /**/
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[XMPPManager alloc] init];
        [sharedManager setupStream];
        [sharedManager setupCustomQueue];
    });
    return sharedManager;
}
//初始化XMPPStream
- (void)setupStream{
    NSLog(@"====初始化XMPPStream====");
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //允许后台模式(注意ios模拟器上是不支持后台socket的)
    //xmppStream.enableBackgroundingOnSocket = YES;

}

- (BOOL)connect
{
    NSString *user_ID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
    debugLog(@"要连接XMPP的用户ID->%@",user_ID);
    //从本地取得用户名，密码和服务器地址
    NSString *userId = [NSString stringWithFormat:@"%@@%@",user_ID,LITTLEBIRD];
    NSString *pass = [[UserInfoManager sharedInstance] getCurrentUserInfo].xmppPassWord;
    NSString *server = @"115.28.51.196";
    //@"42.96.168.50";
    //    NSString *server = @"211.101.12.58";
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    if (userId == nil || pass == nil) {
        return NO;
    }
    NSLog(@"connect server --id:%@-password:%@",userId,pass);
    //设置用户
    //XMPPJID *jid = [XMPPJID jidWithString:userId];
    XMPPJID *jid = [XMPPJID jidWithString:userId resource:userId];
    //XMPPJID *jid = [XMPPJID jidWithUser:userId domain:user_ID resource:@"Ework"];
    [xmppStream setMyJID:jid];
    debugLog(@"xmppjid->%@",jid);
    //设置服务器
    [xmppStream setHostName:server];
    //密码
    password = pass;

    //连接服务器
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:30 error:&error]) {
        NSLog(@"====连接服务器发生错误==");
        return NO;
    }
    return YES;
}

//连接服务器
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"====连接服务器==");
    isOpen = YES;
    NSError *error;
    if ([xmppStream authenticateWithPassword:password error:&error])
    {
        NSLog(@"Authentificated to XMPP.");
    }
    else
    {
        NSLog(@"Error authentificating to XMPP: %@", [error localizedDescription]);
    }
}

//验证通过l
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"==========验证通过==========");
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error//
{
    NSLog(@"验证失败 didNotAuthenticate:%@",error.description);
    
}

- (void)goOnline{
    NSLog(@"====发送在线状态====");
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    [xmppStream sendElement:presence];
}

- (void)disconnect{
    [self goOffline];
    [xmppStream disconnect];
}

- (void)goOffline{
    NSLog(@"====发送下线状态====");
    //发送下线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [xmppStream sendElement:presence];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    debugLog(@"message =========== %@ ===========", message);
    NSString *type =[[message attributeForName:@"type"] stringValue];
    NSString *myFlag = [[message attributeForName:@"flag"] stringValue];
    
    if ([myFlag isEqualToString:@"public"] && [type isEqualToString:@"chat"]) {
        [self performSelectorInBackground:@selector(receiveChatRoomMessage:) withObject:message];
    }else if ([myFlag isEqualToString:@"pravite"] && [type isEqualToString:@"chat"]){
        [self performSelectorInBackground:@selector(receiveChatMessage:) withObject:message];
    }else if ([myFlag isEqualToString:@"receipts"] && [type isEqualToString:@"chat"]){
        [self performSelectorInBackground:@selector(receiptsChatMessage:) withObject:message];
    }
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    return NO;
}

- (void)xmppStream:(XMPPStream *)sender willSendP2PFeatures:(NSXMLElement *)streamFeatures
{
    debugMethod();
    debugLog(@"%@",streamFeatures);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveP2PFeatures:(NSXMLElement *)streamFeatures
{
    debugMethod();
    debugLog(@"%@",streamFeatures);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    debugLog(@"%@",error.description);
}


- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error
{
    //您的账户已在其他手机上登录，您已被挤下线，请确定是否是您本人操作!是否重新登录？
    debugLog(@"didReceiveError:%@",error);
    DDXMLNode *errorNode = (DDXMLNode *)error;
    //遍历错误节点
    for(DDXMLNode *node in [errorNode children])
    {
        //若错误节点有【冲突】
        if([[node name] isEqualToString:@"conflict"])
        {
            //停止轮训检查链接状态
            //[_timer invalidate];
            NSString *message = @"您的账户已在其他手机上登录，您已被挤下线，请确定是否是您本人操作!是否重新登录？";
            //弹出登陆冲突,点击OK后logout
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                           message:message
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
            [alert handlerClickedButton:^(NSInteger btnIndex) {
                //重新登陆
                [[UserInfoManager sharedInstance] logOut];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"setRootViewController" object:nil];
            }];
            [alert show];
        }
    }  
}

- (void)signOut
{
    [self disconnect];
}
/*
didReceiveError:<stream:error xmlns:stream="http://etherx.jabber.org/streams"><conflict xmlns="urn:ietf:params:xml:ns:xmpp-streams"/></stream:error>
2015-06-14 17:30:54.795 Hive[6682:1083339] Error Domain=GCDAsyncSocketErrorDomain Code=7 "Socket closed by remote peer" UserInfo=0x170e7ee40 {NSLocalizedDescription=Socket closed by remote peer}
 */
- (XMPPStream *)getXMPPStream
{
    return xmppStream;
}

#pragma -mark 发送消息
- (void)sendNewMessage:(NSString *)message
                  Time:(NSString *)time
               Message:(NSString *)messageID
               isAname:(NSString *)aName
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
        
        [mes addAttributeWithName:@"time" stringValue:time];
        [mes addAttributeWithName:@"messageID" stringValue:messageID];
        
        NSString *longitude = [[NSTimeUtil sharedInstance] getCoordinateLongitude];
        NSString *latitude = [[NSTimeUtil sharedInstance] getCoordinateLatitude];
        
        [mes addAttributeWithName:@"longitude" stringValue:longitude];
        [mes addAttributeWithName:@"latitude" stringValue:latitude];
        
        [mes addAttributeWithName:@"at" stringValue:IsEmpty(aName)?@"":aName];
        //用户名
        [mes addAttributeWithName:@"name" stringValue:[[UserInfoManager sharedInstance] getCurrentUserInfo].userName];
        //隐身
        [mes addAttributeWithName:@"isStealth" stringValue:[[UserInfoManager sharedInstance] getCurrentUserInfo].isStealth];
        
        [body setStringValue:[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@%@",[[UserInfoManager sharedInstance] getCurrentUserInfo].userID,LITTLEBIRD]];
        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@/%@",toUserID,LITTLEBIRD,toUserID]];
        //组合
        [mes addChild:body];
        
        //发送消息
        XMPPElementReceipt *receipt = [[XMPPElementReceipt alloc] init];
        [xmppStream sendElement:mes andGetReceipt:&receipt];
        BOOL messageState =[receipt wait:-1];
        
        if (messageState && !isSend) {
            isSend = YES;
            NSLog(@"chatRoom->消息已发送");
            [self sendPublisChatMessageID:messageID Send:YES];
        }
        //debugLog(@"%@",mes);
    }
    
    if (!isSend) {
        [self sendPublisChatMessageID:messageID Send:NO];
    }
}

- (void)sendPublisChatMessageID:(NSString *)messageID Send:(BOOL)isSend
{
    if ([self.publicDelegate respondsToSelector:@selector(sendPublicMessageSuccessMessageID:Send:)]) {
        [self.publicDelegate sendPublicMessageSuccessMessageID:messageID Send:isSend];
    }
}

- (NSString *)getUserId:(NSString *)userID
{
    NSRange range;
    range = [userID rangeOfString:@"@"];
    return [userID stringByPaddingToLength:range.location withString:nil startingAtIndex:0];
}

+ (NSString *)getChatRoomTime:(NSString *)currentTime
{
    NSString *time = [NSDataUtil getChatRoomTime];
    if (IsEmpty(time)) {
        [NSDataUtil setChatRoomTime:currentTime];
        return currentTime;
    }
    

    NSString *d_current = [UtilDate dateFromString:currentTime withFormat:DateFormat_DD];
    NSString *d_time = [UtilDate dateFromString:time withFormat:DateFormat_DD];
    
    debugLog(@"%@-%@",d_current,d_time);
    
    if (([d_current intValue] - [d_time intValue] >= 1)) {
        [NSDataUtil setChatRoomTime:currentTime];
        return currentTime;
    }
    return @"";
}

+ (NSString *)getChatTime:(NSString *)currentTime ToUserID:(NSString *)userID
{
    NSString *time = [NSDataUtil getChatTimeWithToUserID:userID];
    if (IsEmpty(time)) {
        [NSDataUtil setChatTime:currentTime ToUserID:userID];
        return currentTime;
    }

    NSString *d_current = [UtilDate dateFromString:currentTime withFormat:DateFormat_DD];
    NSString *d_time = [UtilDate dateFromString:time withFormat:DateFormat_DD];
    
    debugLog(@"%@-%@",d_current,d_time);
    
    if (([d_current intValue] - [d_time intValue] >= 1)) {
        [NSDataUtil setChatTime:currentTime ToUserID:userID];
        return currentTime;
    }
    return @"";
}

// 私聊 回复
- (void)receiptsMessage:(NSString *)messageID ToUserID:(NSString *)userID
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
    [mes addAttributeWithName:@"messageID" stringValue:messageID];
    [mes addAttributeWithName:@"receipts" stringValue:@"YES"];
    
    //NSString *longitude = [[NSTimeUtil sharedInstance] getCoordinateLongitude];
    //NSString *latitude = [[NSTimeUtil sharedInstance] getCoordinateLatitude];
    //[mes addAttributeWithName:@"longitude" stringValue:longitude];
    //[mes addAttributeWithName:@"latitude" stringValue:latitude];
    
    //用户名
    [mes addAttributeWithName:@"name" stringValue:[[UserInfoManager sharedInstance] getCurrentUserInfo].userName];
    //隐身
    //[mes addAttributeWithName:@"isStealth" stringValue:[[UserInfoManager sharedInstance] getCurrentUserInfo].isStealth];
    //[body setStringValue:[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@%@",[[UserInfoManager sharedInstance] getCurrentUserInfo].userID,LITTLEBIRD]];
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@/%@",userID,LITTLEBIRD,userID]];
    //组合
    [mes addChild:body];
    
    //发送消息
    XMPPElementReceipt *receipt = [[XMPPElementReceipt alloc] init];
    [xmppStream sendElement:mes andGetReceipt:&receipt];
    BOOL messageState =[receipt wait:-1];
    
    if (messageState)
        NSLog(@"回复->消息已发送");
    else
        NSLog(@"回复->消息发送失败");
}

#pragma -mark 保存收到的消息
// 聊天室
- (void)receiveChatRoomMessage:(XMPPMessage *)message
{
    dispatch_async(myCustomQueue, ^{
        NSString *from = [[message attributeForName:@"from"] stringValue];
        NSString *toUserID = [[message attributeForName:@"to"] stringValue];
        NSString *time = [[message attributeForName:@"time"] stringValue];
        NSString *at = [[message attributeForName:@"at"] stringValue];
        NSString *msgId = [[message attributeForName:@"messageID"] stringValue];
        NSString *name = [[message attributeForName:@"name"] stringValue];
        NSString *hasStealth = [[message attributeForName:@"isStealth"] stringValue];
        NSString *longitude = [[message attributeForName:@"longitude"] stringValue];
        NSString *latitude = [[message attributeForName:@"latitude"] stringValue];
        NSString *isTime = [XMPPManager getChatRoomTime:time];
        //NSString *isTime = [XMPPManager getChatTime:time ToUserID:[self getUserId:from]];
        
        NSString *msg_content = [[message elementForName:@"body"]  stringValue];
        NSString *type =[[message attributeForName:@"messageType"] stringValue];
        
        
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            
            ChatRoomModel *model = [ChatRoomModel MR_createInContext:localContext];
            model.cur_userID = [self getUserId:toUserID];
            model.toUserID = [self getUserId:from];
            model.toUserName = name;
            model.msg_message = msg_content;
            model.msg_time = time;
            model.msg_flag = @"YOU";
            model.hasAname = at;
            model.msg_longitude = longitude;
            model.msg_latitude = latitude;
            model.messageID = msgId;
            model.msg_hasStealth = hasStealth;
            model.msg_hasTime = isTime;
            model.msg_Interval_time = [UtilDate getCurrentTimeInterval];
            model.msg_type = @([type intValue]);
            model.id = [NSDataUtil setChatRoomDataID];

            //NSInteger count = [ChatRoomModel MR_countOfEntitiesWithContext:localContext];
            //model.id = @(count+1);

            debugLog(@"收到聊天大厅创建记录->%@",model.id);
            
        } completion:^(BOOL success, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.publicDelegate respondsToSelector:@selector(didReceivChatRoomeMessageId:)]) {
                    [self.publicDelegate didReceivChatRoomeMessageId:msgId];
                }
            });
        }];
    });
}

// 私聊
- (void)receiveChatMessage:(XMPPMessage *)message
{
    dispatch_async(myCustomChatQueue, ^{
        
        
        NSString *from = [[message attributeForName:@"from"] stringValue];
        NSString *time = [[message attributeForName:@"time"] stringValue];
        NSString *msgId = [[message attributeForName:@"messageID"] stringValue];
        NSString *name = [[message attributeForName:@"name"] stringValue];
        NSString *longitude = [[message attributeForName:@"longitude"] stringValue];
        NSString *latitude = [[message attributeForName:@"latitude"] stringValue];
        NSString *hasStealth = [[message attributeForName:@"isStealth"] stringValue];
        NSString *isTime = [XMPPManager getChatTime:time ToUserID:[self getUserId:from]];
        NSString *msg_content = [[message elementForName:@"body"]  stringValue];
        NSString *type =[[message attributeForName:@"messageType"] stringValue];
        NSString *msg_userID = [self getUserId:from];
        NSString *iconPath = [[message attributeForName:@"iconPath"] stringValue];
        
        
        Message_Model *messageModel = [[Message_Model alloc] init];
        messageModel.toUserName = name;
        messageModel.toUser_IconPath = iconPath;
        messageModel.toUserID = [self getUserId:from];
        messageModel.msg_time = time;
        messageModel.msg_ID = msgId;
        messageModel.is_flag = @(YES);
        messageModel.msg_content = msg_content;
        messageModel.cur_userID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;

        [[ChatManager sharedInstace] addMessageModel:messageModel];
        
        /*
        [ChatManager insertChatMessageToUserID:[self getUserId:from]
                                    ToUserName:name
                                ToUserIconPath:iconPath
                                     MessageID:msgId
                                MessageContent:msg_content
                                   MessageTime:time
                                        isShow:NO];
        */
        /*
        [ChatManager insertChatMessageWith:[self getUserId:from]
                                  UserName:name
                                 MessageID:msgId
                            MessageContent:msg_content
                               MessageTime:time isShow:NO];
        */
        
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            
            ChatModel *model = [ChatModel MR_createInContext:localContext];
            model.msg_userID = msg_userID;
            model.userName = name;
            model.user_ID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
            model.msg_message = msg_content;
            model.msg_time = time;
            model.msg_flag = @"YOU";
            model.msg_longitude = longitude;
            model.msg_latitude = latitude;
            model.messageID = msgId;
            model.msg_hasStealth = hasStealth;
            model.msg_hasTime = isTime;
            model.msg_type = @([type intValue]);
            model.msg_send_type = @(SendChatMessageNoReadState);
            debugLog(@"收到的消息->%@-%@",type,model.msg_type);
            NSInteger count = [ChatModel MR_countOfEntitiesWithContext:localContext];
            model.id = @(count+1);
        } completion:^(BOOL success, NSError *error) {
            // 已读操作
            //[self receiptsMessage:msgId ToUserID:[self getUserId:from]];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.privatedelegate respondsToSelector:@selector(didReceiveMessageId:Msg_userID:)]) {
                    [self.privatedelegate didReceiveMessageId:msgId Msg_userID:msg_userID];
                }
            });
        }];
    });
}

- (void)receiptsChatMessage:(XMPPMessage *)message
{
    
    NSString *msgId = [[message attributeForName:@"messageID"] stringValue];

    dispatch_async(readCustomChatQueue, ^{
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageID = %@",msgId];
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            
            ChatModel *chatModel = [ChatModel MR_findFirstWithPredicate:predicate inContext:localContext];
            chatModel.msg_send_type = @(SendChatMessageReadState);
        } completion:^(BOOL success, NSError *error) {
            
        }];

        
    });

    if ([self.privatedelegate respondsToSelector:@selector(didReceiveHasReadResponse:)]) {
        [self.privatedelegate didReceiveHasReadResponse:msgId];
    }
}

- (void)setupCustomQueue
{
    myCustomQueue = dispatch_queue_create("example.MyCustomQueue", NULL);
    myCustomChatQueue = dispatch_queue_create("example.MyCustomChatQueue", NULL);
    readCustomChatQueue = dispatch_queue_create("example.readCustomChatQueue", NULL);
}
@end
