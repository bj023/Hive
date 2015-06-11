//
//  Login_View.m
//  Hive
//
//  Created by 那宝军 on 15/6/9.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "Login_View.h"
#import "Utils.h"
#import "GPLoadingButton.h"

#define kHeight (UIHEIGHT-216)/2

#define Color [UIColor colorWithRed:100/255.0 green:186/255.0 blue:255/255.0 alpha:1]

@interface Login_View ()<UITextFieldDelegate>
{
    
    UIView *_contentView;
    
    UIView *_textContentView;
    UITextField *_userNameText;
    UITextField *_passwordText;
    
    UIView *_activityView;// 加载提示
    
    UIView *_alertView;
}

@end

@implementation Login_View

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self addKeyboardNotification];
    }
    
    return self;
}

- (void)initUI
{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    CGFloat x = 45;
    CGFloat w = UIWIDTH - 2 * x;
    CGFloat h = 230;
    CGFloat y = kHeight - h/2;
    
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _contentView.backgroundColor = [UIColor whiteColor];
        //_contentView.layer.cornerRadius = 10;
        _contentView.userInteractionEnabled = YES;
        [self addSubview:_contentView];
    }
    
    if (!_textContentView) {
        _textContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        //_textContentView.backgroundColor = [UIColor whiteColor];
        _textContentView.layer.cornerRadius = 10;
        _textContentView.userInteractionEnabled = YES;
        [_contentView addSubview:_textContentView];
    }
    
    h = 44;
    x = 45/2;
    y = 20;
    w = _contentView.frame.size.width - 2 * x;
    // 输入框背景
    UIImageView *emailIMG = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    emailIMG.backgroundColor = [UIColorUtil colorWithHexString:@"#f2f2f2"];
    emailIMG.userInteractionEnabled = YES;
    //emailIMG.layer.cornerRadius = 5;
    [_textContentView addSubview:emailIMG];
    
    y = 2 * y + h;
    UIImageView *passIMG = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    passIMG.backgroundColor = [UIColorUtil colorWithHexString:@"#f2f2f2"];
    passIMG.userInteractionEnabled = YES;
    //passIMG.layer.cornerRadius = 5;
    [_textContentView addSubview:passIMG];
    
    x = 5;
    y = 0;
    w = w - 2 * x;
    // 输入框
    _userNameText = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
    _userNameText.placeholder = @"Mobile or Email";
    _userNameText.tintColor = kRegisterTextTintColor;
    _userNameText.textColor = kRegisterTextColor;
    [emailIMG addSubview:_userNameText];
    [_userNameText becomeFirstResponder];
    
    _passwordText = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
    _passwordText.placeholder = @"Password";
    _passwordText.tintColor = kRegisterTextTintColor;
    _passwordText.textColor = kRegisterTextColor;
    _passwordText.secureTextEntry = YES;
    [passIMG addSubview:_passwordText];
    
    _userNameText.keyboardType = UIKeyboardTypeEmailAddress;
    _passwordText.keyboardType = UIKeyboardTypeDefault;
    
    _userNameText.returnKeyType = UIReturnKeyNext;
    _passwordText.returnKeyType = UIReturnKeySend;
    
    _userNameText.delegate = self;
    _passwordText.delegate = self;
    
    
    y = passIMG.frame.origin.y + passIMG.frame.size.height + 5;
    h = 20;
    x = passIMG.frame.origin.x;
    w = _textContentView.frame.size.width - 2 * x;
    
    UIButton * forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(x, y, w, h);
    [forgetBtn setTitle:ForgetString forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColorUtil colorWithHexString:@"#B2B2B2"] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont fontWithName:Font_Helvetica size:14];
    forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_textContentView addSubview:forgetBtn];

    // 线
    x = 0;
    y = _contentView.frame.size.height - 44;
    w = _contentView.frame.size.width;
    h = 1;
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    lineLabel.backgroundColor = [UIColorUtil colorWithHexString:@"#F0F0F0"];
    [_textContentView addSubview:lineLabel];
    
    
    /*
    x = _contentView.frame.size.width/2;
    h = 44;
    w = 1;
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    lineLabel1.backgroundColor = [UIColorUtil colorWithHexString:@"#F0F0F0"];
    [_textContentView addSubview:lineLabel1];
    
    // 按钮
    x = 5;
    h = 44;
    y = _contentView.frame.size.height - h;
    w = _contentView.frame.size.width/2 - 2 * x;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(x, y, w, h);
    [leftBtn setTitle:@"Forget?" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_textContentView addSubview:leftBtn];
    
    x = _contentView.frame.size.width/2 + 5;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(x, y, w, h);
    [rightBtn setTitle:@"Login" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_textContentView addSubview:rightBtn];
    
    
    [leftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
     */
    
    h = 44;
    y = _contentView.frame.size.height - h;
    x = 15;
    w = _contentView.frame.size.width - 2 * x;
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(x, y, w, h);
    [loginBtn setTitle:@"Log In" forState:UIControlStateNormal];
    [loginBtn setTitleColor:Color forState:UIControlStateNormal];
    [_textContentView addSubview:loginBtn];
    
    [forgetBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initActivityUI
{
    CGFloat x = 0;
    CGFloat w = _contentView.frame.size.width;
    CGFloat h = _contentView.frame.size.height;
    CGFloat y = 0;
    if (!_activityView) {
        _activityView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        //_activityView.layer.cornerRadius = _contentView.layer.cornerRadius;
        _activityView.backgroundColor = _contentView.backgroundColor;
        [_contentView addSubview:_activityView];
    }
    
    w = 30;
    h = 30;
    x = _contentView.frame.size.width/2 - w/2;
    y = _contentView.frame.size.height/2 - h/2;
    GPLoadingButton * _activityButton = [[GPLoadingButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    _activityButton.rotatorColor = [UIColor orangeColor];
    [_activityButton startActivity];
    [_activityView addSubview:_activityButton];
}

- (CGFloat)heightAlertViewWithTitle:(NSString *)title
{
    CGFloat y = 20;
    CGFloat x = 10;
    CGFloat w = _contentView.frame.size.width - 2 * x;
    
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize textSize = [UILabel sizeWithString:title font:font maxSize:CGSizeMake(w, MAXFLOAT)];
    
    
    _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, y, _contentView.frame.size.width, textSize.height + 44)];
    _alertView.backgroundColor = _contentView.backgroundColor;
    //_alertView.layer.cornerRadius = _contentView.layer.cornerRadius;
    [_contentView addSubview:_alertView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, w, textSize.height)];
    titleLab.text = title;
    titleLab.font = font;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor orangeColor];
    [_alertView addSubview:titleLab];
    
    
    
    return textSize.height + 44 + y;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userNameText) {
        [_passwordText becomeFirstResponder];
    }else if (textField == _passwordText)
        [self endEditing:YES];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if (touch.view != _contentView) {
        [self removeContentView];
    }
}


