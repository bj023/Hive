//
//  ForgetThirdView.h
//  Hive
//
//  Created by 那宝军 on 15/6/15.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "BaseView.h"

typedef void (^Block)(NSString *str);

/**
 *  忘记第三步 设置密码
 */
@interface ForgetThirdView : BaseView

@property (nonatomic, copy) Block block;

@property (strong, nonatomic) UITextField *passwordText;

@property (strong, nonatomic) UITextField *password1Text;

- (void)become_FirstResponder;

@end
