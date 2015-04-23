//
//  UserInfoManager.m
//  Hive
//
//  Created by BaoJun on 15/3/31.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "UserInfoManager.h"

@implementation CurrentUserInfo

//属性变量转码
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.deviceToken forKey:@"deviceToken"];
    [coder encodeObject:self.userID forKey:@"userID"];
    [coder encodeObject:self.userPhoneNumber forKey:@"userPhoneNumber"];
    [coder encodeObject:self.userEmail forKey:@"userEmail"];
    [coder encodeObject:self.userName forKey:@"userName"];
    [coder encodeObject:self.userHead forKey:@"userHead"];
    [coder encodeObject:self.userAge forKey:@"userAge"];
    [coder encodeObject:self.userSex forKey:@"userSex"];
    [coder encodeObject:self.xmppUserName forKey:@"xmppUserName"];
    [coder encodeObject:self.xmppPassWord forKey:@"xmppPassWord"];
}

//把属性变量根据关键字进行逆转码，最后返回一个类的对象
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self){
        self.deviceToken     = [decoder decodeObjectForKey:@"deviceToken"];
        self.userID = [decoder decodeObjectForKey:@"userID"];
        self.userPhoneNumber = [decoder decodeObjectForKey:@"userPhoneNumber"];
        self.userEmail       = [decoder decodeObjectForKey:@"userEmail"];
        self.userName        = [decoder decodeObjectForKey:@"userName"];
        self.userHead        = [decoder decodeObjectForKey:@"userHead"];
        self.userAge         = [decoder decodeObjectForKey:@"userAge"];
        self.userSex         = [decoder decodeObjectForKey:@"userSex"];
        self.xmppUserName    = [decoder decodeObjectForKey:@"xmppUserName"];
        self.xmppPassWord    = [decoder decodeObjectForKey:@"xmppPassWord"];
    }
    return self;
}
@end

@interface UserInfoManager ()
@property(strong, nonatomic) CurrentUserInfo *userInfo;
@end

@implementation UserInfoManager
- (id)init
{
    self = [super init];
    if (self) {
        self.userInfo = [[CurrentUserInfo alloc]init];
    }
    return self;
}

//获得UserInfoManager单例对象
+ (UserInfoManager *)sharedInstance
{
    static UserInfoManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [[self alloc]init];
    });
    return instance;
}
//判断用户是否登录
- (BOOL)checkUserIsLogin
{
    NSString *path = [self userInfoCachPath];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        NSData *userInfodata = [[NSData alloc]initWithContentsOfFile:path];
        if (nil!=userInfodata)
            return YES;
        else
            return NO;
    } else {
        return NO;
    }
}

//把用户信息保存到磁盘上
- (void)saveUserInfoToDisk:(CurrentUserInfo *)userINfo {
    
    self.userInfo = userINfo;
    NSString *path = [self userInfoCachPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    NSData *userCacheData=[NSKeyedArchiver archivedDataWithRootObject:self.userInfo];
    [userCacheData writeToFile:path atomically:YES];
}

//从磁盘上读取用户信息
- (void)loadUserInfoFromDisk
{
    if ([self checkUserIsLogin]) {
        NSString *path = [self userInfoCachPath];
        NSData*userCacheData=[[NSData alloc]initWithContentsOfFile:path];
        self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userCacheData];
    }
}
//获得用户信息的保存路径
- (NSString *)userInfoCachPath
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [cachePath stringByAppendingPathComponent:@"userInfo.data"];
}

//获取当前用户信息
-(CurrentUserInfo *)getCurrentUserInfo
{
    return self.userInfo;
}

//注销
-(void)logOut
{
    self.userInfo = nil;
    NSString *path = [self userInfoCachPath];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}
@end
