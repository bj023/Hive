//
//  LoginController.h
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "MainViewController.h"

typedef enum{
    SelectSignInType = 1,
    SelectSignUpType = 2,
} SelectVCType;

@interface LoginController : MainViewController
@property (nonatomic ,assign) SelectVCType selectType;
@end
