//
//  ChatController.h
//  Hive
//
//  Created by 那宝军 on 15/5/20.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface ChatController : MainViewController

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userName;

- (void)reloadData;

@end
