//
//  RegisterView.h
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
/**
 *  注册 第一步 手机号
 */

typedef void (^Block)(NSString *str);


@interface RegisterView : BaseView

@property (strong, nonatomic) UITextField *phoneNumText;

@property (nonatomic, copy)Block block;

- (void)become_FirstResponder;

@end
