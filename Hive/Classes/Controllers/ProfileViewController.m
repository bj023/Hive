//
//  ProfileViewController.m
//  Hive
//
//  Created by 那宝军 on 15/5/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ProfileViewController.h"
#import "FRDLivelyButton.h"
#import "Utils.h"

#define ProfileColor [UIColor colorWithRed:100/255.0 green:186/255.0 blue:255/255.0 alpha:1]

@interface ProfileViewController ()
{
    UITextField *_nameField;
    UITextField *_introField;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCloseBtn];
    [self configToolBarView];
    [self configProfile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    _nameField.text = [[UserInfoManager sharedInstance] getCurrentUserInfo].userName;
    _introField.text = [[UserInfoManager sharedInstance] getCurrentUserInfo].userIntro;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)configCloseBtn
{
    UIColor *color = [UIColor colorWithRed:100/255.0 green:186/255.0 blue:255/255.0 alpha:1];
    FRDLivelyButton *button = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(UIWIDTH - 36 - 10,10,36,28)];
    [button setOptions:@{ kFRDLivelyButtonLineWidth: @(2.0f),
                          kFRDLivelyButtonHighlightedColor:color,
                          kFRDLivelyButtonColor: color
                          }];
    [button setStyle:kFRDLivelyButtonStyleClose animated:YES];
    [button addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
// 关闭
- (void)closeButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configToolBarView
{
    UIButton *toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toolBtn.frame =CGRectMake(0, UIHEIGHT - 50, UIWIDTH, 50);
    [toolBtn setTitle:@"SAVE" forState:UIControlStateNormal];
    [toolBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[toolBtn setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:100/255.0 green:186/255.0 blue:255/255.0 alpha:0.5] size:toolBtn.frame.size] forState:UIControlStateNormal];
    //[toolBtn setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:100/255.0 green:186/255.0 blue:255/255.0 alpha:0.6] size:toolBtn.frame.size] forState:UIControlStateHighlighted];
    //关闭颜色
    toolBtn.backgroundColor = ProfileColor;
    toolBtn.titleLabel.font = [UIFont fontWithName:GothamRoundedBold size:18];
    [self.view addSubview:toolBtn];
    [toolBtn addTarget:self action:@selector(clickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
}
// 保存
- (void)clickSaveBtn:(id)sender
{
    [self.view endEditing:YES];
    [self sendUpdateProfileRequest];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)configProfile
{
    CGFloat profileX = 0;
    CGFloat profileY = 100;
    CGFloat profileW = UIWIDTH;
    CGFloat profileH = 80;
    UIView * profileView = [[UIView alloc] init];
    profileView.backgroundColor = [UIColor clearColor];
    profileView.frame = CGRectMake(profileX, profileY, profileW, profileH);
    [self.view addSubview:profileView];
    
    CGFloat nameX = 40;
    CGFloat nameY = 5;
    CGFloat nameW = profileW - nameX * 2;
    CGFloat nameH = 30;
    _nameField = [[UITextField alloc] init];
    _nameField.frame = CGRectMake(nameX, nameY, nameW, nameH);
    _nameField.placeholder = @"name";
    _nameField.tintColor = ProfileColor;
    _nameField.font = [UIFont fontWithName:GothamRoundedBook size:16];
    [profileView addSubview:_nameField];
    
    CGFloat lineN_X = nameX;
    CGFloat lineN_Y = nameY + nameH + 1;
    CGFloat lineN_W = nameW;
    CGFloat lineN_H = kLine_Height;
    UIImageView *lineN_IMG = [[UIImageView alloc] init];
    lineN_IMG.backgroundColor = kLine_Color;
    lineN_IMG.frame = CGRectMake(lineN_X, lineN_Y, lineN_W, lineN_H);
    [profileView addSubview:lineN_IMG];
    
    CGFloat introX = lineN_X;
    CGFloat introY = lineN_Y+ 10;
    CGFloat introW = nameW;
    CGFloat introH = nameH;
    _introField = [[UITextField alloc] init];
    _introField.frame = CGRectMake(introX, introY, introW, introH);
    _introField.placeholder = @"wath's up";
    _introField.tintColor = ProfileColor;
    _introField.font = [UIFont fontWithName:GothamRoundedBook size:16];
    [profileView addSubview:_introField];
    
    CGFloat lineI_X = nameX;
    CGFloat lineI_Y = introY + introH + 1;
    CGFloat lineI_W = nameW;
    CGFloat lineI_H = kLine_Height;
    UIImageView *lineI_IMG = [[UIImageView alloc] init];
    lineI_IMG.backgroundColor = kLine_Color;
    lineI_IMG.frame = CGRectMake(lineI_X, lineI_Y, lineI_W, lineI_H);
    [profileView addSubview:lineI_IMG];
}

- (void)sendUpdateProfileRequest
{
    if ([_nameField.text length] == 0) {
        [self showHudWith:@"please enter the name"];
        return;
    }
    NSString *userName = _nameField.text;
    NSString *label = _introField.text;
    [HttpTool sendRequestUpdateProfileUserName:userName Label:label Gender:nil success:^(id json) {
        ResponseManagerModel *res = [[ResponseManagerModel alloc] initWithString:json error:nil];
        
        if (res.RETURN_CODE == 200) {
            [self showHudWith:@"修改成功"];
            CurrentUserInfo *userInfor = [[UserInfoManager sharedInstance] getCurrentUserInfo];
            userInfor.userIntro = _introField.text;
            [[UserInfoManager sharedInstance] saveUserInfoToDisk:userInfor];
        }else
            [self showHudWith:ErrorRequestText];
    } faliure:^(NSError *error) {
        [self showHudWith:ErrorText];
    }];
}

- (void)showHudWith:(NSString *)text
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showTextHUDAddedTo:self.view withText:text animated:YES];
}
@end