- (void)show
{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    
    _contentView.center = CGPointMake(UIWIDTH/2, 0);
    _contentView.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    [UIView animateWithDuration:0.35 animations:^{
        _contentView.transform = CGAffineTransformMakeRotation(0);
        _contentView.center = CGPointMake(UIWIDTH/2, kHeight);
    }];
}



- (void)removeContentView
{
    [UIView animateWithDuration:0.35 animations:^{
        //_contentView.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
        _contentView.center = CGPointMake(UIWIDTH/2, UIHEIGHT + 10);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)clickLeftBtn
{
    
}
- (void)clickRightBtn
{
    if (_userNameText.text.length == 0 || _passwordText.text.length == 0) {
        return;
    }
    
    [self endEditing:YES];
    [_textContentView removeFromSuperview];
    [self initActivityUI];
    
    [self sendLoginRequest];
}

- (void)sendLoginRequest
{
    [HttpTool sendRequestWithUserName:_userNameText.text
                             Password:_passwordText.text
                              success:^(id json) {
        
                                  NSError *error = nil;
                                  ResponseLoginModel *res = [[ResponseLoginModel alloc] initWithString:json error:&error];
        
                                  if (res.RETURN_CODE == 200) {

                                      [self handleLoginCenterManager:res.content Password:_passwordText.text];
                                      [self handleSetRootViewController];
                                      
                                      [self removeContentView];
                                  }else{
                                    
                                      [_activityView removeFromSuperview];
                                      
                                      CGFloat height = [self heightAlertViewWithTitle:@"登陆失败"];
                                      [self updateContentHeight:height];
                                  }
                                  
        
                              } faliure:^(NSError *error) {
                                  [_activityView removeFromSuperview];
                                  [_userNameText becomeFirstResponder];
                              }];
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

- (void)updateContentHeight:(CGFloat)height
{
    CGRect frmae = _contentView.frame;
    frmae.origin.y = UIHEIGHT/2 - height/2;
    frmae.size.height = height;
    [UIView animateWithDuration:0.35 animations:^{
        _contentView.frame = frmae;
    }];
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
    
    /*
     [UIView animateWithDuration:0.5f delay:0.0f options:1 animations:^{
     
     [self.toolView setFrame:CGRectMake(0, UIHEIGHT - 44, UIWIDTH , 44)];
     }completion:nil];
     */
    [UIView animateWithDuration:0.35 animations:^{
        _contentView.center = CGPointMake(UIWIDTH/2, UIHEIGHT/2);
    }];
}

- (void)keyboardWill_Show:(NSNotification*)notification
{
    /*
     NSDictionary *userInfo = [notification userInfo];
     NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
     CGRect keyboardRect = [aValue CGRectValue];
     CGFloat height = keyboardRect.size.height;
     
     [UIView animateWithDuration:0.5f delay:0.0f options:1 animations:^{
     
     [self.toolView setFrame:CGRectMake(0, UIHEIGHT - height - 44, UIWIDTH, 44)];
     } completion:nil];
     */
    [UIView animateWithDuration:0.35 animations:^{
        _contentView.center = CGPointMake(UIWIDTH/2, kHeight);
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
