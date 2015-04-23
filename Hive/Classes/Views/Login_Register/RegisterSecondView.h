//
//  RegisterSecondView.h
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "BaseView.h"
/**
 *  注册第二步 验证码
 */

typedef void (^Block)(NSString *str);

@interface RegisterSecondView : BaseView
@property (nonatomic, copy)Block block;

- (NSString *)hponeCode;

- (void)become_FirstResponder;
@end
