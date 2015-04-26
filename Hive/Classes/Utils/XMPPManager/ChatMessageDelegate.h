//
//  ChatMessageDelegate.h
//  Hive
//
//  Created by 那宝军 on 15/4/26.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChatMessageDelegate <NSObject>
-(void)receiveChatMessageWithMessageID:(NSString *)messageID;
@end
