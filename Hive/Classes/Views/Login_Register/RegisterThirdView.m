//
//  RegisterThirdView.m
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "RegisterThirdView.h"
#import "Utils.h"

@interface RegisterThirdView ()<UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *userNameIMG;
@property (strong, nonatomic) UIImageView *emailIMG;
@property (strong, nonatomic) UIImageView *passwordIMG;
@property (strong, nonatomic) UIImageView *password1IMG;

@end

@implementation RegisterThirdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initThirdView];
    }
    return self;
}

- (void)initThirdView
{
    CGFloat textX = 20;
    CGFloat textY = UIWIDTH/2 - 80;
    CGFloat textW = UIWIDTH - 40;
    CGFloat textH = 30;
    
    CGFloat imgH = 1;

    self.userNameText = [[UITextField alloc] initWithFrame:CGRectMake(textX,textY,textW, textH)];
    
    textY = textY + textH + imgH;
    self.userNameIMG = [[UIImageView alloc] initWithFrame:CGRectMake(textX, textY, textW, imgH)];
    
    textY = textY + 14 + imgH;
    self.emailText = [[UITextField alloc] initWithFrame:CGRectMake(textX,textY,textW, textH)];
    
    textY = textY + textH + imgH;
    self.emailIMG = [[UIImageView alloc] initWithFrame:CGRectMake(textX, textY, textW, imgH)];

    
    textY = textY + 14 + imgH;
    self.passwordText = [[UITextField alloc] initWithFrame:CGRectMake(textX,textY,textW, textH)];

    textY = textY + textH + imgH;
    self.passwordIMG = [[UIImageView alloc] initWithFrame:CGRectMake(textX, textY, textW, imgH)];
    
    textY = textY + 14 + imgH;
    self.password1Text = [[UITextField alloc] initWithFrame:CGRectMake(textX,textY,textW, textH)];
    
    textY = textY + textH + imgH;
    self.password1IMG = [[UIImageView alloc] initWithFrame:CGRectMake(textX, textY, textW, imgH)];
    
    UIColor *color = [UIColorUtil colorWithCodea0a0a0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:TextFont, NSFontAttributeName,
                                color, NSForegroundColorAttributeName, nil];

    self.userNameText.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Username" attributes:attributes];
    self.emailText.attributedPlaceholder     = [[NSAttributedString alloc] initWithString:@"Email" attributes:attributes];
    self.passwordText.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Password" attributes:attributes];
    self.password1Text.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm password" attributes:attributes];
    
    self.userNameText.font  = TextFont;
    self.emailText.font     = TextFont;
    self.passwordText.font  = TextFont;
    self.password1Text.font = TextFont;

    
    self.userNameText.tintColor  = [UIColor whiteColor];
    self.emailText.tintColor     = [UIColor whiteColor];
    self.passwordText.tintColor  = [UIColor whiteColor];
    self.password1Text.tintColor = [UIColor whiteColor];

    self.passwordText.secureTextEntry  = YES;
    self.password1Text.secureTextEntry = YES;
    
    self.userNameText.keyboardType  = UIKeyboardTypeDefault;
    self.emailText.keyboardType     = UIKeyboardTypeEmailAddress;
    self.passwordText.keyboardType  = UIKeyboardTypeDefault;
    self.password1Text.keyboardType = UIKeyboardTypeDefault;
    
    self.userNameText.returnKeyType  = UIReturnKeyNext;
    self.emailText.returnKeyType     = UIReturnKeyNext;
    self.passwordText.returnKeyType  = UIReturnKeyNext;
    self.password1Text.returnKeyType = UIReturnKeyNext;
    
    self.userNameText.keyboardAppearance  = UIKeyboardAppearanceDark;
    self.emailText.keyboardAppearance     = UIKeyboardAppearanceDark;
    self.passwordText.keyboardAppearance  = UIKeyboardAppearanceDark;
    self.password1Text.keyboardAppearance = UIKeyboardAppearanceDark;


    [self.userNameIMG setBackgroundColor:[UIColorUtil colorWithCodea0a0a0]];
    [self.emailIMG setBackgroundColor:[UIColorUtil colorWithCodea0a0a0]];
    [self.passwordIMG setBackgroundColor:[UIColorUtil colorWithCodea0a0a0]];
    [self.password1IMG setBackgroundColor:[UIColorUtil colorWithCodea0a0a0]];
    
    self.userNameText.textColor  = [UIColor whiteColor];
    self.emailText.textColor     = [UIColor whiteColor];
    self.passwordText.textColor  = [UIColor whiteColor];
    self.password1Text.textColor = [UIColor whiteColor];
    
    self.userNameText.delegate  = self;
    self.emailText.delegate     = self;
    self.passwordText.delegate  = self;
    self.password1Text.delegate = self;
    
    [self addSubview:self.userNameText];
    [self addSubview:self.emailText];
    [self addSubview:self.passwordText];
    [self addSubview:self.password1Text];
    [self addSubview:self.userNameIMG];
    [self addSubview:self.emailIMG];
    [self addSubview:self.passwordIMG];
    [self addSubview:self.password1IMG];
}

