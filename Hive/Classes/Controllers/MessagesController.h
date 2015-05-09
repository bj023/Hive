//
//  MessagesController.h
//  Hive
//
//  Created by BaoJun on 15/3/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "MainViewController.h"

@class NearByModel;
@class ChatModel;
typedef void(^MessageControllerBlock)(NearByModel * model);
typedef void(^MessageChatBlock)(ChatModel * model);

@interface MessagesController : MainViewController
@property (nonatomic, copy)MessageControllerBlock messageBlock;
@property (nonatomic, copy)MessageChatBlock chatBlock;

@end
