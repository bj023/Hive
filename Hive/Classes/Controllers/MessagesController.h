//
//  MessagesController.h
//  Hive
//
//  Created by BaoJun on 15/3/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "MainViewController.h"

@class NearByModel;
@class MessageModel;
typedef void(^MessageControllerBlock)(NearByModel * model);
typedef void(^MessageChatBlock)(MessageModel * model);

@interface MessagesController : MainViewController
@property (nonatomic, copy)MessageControllerBlock messageBlock;
@property (nonatomic, copy)MessageChatBlock chatBlock;

- (void)reloadChatMessage;

@end
