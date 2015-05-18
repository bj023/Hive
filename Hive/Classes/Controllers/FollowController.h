//
//  FollowController.h
//  Hive
//
//  Created by mac on 15/4/19.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "MainViewController.h"
@class NearByModel;
@protocol FollowControllerDelegate;
@interface FollowController : MainViewController
@property (nonatomic, weak) id<FollowControllerDelegate>delegate;
@end

@protocol FollowControllerDelegate <NSObject>
- (void)clickFollow_TalkAction:(NearByModel *)model;
@end