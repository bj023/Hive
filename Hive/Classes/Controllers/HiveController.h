//
//  HiveController.h
//  Hive
//
//  Created by BaoJun on 15/3/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "MainViewController.h"

@class NearByModel;

typedef void(^HiveControllerBlock)(NearByModel * model);

@interface HiveController : MainViewController

@property (nonatomic, copy)HiveControllerBlock hiveBlock;

- (void)set_HiddenKeyboard;
@end
