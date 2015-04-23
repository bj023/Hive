//
//  NearByModel.h
//  Hive
//
//  Created by 那宝军 on 15/4/7.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "JSONModel.h"

@interface NearByModel : JSONModel
@property (assign, nonatomic) int age;
@property (assign, nonatomic) int isBlocked;
@property (assign, nonatomic) int isFriend;
@property (assign, nonatomic) int userId;

@property (strong, nonatomic) NSString *distance;// 距离
@property (strong, nonatomic) NSString *gender;// 性别
@property (strong, nonatomic) NSString *iconPath;// 头像

@property (strong, nonatomic) NSString *label; // 介绍
@property (strong, nonatomic) NSString *userName;// 用户名

@property (assign, nonatomic) int hours;
@property (assign, nonatomic) int minutes;
@property (assign, nonatomic) int month;
@property (assign, nonatomic) int date;

@end
