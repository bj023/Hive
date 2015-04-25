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

- (BOOL)connect{
    
    [self setupStream];
    
    //从本地取得用户名，密码和服务器地址
    NSString *userId = [NSString stringWithFormat:@"%@@%@",@"79",LITTLEBIRD];
    NSString *pass = @"123456";
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
    NSLog(@"message =========== %@", message);
    NSString *type =[[message attributeForName:@"type"] stringValue];
//    NSString *myFlag = [[message attributeForName:@"flag"] stringValue];
//    NSString *from = [[message attributeForName:@"from"] stringValue];
//    NSString *time = [[message attributeForName:@"time"] stringValue];
//    NSString *at = [[message attributeForName:@"at"] stringValue];
//    NSString *msgId = [[message attributeForName:@"msgId"] stringValue];
//    NSString *receipts = [[message attributeForName:@"receipts"] stringValue];
    NSLog(@"type : %@",type);
    
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
{
    NSString *mytime =[UtilDate getCurrentTime];

    
    NSXMLElement *body;
    NSXMLElement *mes;
    
    for (NSString *toUserID in [[NSTimeUtil sharedInstance] getChatUserIDs]) {
        
        //生成<body>文档
        body = [NSXMLElement elementWithName:@"body"];
        //生成XML消息文档
        mes = [NSXMLElement elementWithName:@"message"];
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"chat"];
        [mes addAttributeWithName:@"flag" stringValue:@"public"];
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@%@",[[UserInfoManager sharedInstance] getCurrentUserInfo].userID,LITTLEBIRD]];
        [mes addAttributeWithName:@"time" stringValue:mytime];
        //组合
        [mes addChild:body];
        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@/%@",@"NO",LITTLEBIRD,toUserID]];
        //发送消息
        XMPPElementReceipt *receipt = [[XMPPElementReceipt alloc] init];
        [xmppStream sendElement:mes andGetReceipt:&receipt];
        BOOL messageState =[receipt wait:-1];
        if (messageState)
            NSLog(@"消息已发送");
        else
            NSLog(@"消息发送失败");
    }
}


- (void)sendNewMessage:(NSString *)message to:(NSString *)chatUser
{
    
}
@end
