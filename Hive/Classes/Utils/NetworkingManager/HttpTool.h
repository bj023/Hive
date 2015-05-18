//
//  HttpTool.h
//  Hive
//
//  Created by BaoJun on 15/3/30.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"


typedef void(^ResponseSuccBlcok)(id json);

@interface HttpTool : NSObject



#pragma -mark 发送请求回调

/**
 *  封装 登陆 发送请求
 *
 *  @param userName 用户名
 *  @param password 用户密码
 *  @param success  成功回调
 *  @param faliure  失败回调
 */
+ (void)sendRequestWithUserName:(NSString *)userName
                       Password:(NSString *)password
                        success:(ResponseSuccBlcok)success
                        faliure:(HttpFailBlcok)faliure;


/**
 *  封装 附近人 发送请求
 *
 *  @param longitude 经度
 *  @param latitude  纬度
 *  @param gender    性别
 *  @param success   成功回调
 *  @param faliure   失败回调
 */
+ (void)sendRequestWithLongitude:(NSString *)longitude
                        Latitude:(NSString *)latitude
                          Gender:(NSString *)gender
                     StartNumber:(NSInteger)startNum
                     NumberCount:(NSInteger)numCount
                         success:(ResponseSuccBlcok)success
                         faliure:(HttpFailBlcok)faliure;

/**
 *  封装 附近人 关注 发送请求
 *
 *  @param friendID 关注对方ID
 *  @param success  成功回调
 *  @param faliure  失败回调
 */
+ (void)sendRequestWithFollow:(NSString *)friendID
                      success:(ResponseSuccBlcok)success
                      faliure:(HttpFailBlcok)faliure;
/**
 *  封装 附近人 取消关注
 *
 *  @param friendID 取消关注 用户 ID
 *  @param success  成功回调
 *  @param faliure  失败回调
 */
+ (void)sendRequestWithCancelFollow:(NSString *)friendID
                            success:(ResponseSuccBlcok)success
                            faliure:(HttpFailBlcok)faliure;

/**
 *  封装 附近人 屏蔽用户 发送请求
 *
 *  @param friendID 屏蔽用户ID
 *  @param success  成功回调
 *  @param faliure  失败回调
 */
+ (void)sendRequestWithBLockUser:(NSString *)friendID
                         success:(ResponseSuccBlcok)success
                         faliure:(HttpFailBlcok)faliure;


/**
 *  封装 拉取推送设置
 *
 *  @param success 成功回调
 *  @param faliure 失败回调
 */
+ (void)sendRequestSettingsNotificationSuccess:(ResponseSuccBlcok)success
                                       faliure:(HttpFailBlcok)faliure;

/**
 *  封装 手机号注册
 *
 *  @param phoneNum 手机号
 *  @param success  成功回调
 *  @param faliure  失败回调
 */
+ (void)sendRequestRegisterPhoneNum:(NSString *)phoneNum
                            success:(ResponseSuccBlcok)success
                            faliure:(HttpFailBlcok)faliure;

/**
 *  封装 手机号 验证码
 *
 *  @param code    验证码
 *  @param success 成功回调
 *  @param faliure 失败回调
 */
+ (void)sendRequestRegisterCode:(NSString *)code
                       PhoneNum:(NSString *)phonenum
                        success:(ResponseSuccBlcok)success
                        faliure:(HttpFailBlcok)faliure;
/**
 *  封装 注册
 *
 *  @param email    邮箱
 *  @param username 用户名
 *  @param password 密码
 *  @param success  成功回调
 *  @param faliure  失败回调
 */
+ (void)sendRequestRegisterEmail:(NSString *)email
                        UserName:(NSString *)username
                        Passwowd:(NSString *)password
                        PhoneNum:(NSString *)phoneNum
                         success:(ResponseSuccBlcok)success
                         faliure:(HttpFailBlcok)faliure;
/**
 *  注册 第四步
 *
 *  @param sex     性别
 *  @param age     年龄
 *  @param success 成功回调
 *  @param faliure 失败回调
 */
+ (void)sendRequestRegisterUserInforSex:(NSString *)sex
                                    Age:(NSString *)age
                                success:(ResponseSuccBlcok)success
                                faliure:(HttpFailBlcok)faliure;
/**
 *  封装 邮箱验证
 *
 *  @param email   邮箱
 *  @param success 成功回调
 *  @param faliure 失败回调
 */
+ (void)sendRequestRegisterEmailExist:(NSString *)email
                              success:(ResponseSuccBlcok)success
                              faliure:(HttpFailBlcok)faliure;
