//
//  ForgetSecondView.h
//  Hive
//
//  Created by 那宝军 on 15/6/15.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "BaseView.h"

typedef void (^Block)(NSString *str);

/**
 *  忘记密码第二步 输入验证码
 */
@interface ForgetSecondView : BaseView

@property (nonatomic, copy)Block block;

- (NSString *)hponeCode;

- (void)become_FirstResponder;

@end
