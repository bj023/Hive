//
//  LoginViewController.m
//  Hive
//
//  Created by 那宝军 on 15/5/27.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "LoginViewController.h"
#import "Utils.h"
#import "LoginController.h"

#define Color [UIColor colorWithRed:100/255.0 green:186/255.0 blue:255/255.0 alpha:1]

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackGroundColor];
    [self configButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark 设置背景
- (void)setBackGroundColor
{
    self.view.backgroundColor = Color;
}

#pragma -mark 按钮
- (void)configButton
{
    NSString *string = @"CHAT WITH PEOPLE";
    NSString *string1 = @"AROUND YOU";

    CGFloat x = 0;
    CGFloat y = UIHEIGHT/2 - 100;
    CGFloat w = UIWIDTH;
    CGFloat h = 30;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    label.font = [UIFont fontWithName:GothamRoundedBook size:34/2];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = string;
    [self.view addSubview:label];
    
    y = y + h + 10;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    label1.font = [UIFont fontWithName:GothamRoundedBook size:34/2];
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.numberOfLines = 0;
    label1.text = string1;
    [self.view addSubview:label1];
    
    w = UIWIDTH;
    h = 100/2;
    x = 0;
    y = UIHEIGHT - h;
    UIButton *signOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signOutBtn.frame = CGRectMake(x, y, w, h);
    signOutBtn.backgroundColor = [UIColor clearColor];
    [signOutBtn setTitle:@"sign up" forState:UIControlStateNormal];
    signOutBtn.titleLabel.font = [UIFont fontWithName:GothamRoundedBook size:16];
    [self.view addSubview:signOutBtn];
    
    y = y - h;
    UIButton *signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signInBtn.frame = CGRectMake(x, y, w, h);
    signInBtn.backgroundColor = [UIColor whiteColor];
    [signInBtn setTitleColor:Color forState:UIControlStateNormal];
    [signInBtn setTitle:@"sign in" forState:UIControlStateNormal];
    signInBtn.titleLabel.font = [UIFont fontWithName:GothamRoundedBook size:16];
    [self.view addSubview:signInBtn];
    
    [signInBtn addTarget:self action:@selector(clickLogIn:) forControlEvents:UIControlEventTouchUpInside];
    [signOutBtn addTarget:self action:@selector(clickLogOut:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)clickLogIn:(id)sender
{
    LoginController *vc = [[LoginController alloc] init];
    vc.selectType = SelectSignInType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickLogOut:(id)sender
{
    LoginController *vc = [[LoginController alloc] init];
    vc.selectType = SelectSignUpType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showErrorWithText:(NSString *)text
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [MBProgressHUD showTextHUDAddedTo:self.view withText:text animated:YES];
}

#pragma -mark 保存用户信息到本地
- (void)handleLoginCenterManager:(LoginModel *)loginModel Password:(NSString *)xmpp_password
{
    CurrentUserInfo *user = [[CurrentUserInfo alloc]init];
    user.deviceToken = loginModel.deviceToken;
    user.userID = loginModel.userId;
    user.userHead = loginModel.iconPath;
    user.userName = loginModel.userName;
    user.userSex = loginModel.gender;
    user.userIntro = loginModel.label;
    user.userAge  = [NSString stringWithFormat:@"%d",loginModel.age];
    user.xmppPassWord = xmpp_password;
    user.isStealth = [NSString stringWithFormat:@"%d",loginModel.hide];
    UserInfoManager *manager = [UserInfoManager sharedInstance];
    [manager saveUserInfoToDisk:user];
}

- (void)handleSetRootViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setRootViewController" object:nil];
}
@end