/**
 *  封装 修改用户信息
 *
 *  @param username 用户名
 *  @param label    签名
 *  @param gender   性别
 *  @param success  成功回调
 *  @param faliure  失败回调
 */
+ (void)sendRequestUpdateProfileUserName:(NSString *)username
                                   Label:(NSString *)label
                                  Gender:(NSString *)gender
                                 success:(ResponseSuccBlcok)success
                                 faliure:(HttpFailBlcok)faliure;

/**
 *  封装 修改用户名 发送请求
 *
 *  @param new_userName 新的用户名
 *  @param success      成功回调
 *  @param faliure      失败回调
 */
+ (void)sendRequestWithUpdateProfile:(NSString *)new_userName
                             success:(ResponseSuccBlcok)success
                             faliure:(HttpFailBlcok)faliure;


/**
 *  封装 隐身
 *
 *  @param hiding  hide 0隐身，1不隐身
 *  @param success 成功回调
 *  @param faliure 失败回调
 */
+ (void)sendRequestHiding:(NSString *)hiding
                  success:(ResponseSuccBlcok)success
                  faliure:(HttpFailBlcok)faliure;

/**
 *  封装 禁止关注
 *
 *  @param follow  能否被关注 0不能 1能
 *  @param success 成功回调
 *  @param faliure 失败回调
 */
+ (void)sendRequestBeFollow:(NSString *)follow
                    success:(ResponseSuccBlcok)success
                    faliure:(HttpFailBlcok)faliure;

/**
 *  封装 屏蔽列表
 *
 *  @param success 成功回调
 *  @param faliure 失败回调
 */
+ (void)sendRequestBlockListSuccess:(ResponseSuccBlcok)success
                            faliure:(HttpFailBlcok)faliure;
/**
 *  封装 关注列表
 *
 *  @param success 成功回调
 *  @param faliure 失败回调
 */
+ (void)sendRequestFollowListSuccess:(ResponseSuccBlcok)success
                             faliure:(HttpFailBlcok)faliure;

/**
 *  封装 聊天大厅 用户列表
 *
 *  @param longitude 经度
 *  @param latitude  纬度
 *  @param success   成功回调
 *  @param faliure   失败回调
 */
+ (void)sendRequestChatRoomWithLongitude:(NSString *)longitude
                                Latitude:(NSString *)latitude
                                 success:(ResponseSuccBlcok)success
                                 faliure:(HttpFailBlcok)faliure;

/**
 *  封装 更新用户位置
 *
 *  @param longitude 经度
 *  @param latitude  纬度
 *  @param success   成功回调
 *  @param faliure   失败回调
 */
+ (void)sendRequestUpdateUserLocation:(NSString *)longitude
                             Latitude:(NSString *)latitude
                              success:(ResponseSuccBlcok)success
                              faliure:(HttpFailBlcok)faliure;

/**
 *  封装 点击用户头像 查看信息
 *
 *  @param userID  用户ID
 *  @param success 成功回调
 *  @param faliure 失败回调
 */
+ (void)sendRequestProfileWithUserID:(NSString *)userID
                             success:(ResponseSuccBlcok)success
                             faliure:(HttpFailBlcok)faliure;

/**
 *  获取 用户距离
 *
 *  @param longitude 经度
 *  @param latitude  纬度
 *  @param success   成功回调
 *  @param faliure   失败回调
 */
+ (void)sendRequestGetDistanceLongitude:(NSString *)longitude
                               Latitude:(NSString *)latitude
                             success:(ResponseSuccBlcok)success
                             faliure:(HttpFailBlcok)faliure;

/**
 *  发送 推送 消息提示
 *
 *  @param message  消息
 *  @param friendID 接收方
 *  @param receipts 读操作
 *  @param success  成功回调
 *  @param faliure  失败回调
 */
+ (void)sendRequestPushMessage:(NSString *)message
                      ToUserID:(NSString *)friendID
                      Receipts:(NSString *)receipts
                       success:(ResponseSuccBlcok)success
                       faliure:(HttpFailBlcok)faliure;
/**
 *  上传 头像 图片
 */
+ (void)sendRequestUploadHeadImg:(NSData *)imgData
                         success:(ResponseSuccBlcok)success
                         faliure:(HttpFailBlcok)faliure;

+ (void)sendRequestLogOutsuccess:(ResponseSuccBlcok)success
                         faliure:(HttpFailBlcok)faliure;
// 更新 token
+ (void)sendRequestUpdateDeviceToken:(NSString *)token
                             success:(ResponseSuccBlcok)success
                             faliure:(HttpFailBlcok)faliure;
@end
