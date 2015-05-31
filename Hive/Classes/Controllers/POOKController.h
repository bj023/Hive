//
//  POOKController.h
//  Hive
//
//  Created by 那宝军 on 15/5/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "MainViewController.h"
@class NearByModel;

typedef void(^HiveControllerBlock)(NearByModel * model);

@interface POOKController : MainViewController
@property (nonatomic, copy)HiveControllerBlock hiveBlock;

- (void)set_HiddenKeyboard;
@end
