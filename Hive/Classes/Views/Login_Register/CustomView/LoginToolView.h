//
//  LoginToolView.h
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  登陆底部菜单
 */

typedef void (^LoginToolBarBlock)(NSString *str);


@interface LoginToolView : UIView
@property (nonatomic, strong) LoginToolBarBlock block;
@end
