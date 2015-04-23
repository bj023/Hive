//
//  LoginView.h
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
/**
 *  登陆
 */
typedef void (^Block)(NSString *str);

@interface LoginView : BaseView
@property (nonatomic, copy) Block block;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
- (void)become_FirstResponder;
@end
