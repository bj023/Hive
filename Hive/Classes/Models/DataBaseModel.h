//
//  DataBaseModel.h
//  Hive
//
//  Created by mac on 15/4/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChatRoomModel;
@interface DataBaseModel : NSObject

+ (NSArray *)getChatWithStartChatRoom:(ChatRoomModel *)model andCount:(NSInteger)count;


@end
