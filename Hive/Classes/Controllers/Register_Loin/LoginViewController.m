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
{
    UIView *_mainView;
}
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
    [self startAnimate];
}

- (void)startAnimate
{
    _mainView.center = CGPointMake(UIWIDTH/2, UIHEIGHT);
    [UIView animateWithDuration:0.5 animations:^{
        _mainView.center = CGPointMake(UIWIDTH/2, UIHEIGHT/2);
    }];
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
    _mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    _mainView.backgroundColor = [UIColor clearColor];
    _mainView.userInteractionEnabled = YES;
    [self.view addSubview:_mainView];
    
    CGFloat helpWH = 25;
    UIButton *helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    helpBtn.frame = CGRectMake(UIWIDTH - 40, 20, helpWH, helpWH);
    [helpBtn setTitle:@"?" forState:UIControlStateNormal];
    helpBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [helpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    helpBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    helpBtn.layer.borderWidth = 1;
    helpBtn.layer.cornerRadius = helpWH/2;
    [self.view addSubview:helpBtn];
    
    UIImage *image = [UIImage imageNamed:@"Logo"];
   
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    CGFloat x = UIWIDTH/2 - w/2;
    CGFloat y = 100;
    UIImageView *logoIMG = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    logoIMG.image = image;
    [_mainView addSubview:logoIMG];
    
    //NSString *string = @"CHAT WITH PEOPLE AROUND YOU";
    NSString *string = @"Chat With People Around You";
    NSString *string1 = @"AROUND YOU";

    y = y + h + 30;
    w = UIWIDTH/2;
    x = UIWIDTH/2 - w/2;
    h = 50;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    label.font = [UIFont fontWithName:GothamRoundedBold size:34/2];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = string;
    [_mainView addSubview:label];
    
    
    y = y + h + 10;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    label1.font = [UIFont fontWithName:GothamRoundedBook size:34/2];
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.numberOfLines = 0;
    label1.text = string1;
    //[self.view addSubview:label1];
    
    w = UIWIDTH;
    h = 100/2;
    x = 0;
    y = UIHEIGHT - h;
    UIButton *signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signInBtn.frame = CGRectMake(x, y, w, h);
    signInBtn.backgroundColor = [UIColor clearColor];
    [signInBtn setTitle:@"Log In" forState:UIControlStateNormal];
    signInBtn.titleLabel.font = [UIFont fontWithName:Font_Medium size:17];
    [_mainView addSubview:signInBtn];

    y = y - h;
    UIButton *signOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signOutBtn.frame = CGRectMake(x, y, w, h);
    signOutBtn.backgroundColor = [UIColor whiteColor];
    [signOutBtn setTitleColor:Color forState:UIControlStateNormal];
    [signOutBtn setTitle:@"Sign Up" forState:UIControlStateNormal];
    signOutBtn.titleLabel.font = [UIFont fontWithName:Font_Medium size:17];
    [_mainView addSubview:signOutBtn];

    
    [signInBtn setBackgroundImage:[UIColorUtil createImageWithColor:NormalColor] forState:UIControlStateNormal];
    [signOutBtn setBackgroundImage:[UIColorUtil createImageWithColor:HighlightedColor] forState:UIControlStateHighlighted];
    
    [signOutBtn setBackgroundImage:[UIColorUtil createImageWithColor:kLine_Color] forState:UIControlStateHighlighted];

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
