//
//  ForgetFirstView.h
//  Hive
//
//  Created by 那宝军 on 15/6/15.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "BaseView.h"


typedef void (^Block)(NSString *str);

/**
 *  忘记密码第一步 输入手机号
 */
@interface ForgetFirstView : BaseView

@property (strong, nonatomic) UITextField *phoneNumText;

@property (nonatomic, copy)Block block;

- (void)become_FirstResponder;
@end
