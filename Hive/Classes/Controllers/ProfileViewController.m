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
#import "MessageTextView.h"

#define ProfileColor [UIColor colorWithRed:100/255.0 green:186/255.0 blue:255/255.0 alpha:1]

@interface ProfileViewController ()<UITextViewDelegate>
{
    UITextField *_nameField;
    MessageTextView *_introField;
    UIButton *_toolBtn;
    UIImageView *_lineI_IMG;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self configCloseBtn];
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
    //[self addKeyboardNotification];
    CGRect frame = _lineI_IMG.frame;
    CGFloat height = [self getTextViewContentH:_introField];
    frame.origin.y = height + 45;
    _lineI_IMG.frame = frame;
    
    
    frame = _introField.frame;
    frame.size.height = height;
    _introField.frame = frame;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configCloseBtn
{
    /*
    UIColor *color = [UIColor colorWithRed:100/255.0 green:186/255.0 blue:255/255.0 alpha:1];
    FRDLivelyButton *button = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(UIWIDTH - 36 - 10,10,36,28)];
    [button setOptions:@{ kFRDLivelyButtonLineWidth: @(2.0f),
                          kFRDLivelyButtonHighlightedColor:color,
                          kFRDLivelyButtonColor: color
                          }];
    [button setStyle:kFRDLivelyButtonStyleClose animated:YES];
    [button addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
     */
    CGFloat x = UIWIDTH - 80;
    CGFloat y = 0;
    CGFloat w = 70;
    CGFloat h = 44;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(x, y, w, h);
    [button setTitle:@"SAVE" forState:UIControlStateNormal];
    [button setTitleColor:ProfileColor forState:UIControlStateNormal];

    //关闭颜色
    //toolBtn.backgroundColor = ProfileColor;
    button.titleLabel.font = [UIFont fontWithName:GothamRoundedBold size:16];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(clickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
     
}
// 关闭
- (void)closeButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configToolBarView
{
    _toolBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _toolBtn.frame =CGRectMake(0, UIHEIGHT - 50, UIWIDTH, 50);
    [_toolBtn setTitle:@"SAVE" forState:UIControlStateNormal];
    [_toolBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
    //关闭颜色
    [_toolBtn setBackgroundImage:[UIColorUtil createImageWithColor:NormalColor] forState:UIControlStateNormal];
    [_toolBtn setBackgroundImage:[UIColorUtil createImageWithColor:HighlightedColor] forState:UIControlStateHighlighted];
    _toolBtn.titleLabel.font = [UIFont fontWithName:GothamRoundedBold size:18];
    [self.view addSubview:_toolBtn];
    [_toolBtn addTarget:self action:@selector(clickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
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
    CGFloat profileY = UIHEIGHT/2 - 150 + 14;
    CGFloat profileW = UIWIDTH;
    CGFloat profileH = 200;
    UIView * profileView = [[UIView alloc] init];
    profileView.backgroundColor = [UIColor clearColor];
    profileView.frame = CGRectMake(profileX, profileY, profileW, profileH);
    [self.view addSubview:profileView];
    
    CGFloat nameX = 30;
    CGFloat nameY = 5;
    CGFloat nameW = profileW - nameX * 2;
    CGFloat nameH = 30;
    _nameField = [[UITextField alloc] init];
    _nameField.frame = CGRectMake(nameX, nameY, nameW, nameH);
    _nameField.placeholder = @"name";
    _nameField.textColor = kRegisterTextColor;
    _nameField.tintColor = kRegisterTextTintColor;
    _nameField.font = [UIFont fontWithName:Font_Helvetica size:16];
    [profileView addSubview:_nameField];
    
    CGFloat lineN_X = nameX;
    CGFloat lineN_Y = nameY + nameH + 1;
    CGFloat lineN_W = nameW;
    CGFloat lineN_H = 1;
    UIImageView *lineN_IMG = [[UIImageView alloc] init];
    lineN_IMG.backgroundColor = kRegisterLineColor;
    lineN_IMG.frame = CGRectMake(lineN_X, lineN_Y, lineN_W, lineN_H);
    [profileView addSubview:lineN_IMG];
    
    CGFloat introX = lineN_X;
    CGFloat introY = lineN_Y + 14;
    CGFloat introW = nameW;
    CGFloat introH = 200;
    _introField = [[MessageTextView alloc] init];
    _introField.frame = CGRectMake(introX, introY, introW, introH);
    _introField.placeHolder = @"wath's up";
    _introField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _introField.textColor = kRegisterTextColor;
    _introField.tintColor = kRegisterTextTintColor;
    _introField.delegate = self;
    _introField.font = [UIFont fontWithName:Font_Helvetica size:16];
    [profileView addSubview:_introField];
    
    
    CGFloat lineI_X = nameX;
    CGFloat lineI_Y = introY + nameH + 1;
    CGFloat lineI_W = nameW;
    CGFloat lineI_H = 1;
    _lineI_IMG = [[UIImageView alloc] init];
    _lineI_IMG.backgroundColor = kRegisterLineColor;
    _lineI_IMG.frame = CGRectMake(lineI_X, lineI_Y, lineI_W, lineI_H);
    [profileView addSubview:_lineI_IMG];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    CGRect frame = _lineI_IMG.frame;
    CGFloat height = [self getTextViewContentH:textView];
    frame.origin.y = height + 45;
    _lineI_IMG.frame = frame;
    
    frame = _introField.frame;
    frame.size.height = height;
    _introField.frame = frame;
    
    return YES;
}

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    return ceilf([textView sizeThatFits:textView.frame.size].height);
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
            //[self showHudWith:@"save"];
            CurrentUserInfo *userInfor = [[UserInfoManager sharedInstance] getCurrentUserInfo];
            userInfor.userName = _nameField.text;
            userInfor.userIntro = _introField.text;
            
            [[UserInfoManager sharedInstance] saveUserInfoToDisk:userInfor];
            [self showUpdateSuccess];
        }else
            [self showHudWith:ErrorRequestText];
        
        [self performSelector:@selector(closeButtonAction:) withObject:nil afterDelay:1];

    } faliure:^(NSError *error) {
        
        [self showHudWith:ErrorText];
        
        [self performSelector:@selector(closeButtonAction:) withObject:nil afterDelay:1];
    }];
}



- (void)showHudWith:(NSString *)text
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showTextHUDAddedTo:self.view withText:text animated:YES];
}


#pragma -mark 键盘
- (void)addKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWill_Show:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWill_Show:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

-(void)keyboardHide:(NSNotification*)aNotification
{
    //得到屏幕的宽和高
    //    CGRect rect=[[UIScreen mainScreen] bounds];
    //    CGSize size = rect.size;
    //    CGFloat height = size.height;
    //int screenHeight = size.height;
    
    /**/
     [UIView animateWithDuration:0.5f delay:0.0f options:1 animations:^{
     
         _toolBtn.frame =CGRectMake(0, UIHEIGHT - 50, UIWIDTH, 50);
     }completion:nil];
     
}

- (void)keyboardWill_Show:(NSNotification*)notification
{
    /* */
     NSDictionary *userInfo = [notification userInfo];
     NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
     CGRect keyboardRect = [aValue CGRectValue];
     CGFloat height = keyboardRect.size.height;
     
     [UIView animateWithDuration:0.5f delay:0.0f options:1 animations:^{
     
     [_toolBtn setFrame:CGRectMake(0, UIHEIGHT - height - 50, UIWIDTH, 50)];
     } completion:nil];
    
}

@end
