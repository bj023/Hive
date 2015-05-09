//
//  BlockListController.h
//  Hive
//
//  Created by 那宝军 on 15/4/11.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "MainViewController.h"

@class NearByModel;

@protocol BlockListControllerDelegate;
@interface BlockListController : MainViewController

@property (nonatomic, weak) id<BlockListControllerDelegate>delegate;

@end

@protocol BlockListControllerDelegate <NSObject>
- (void)clickBlock_TalkAction:(NearByModel *)model;
@end