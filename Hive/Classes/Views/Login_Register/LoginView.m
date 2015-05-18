//
//  LoginView.m
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "LoginView.h"
#import "Utils.h"
#import "LoginToolView.h"

@interface LoginView ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *userNameText;
@property (strong, nonatomic) UITextField *passwordText;

@property (strong, nonatomic) UIImageView *line1IMG;// email 底线
@property (strong, nonatomic) UIImageView *line2IMG;// password 底线

@property (strong, nonatomic) UILabel *titleLabel; // 标题
@property (strong, nonatomic) UIButton *forgetBtn;// 忘记密码
@property (strong, nonatomic) LoginToolView *toolView;// 登陆底部工具栏
@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTopView];
        [self initView];
        [self addKeyboardNotification];
        [self setNavNextBtnTitle:@"Sign in"];
    }
    return self;
}

- (void)initTopView
{
    CGFloat titleY = 80;
    CGFloat titleW = 60;
    CGFloat titleH = 60;
    CGFloat titleX = UIWIDTH/2 - titleW/2;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
    self.titleLabel.text = @"Hive";
    self.titleLabel.font = [UIFont fontWithName:Font_Medium size:20];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.layer.cornerRadius = titleW/2;
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
}

//- (void)initLoginBtn
//{
//
//    CGFloat loginBtnX = UIWIDTH - 90;
//    CGFloat loginBtnY = 0;
//    CGFloat loginBtnW = 80;
//    CGFloat loginBtnH = 44;
//    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.loginBtn.frame = CGRectMake(loginBtnX, loginBtnY, loginBtnW, loginBtnH);
//    [self.loginBtn setTitle:@"Loin in" forState:UIControlStateNormal];
//    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.loginBtn.titleLabel.font = [UIFont fontWithName:Font_Medium size:20];
//    [self addSubview:self.loginBtn];
//    
//    [self.loginBtn addTarget:self action:@selector(clickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
//}

