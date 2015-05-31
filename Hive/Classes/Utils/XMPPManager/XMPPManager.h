//
//  XMPPManager.h
//  Hive
//
//  Created by mac on 15/4/5.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPP.h>
#import <XMPPRoom.h>
#import "ChatMessageDelegate.h"

@interface XMPPManager : NSObject
{
    //XMPP
    XMPPStream *xmppStream;
    NSString *password;  //密码
    BOOL isOpen;  //xmppSt ream是否开着
    XMPPRoom *xmppRoom;
}

@property (nonatomic, weak)id<ChatPublicMessageDelegate>publicDelegate;
@property (nonatomic, weak)id<ChatPrivateMessageDelegate>privatedelegate;

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

- (XMPPStream *)getXMPPStream;

- (NSString *)getUserId:(NSString *)userID;


- (void)sendNewMessage:(NSString *)message
                  Time:(NSString *)time
               Message:(NSString *)messageID
               isAname:(NSString *)aName;

+ (NSString *)getChatRoomTime:(NSString *)currentTime;
+ (NSString *)getChatTime:(NSString *)currentTime ToUserID:(NSString *)userID;
@end
