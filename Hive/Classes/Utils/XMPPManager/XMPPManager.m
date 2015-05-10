//
//  XMPPManager.m
//  Hive
//
//  Created by 那宝军 on 15/4/5.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "XMPPManager.h"
#import "Utils.h"
#import "NSTimeUtil.h"
#import "ChatRoomModel.h"
#import "ChatModel.h"

#define kXMPPHost @"115.28.51.196"
#define LITTLEBIRD @"ay130718210956811b81z"

static XMPPManager *sharedManager;

@implementation XMPPManager

+ (XMPPManager *)sharedInstance
{
    /**/
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[XMPPManager alloc] init];
    });
    return sharedManager;

}
//初始化XMPPStream
- (void)setupStream{
    NSLog(@"====初始化XMPPStream====");
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (BOOL)connect
{
    
    [self setupStream];
    
    NSString *userID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
    
    //从本地取得用户名，密码和服务器地址
    NSString *userId = [NSString stringWithFormat:@"%@@%@",userID,LITTLEBIRD];
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
    NSLog(@"connect server --id:%@-password:%@-",userId,pass);
    //设置用户
    [xmppStream setMyJID:[XMPPJID jidWithString:userId]];
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

- (void)signOut
{
    
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
            if ([self.delegate respondsToSelector:@selector(sendPublicMessageSuccessMessageID:)]) {
                [self.delegate sendPublicMessageSuccessMessageID:messageID];
            }
        }
        
        if (messageState)
            NSLog(@"chatRoom->消息已发送");
        else
            NSLog(@"chatRoom->消息发送失败");
        
        //debugLog(@"%@",mes);
    }
}

- (NSString *)getUserId:(NSString *)email
{
    NSRange range;
    range = [email rangeOfString:@"@"];
    return [email stringByPaddingToLength:range.location withString:nil startingAtIndex:0];
}

+ (NSString *)getTime:(NSString *)currentTime
{
    NSArray *array = [ChatRoomModel MR_findAll];
    if (array.count == 0) {
        return currentTime;
    }
    
    ChatRoomModel *model = [array lastObject];

    NSString *h_current = [UtilDate dateFromString:currentTime withFormat:DateFormat_HH];
    NSString *h_time = [UtilDate dateFromString:model.time withFormat:DateFormat_HH];

    NSString *m_current = [UtilDate dateFromString:currentTime withFormat:DateFormat_mm];
    NSString *m_time = [UtilDate dateFromString:model.time withFormat:DateFormat_mm];
    
    debugLog(@"%@-%@  %@-%@",h_current,h_time,m_current,m_time);
    
    if ([h_current intValue]>[h_time intValue] || ([m_current intValue] - [m_time intValue] > 5)) {
        return currentTime;
    }
    return @"";
}


#pragma -mark 私聊 发送消息
- (void)sendNewMessage:(NSString *)message
            MessageID:(NSString *)messageID
                UserID:(NSString *)userID
                  Time:(NSString *)time
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
    
    [mes addAttributeWithName:@"time" stringValue:time];
    [mes addAttributeWithName:@"messageID" stringValue:messageID];
    
    NSString *longitude = [[NSTimeUtil sharedInstance] getCoordinateLongitude];
    NSString *latitude = [[NSTimeUtil sharedInstance] getCoordinateLatitude];
    
    [mes addAttributeWithName:@"longitude" stringValue:longitude];
    [mes addAttributeWithName:@"latitude" stringValue:latitude];
    [mes addAttributeWithName:@"receipts" stringValue:@"NO"];

    //用户名
    [mes addAttributeWithName:@"name" stringValue:[[UserInfoManager sharedInstance] getCurrentUserInfo].userName];
    //隐身
    [mes addAttributeWithName:@"isStealth" stringValue:[[UserInfoManager sharedInstance] getCurrentUserInfo].isStealth];
    
    [body setStringValue:[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    
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

    if (messageState) {
        if ([self.delegate respondsToSelector:@selector(sendPrivateMessageSuccessMessage:)]) {
            [self.delegate sendPrivateMessageSuccessMessage:messageID];
        }
    }
    
    if (messageState)
        NSLog(@"chat->消息已发送");
    else
        NSLog(@"chat->消息发送失败");
    
    //debugLog(@"%@",mes);
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

    NSString *from = [[message attributeForName:@"from"] stringValue];
    NSString *time = [[message attributeForName:@"time"] stringValue];
    NSString *at = [[message attributeForName:@"at"] stringValue];
    NSString *msgId = [[message attributeForName:@"messageID"] stringValue];
    NSString *name = [[message attributeForName:@"name"] stringValue];
    NSString *longitude = [[message attributeForName:@"longitude"] stringValue];
    NSString *latitude = [[message attributeForName:@"latitude"] stringValue];
    NSString *isTime = [XMPPManager getTime:time];
    
    /*
    UIApplication *application = [UIApplication sharedApplication];
    
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    */

    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        ChatRoomModel *model = [ChatRoomModel MR_createInContext:localContext];
        model.userID = [self getUserId:from];
        model.message = [[message elementForName:@"body"]  stringValue];
        model.time = time;
        model.flag = @"YOU";
        model.isAname = at;
        model.longitude = longitude;
        model.latitude = latitude;
        model.messageID = msgId;
        model.userName = name;
        model.isStealth = [[message attributeForName:@"isStealth"] stringValue];
        model.isTime = isTime;
        NSInteger count = [ChatRoomModel MR_countOfEntitiesWithContext:localContext];
        model.id = @(count+1);
        
        debugLog(@"/n/n/nchatRoom->%@/n/n/n",model.id);
        
    } completion:^(BOOL success, NSError *error) {
        
        //[application endBackgroundTask:bgTask];
        //bgTask = UIBackgroundTaskInvalid;
        
        if ([self.delegate respondsToSelector:@selector(receiveChatRoomMessageWithMessageID:)]) {
            [self.delegate receiveChatRoomMessageWithMessageID:msgId];
        }
    }];
     
}

