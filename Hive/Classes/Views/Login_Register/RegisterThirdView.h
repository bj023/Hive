//
//  RegisterThirdView.h
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "BaseView.h"

/**
 *  注册第三步 设置密码
 */

typedef void (^Block)(NSString *str);

@interface RegisterThirdView : BaseView

@property (nonatomic, copy) Block block;

@property (strong, nonatomic) UITextField *userNameText;
@property (strong, nonatomic) UITextField *emailText;
@property (strong, nonatomic) UITextField *passwordText;
@property (strong, nonatomic) UITextField *password1Text;


- (void)become_FirstResponder;
@end
