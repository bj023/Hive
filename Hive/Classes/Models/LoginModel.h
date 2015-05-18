//
//  LoginModel.h
//  Hive
//
//  Created by mac on 15/4/7.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "JSONModel.h"

@interface LoginModel : JSONModel

@property (nonatomic, strong) NSString *deviceToken;// 推送 token
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *iconPath; // 头像
@property (nonatomic, strong) NSString *userName; // 用户名
@property (nonatomic, strong) NSString *userId; // 用户ID
@property (nonatomic, assign) int age; // 年龄
@property (nonatomic, assign) float longitude;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) int hide;
@property (nonatomic, strong) NSString *label;
@end
