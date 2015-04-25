//
//  XMPPManager.h
//  Hive
//
//  Created by 那宝军 on 15/4/5.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPP.h>
#import <XMPPRoom.h>

@interface XMPPManager : NSObject
{
    //XMPP
    XMPPStream *xmppStream;
    NSString *password;  //密码
    BOOL isOpen;  //xmppSt ream是否开着
    XMPPRoom *xmppRoom;
}

+ (XMPPManager*)sharedInstance;

//是否连接
- (BOOL)connect;
//断开连接
- (void)disconnect;

//设置XMPPStream
- (void)setupStream;
//上线
- (void)goOnline;
//下线
- (void)goOffline;

- (void)signOut;

- (void)sendNewMessage:(NSString *)message;
@end
