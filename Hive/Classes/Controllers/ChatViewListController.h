//
//  ChatViewListController.h
//  Hive
//
//  Created by 那宝军 on 15/5/20.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@class NearByModel;
@class MessageModel;
typedef void(^MessageControllerBlock)(NearByModel * model);
typedef void(^MessageChatBlock)(MessageModel * model);

@interface ChatViewListController : MainViewController

@property (nonatomic, copy)MessageControllerBlock messageBlock;
@property (nonatomic, copy)MessageChatBlock chatBlock;

- (void)refreshDataSource;

@end
