//
//  UserInfoManager.h
//  Hive
//
//  Created by BaoJun on 15/3/31.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentUserInfo : NSObject<NSCoding>
@property (copy, nonatomic) NSString *userID;
@property (copy, nonatomic) NSString *deviceToken;
@property (copy, nonatomic) NSString *userPhoneNumber;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *userHead;
@property (copy, nonatomic) NSString *userEmail;
@property (copy, nonatomic) NSString *userAge;
@property (copy, nonatomic) NSString *userSex;
@property (copy, nonatomic) NSString *isStealth;
//@property (copy, nonatomic) NSString *userLongitude;
//@property (copy, nonatomic) NSString *userLatitude;

@property (strong, nonatomic) NSString *xmppUserName;// XMPP登陆用户名
@property (strong, nonatomic) NSString *xmppPassWord;// XMPP登陆密码
@end

@interface UserInfoManager : NSObject

//获得UserInfoManager单例对象
+ (UserInfoManager *)sharedInstance;

//判断用户是否登录
- (BOOL)checkUserIsLogin;
//获取当前用户信息
- (CurrentUserInfo *)getCurrentUserInfo;
//把CurrentUserInfo转换为User然后返回
//把用户信息保存到磁盘上
- (void)saveUserInfoToDisk:(CurrentUserInfo *)userINfo;
//从磁盘上读取用户信息
- (void)loadUserInfoFromDisk;
//把一个User对象转换为CurrentUserInfo存到磁盘上
//注销
-(void)logOut;
@end