- (void)initView
{    
    CGFloat userNameX = 20;
    CGFloat userNameY = UIHEIGHT/2 - 100 + 14;
    CGFloat userNameW = UIWIDTH - 40;
    CGFloat userNameH = 30;
    self.userNameText = [[UITextField alloc] initWithFrame:CGRectMake(userNameX,userNameY, userNameW , userNameH)];

    CGFloat passwordX = userNameX;
    CGFloat passwordY = userNameY + userNameH + 14;
    CGFloat passwordW = userNameW;
    CGFloat passwordH = userNameH;
    self.passwordText = [[UITextField alloc] initWithFrame:CGRectMake( passwordX, passwordY,  passwordW, passwordH)];
    
    CGFloat lineIMG_X = userNameX;
    CGFloat lineIMG_Y = userNameY + userNameH;
    CGFloat lineIMG_W = userNameW;
    CGFloat lineIMG_H = 1;
    self.line1IMG     = [[UIImageView alloc] initWithFrame:CGRectMake(lineIMG_X, lineIMG_Y, lineIMG_W, lineIMG_H)];
    
    lineIMG_Y = passwordY + passwordH + lineIMG_H;
    self.line2IMG     = [[UIImageView alloc] initWithFrame:CGRectMake(lineIMG_X, lineIMG_Y, lineIMG_W, 1)];
    
    
    [self.line1IMG setBackgroundColor:[UIColorUtil colorWithCodea0a0a0]];
    [self.line2IMG setBackgroundColor:[UIColorUtil colorWithCodea0a0a0]];

    
    [self.userNameText setTextColor:[UIColor whiteColor]];
    [self.passwordText setTextColor:[UIColor whiteColor]];
    
    [self.userNameText setTintColor:[UIColor whiteColor]];
    [self.passwordText setTintColor:[UIColor whiteColor]];
    
    UIColor *color = [UIColorUtil colorWithCodea0a0a0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:TextFont, NSFontAttributeName,
                                color, NSForegroundColorAttributeName, nil];
    
    self.userNameText.font = TextFont;
    self.passwordText.font = TextFont;

    self.userNameText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:attributes];
    self.passwordText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:attributes];
    
    [self addSubview:self.userNameText];
    [self addSubview:self.passwordText];
    [self addSubview:self.line1IMG];
    [self addSubview:self.line2IMG];
    
    [self.userNameText becomeFirstResponder];
    
    [self.userNameText setDelegate:self];
    [self.userNameText setReturnKeyType:UIReturnKeyNext];
    [self.userNameText setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.userNameText setKeyboardType:UIKeyboardTypeEmailAddress];
    
    [self.passwordText setDelegate:self];
    [self.passwordText setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.passwordText setReturnKeyType:UIReturnKeyNext];
    [self.passwordText setSecureTextEntry:YES];
    
    CGFloat forgetX = self.line2IMG.frame.origin.x;
    CGFloat forgetY = self.line2IMG.frame.origin.y + 5;
    CGFloat forgetW = UIWIDTH - 2 *forgetX;
    CGFloat forgetH = 30;
    self.forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forgetBtn.frame = CGRectMake(forgetX, forgetY, forgetW, forgetH);
    [self.forgetBtn setTitle:ForgetString forState:UIControlStateNormal];
    [self.forgetBtn setTitleColor:[UIColorUtil colorWithCodea0a0a0] forState:UIControlStateNormal];
    self.forgetBtn.titleLabel.font = HintFont;
    self.forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:self.forgetBtn];
    
    [self.forgetBtn addTarget:self action:@selector(clickForgetBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.toolView = [[LoginToolView alloc] initWithFrame:CGRectMake(0, UIHEIGHT - 44, UIWIDTH, 44)];
    [self addSubview:self.toolView];
    
    __weak LoginView *weakSelf = self;
    self.toolView.block = ^(NSString *str){
        if ([str isEqualToString:@"Sign up"]) {
            // 注册
            weakSelf.block(@"Sign up");
        }else if([str isEqualToString:@"Terms"]){
            weakSelf.block(@"Terms");
        }
    };
    
    //默认用户名
    //self.userNameText.text = @"15011138860";
    //self.passwordText.text = @"123456";
}

#pragma UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.line1IMG setBackgroundColor:[UIColorUtil colorWithCodea0a0a0]];
    CGRect rect      = self.line1IMG.frame;
    rect.size.height = 1;
    [self.line1IMG setFrame:rect];
    [self.line2IMG setBackgroundColor:[UIColorUtil colorWithCodea0a0a0]];
    CGRect rect2      = self.line2IMG.frame;
    rect2.size.height = 1;
    [self.line2IMG setFrame:rect2];
    
    if(textField == self.passwordText){
        [self.line2IMG setBackgroundColor:[UIColor whiteColor]];
        CGRect rect4      = self.line2IMG.frame;
        rect4.size.height = 1;
        [self.line2IMG setFrame:rect4];
    }else if(textField == self.userNameText){
        [self.line1IMG setBackgroundColor:[UIColor whiteColor]];
        CGRect rect4      = self.line1IMG.frame;
        rect4.size.height = 1;
        [self.line1IMG setFrame:rect4];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userNameText) {
        [self.userNameText resignFirstResponder];
        //[self.passwordText becomeFirstResponder];
    }else if (textField == self.passwordText) {
        //[self login];//登陆
        [self.line2IMG setBackgroundColor:[UIColorUtil colorWithCodea0a0a0]];
        [self.passwordText resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.line1IMG setBackgroundColor:[UIColorUtil colorWithCodea0a0a0]];
    [self.line2IMG setBackgroundColor:[UIColorUtil colorWithCodea0a0a0]];
}

#pragma -mark 弹出键盘
- (void)become_FirstResponder
{
    [self.userNameText becomeFirstResponder];
}

#pragma -mark 按钮事件

- (void)navNextAction:(UIButton *)sender
{
    [super navNextAction:sender];
    self.userName = self.userNameText.text;
    self.password = self.passwordText.text;
    self.block(@"Login");
}

- (void)clickForgetBtn:(UIButton *)sender
{
    self.block(@"Forget");
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

    
    [UIView animateWithDuration:0.5f delay:0.0f options:1 animations:^{
         
         [self.toolView setFrame:CGRectMake(0, UIHEIGHT - 44, UIWIDTH , 44)];
     }completion:nil];
}

- (void)keyboardWill_Show:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    
    [UIView animateWithDuration:0.5f delay:0.0f options:1 animations:^{
         
         [self.toolView setFrame:CGRectMake(0, UIHEIGHT - height - 44, UIWIDTH, 44)];
     } completion:nil];
    
}

- (void)dealloc
{
    self.userName = nil;
    self.userNameText = nil;
    self.line1IMG = nil;
    self.line2IMG = nil;
    self.titleLabel = nil;
    self.forgetBtn = nil;
    self.toolView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