#pragma UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.userNameIMG setBackgroundColor:[UIColorUtil colorWithCodea0a0a0]];
    CGRect rect      = self.userNameIMG.frame;
    rect.size.height = 1;
    [self.userNameIMG setFrame:rect];
    
    [self.emailIMG setBackgroundColor:[UIColorUtil colorWithCodea0a0a0]];
    CGRect rect2      = self.emailIMG.frame;
    rect2.size.height = 1;
    [self.emailIMG setFrame:rect2];
    
    [self.passwordIMG setBackgroundColor:[UIColorUtil colorWithCodea0a0a0]];
    CGRect rect3      = self.passwordIMG.frame;
    rect3.size.height = 1;
    [self.passwordIMG setFrame:rect3];
    
    [self.password1IMG setBackgroundColor:[UIColorUtil colorWithCodea0a0a0]];
    CGRect rect4      = self.password1IMG.frame;
    rect4.size.height = 1;
    [self.password1IMG setFrame:rect4];
    
    if(textField == self.userNameText){
        [self.userNameIMG setBackgroundColor:[UIColor whiteColor]];
        CGRect rect5      = self.userNameIMG.frame;
        rect5.size.height = 1;
        [self.userNameIMG setFrame:rect5];
        
    }else if(textField == self.emailText){
        [self.emailIMG setBackgroundColor:[UIColor whiteColor]];
        CGRect rect5      = self.emailIMG.frame;
        rect5.size.height = 1;
        [self.emailIMG setFrame:rect5];
        
    }else if(textField == self.passwordText){
        [self.passwordIMG setBackgroundColor:[UIColor whiteColor]];
        CGRect rect5      = self.passwordIMG.frame;
        rect5.size.height = 1;
        [self.passwordIMG setFrame:rect5];
        
    }else if(textField == self.password1Text){
        [self.password1IMG setBackgroundColor:[UIColor whiteColor]];
        CGRect rect5      = self.password1IMG.frame;
        rect5.size.height = 1;
        [self.password1IMG setFrame:rect5];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userNameText) {
        [self.userNameText resignFirstResponder];
        [self.emailText becomeFirstResponder];
    }else if (textField == self.emailText) {
        [self.emailText resignFirstResponder];
        [self.passwordText becomeFirstResponder];
    }else if (textField == self.passwordText) {
        [self.passwordText resignFirstResponder];
        [self.password1Text becomeFirstResponder];
    }else if (textField == self.password1Text) {
        //[self.password1Text resignFirstResponder];
        // 该跳转到第四步
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.userNameIMG.backgroundColor = [UIColorUtil colorWithCodea0a0a0];
    self.emailIMG.backgroundColor = [UIColorUtil colorWithCodea0a0a0];
    self.passwordIMG.backgroundColor = [UIColorUtil colorWithCodea0a0a0];
    self.password1IMG.backgroundColor = [UIColorUtil colorWithCodea0a0a0];
}

#pragma -mark 弹出键盘
- (void)become_FirstResponder
{
    [self.userNameText becomeFirstResponder];
}

#pragma -mark 导航按钮事件
- (void)navBackAction:(UIButton *)sender
{
    [super navBackAction:sender];
    self.block(@"Back");
}

- (void)navNextAction:(UIButton *)sender
{
    if (IsEmpty(self.userNameText.text)) {
        [MBProgressHUD showTextHUDAddedTo:self withText:@"Please enter your name" animated:YES];
        return;
    }else if (IsEmpty(self.emailText.text)){
        [MBProgressHUD showTextHUDAddedTo:self withText:@"Please enter your email" animated:YES];
        return;
    }else if (IsEmpty(self.passwordText.text)){
        [MBProgressHUD showTextHUDAddedTo:self withText:@"Please enter your password" animated:YES];
        return;
    }else if (IsEmpty(self.password1Text.text)){
        [MBProgressHUD showTextHUDAddedTo:self withText:@"Please enter your confirm password" animated:YES];
        return;
    }else if (![self.passwordText.text isEqualToString:self.password1Text.text]){
        [MBProgressHUD showTextHUDAddedTo:self withText:@"confirm password" animated:YES];
        return;
    }
    
    [super navNextAction:sender];
    self.block(@"Next");
}

- (void)dealloc
{
    self.userNameIMG = nil;
    self.userNameText = nil;
    self.emailIMG = nil;
    self.emailText = nil;
    self.password1IMG = nil;
    self.password1Text = nil;
    self.passwordIMG = nil;
    self.passwordText = nil;
}
@end