// 私聊
- (void)receiveChatMessage:(XMPPMessage *)message
{
    NSString *from = [[message attributeForName:@"from"] stringValue];
    NSString *time = [[message attributeForName:@"time"] stringValue];
    NSString *msgId = [[message attributeForName:@"messageID"] stringValue];
    NSString *name = [[message attributeForName:@"name"] stringValue];
    NSString *longitude = [[message attributeForName:@"longitude"] stringValue];
    NSString *latitude = [[message attributeForName:@"latitude"] stringValue];
    NSString *receipts = [[message attributeForName:@"receipts"] stringValue];//已读操作
    NSString *hasStealth = [[message attributeForName:@"isStealth"] stringValue];
    NSString *isTime = [XMPPManager getTime:time];
    
    /*
    dispatch_queue_t myCustomQueue2 = dispatch_queue_create("example.MyCustomQueue2", NULL);
    dispatch_async(myCustomQueue2, ^{
        for (int abc=0;abc<100;abc++)
        {
            printf("3. myCustomQueue2 Do some work here.\n");
        }
    });
    dispatch_async(myCustomQueue2, ^{
        for (int abc=0;abc<100;abc++)
        {
            printf("4. myCustomQueue2 Do some work here.\n");
        }
    });
    */
    UIApplication *application = [UIApplication sharedApplication];
    
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
     
    /**/
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        //NSInteger idStart = [ChatModel MR_findAllInContext:localContext].count;

        ChatModel *model = [ChatModel MR_createInContext:localContext];
        model.userID = [self getUserId:from];
        model.message = [[message elementForName:@"body"]  stringValue];
        model.time = time;
        model.flag = @"YOU";
        model.longitude = longitude;
        model.latitude = latitude;
        model.messageID = msgId;
        model.userName = name;
        model.hasStealth = hasStealth;
        model.hasRead = @"NO";
        model.hasTime = isTime;
        NSInteger count = [ChatModel MR_countOfEntitiesWithContext:localContext];
        model.id = @(count+1);

        debugLog(@"/n/n/nchat->%@/n/n/n",model.id);

    } completion:^(BOOL success, NSError *error) {
     
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
     
        debugLog(@"receipts->%@",receipts);
        // 已读操作
        [self receiptsMessage:msgId ToUserID:[self getUserId:from]];
        
        if ([self.delegate respondsToSelector:@selector(receiveChatMessageWithMessageID:)]) {
            [self.delegate receiveChatMessageWithMessageID:msgId];
        }
    }];
}

- (void)receiptsChatMessage:(XMPPMessage *)message
{
    NSString *msgId = [[message attributeForName:@"messageID"] stringValue];
    NSString *receipts = [[message attributeForName:@"receipts"] stringValue];//已读操作

    debugLog(@"receipts->%@",receipts);

    if ([self.delegate respondsToSelector:@selector(receiptsChatMessageWithMessageID:)]) {
        [self.delegate receiptsChatMessageWithMessageID:msgId];
    }
    
}
@end
