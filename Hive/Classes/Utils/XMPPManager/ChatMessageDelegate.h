//
//  ChatMessageDelegate.h
//  Hive
//
//  Created by mac on 15/4/26.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChatPublicMessageDelegate <NSObject>

- (void)sendPublicMessageSuccessMessageID:(NSString *)messageID Send:(BOOL)isSend;
- (void)receiveChatRoomMessageWithMessageID:(NSString *)messageID;

@end


@protocol ChatPrivateMessageDelegate <NSObject>

- (void)sendPrivateMessageSuccessMessage:(NSString *)messageID Send:(BOOL)isSend;
- (void)receiveChatMessageWithMessageID:(NSString *)messageID;
- (void)receiptsChatMessageWithMessageID:(NSString *)messageID;

@end