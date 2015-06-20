//
//  ForgetThirdView.m
//  Hive
//
//  Created by 那宝军 on 15/6/15.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ForgetThirdView.h"
#import "Utils.h"

@interface ForgetThirdView ()<UITextFieldDelegate>
@property (strong, nonatomic) UIImageView *passwordIMG;
@property (strong, nonatomic) UIImageView *password1IMG;
@end

@implementation ForgetThirdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setNavNextBtnTitle:@"DONE"];
        [self initThirdView];
    }
    return self;
}

- (void)initThirdView
{
    
    CGFloat x = 0 ;
    CGFloat y = 182/2;
    CGFloat w = UIWIDTH;
    CGFloat h = 20;
    UILabel *alertLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    alertLab.text = @"Something really";
    alertLab.textAlignment = NSTextAlignmentCenter;
    alertLab.font = [UIFont fontWithName:GothamRoundedBold size:34/2];
    [self addSubview:alertLab];
    
    y = y+h;
    UILabel *alertLab1 = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    alertLab1.text = @"impotant";
    alertLab1.textAlignment = NSTextAlignmentCenter;
    alertLab1.font = [UIFont fontWithName:GothamRoundedBold size:34/2];
    [self addSubview:alertLab1];
    
    alertLab.textColor = [UIColorUtil colorWithHexString:@"#424242"];
    alertLab1.textColor = [UIColorUtil colorWithHexString:@"#424242"];
    
    
    CGFloat textX = 30;
    CGFloat textY = 375/2;
    CGFloat textW = UIWIDTH - textX*2;;
    CGFloat textH = 30;
    
    CGFloat imgH = 1;
    
    self.passwordText = [[UITextField alloc] initWithFrame:CGRectMake(textX,textY,textW, textH)];
    
    textY = textY + textH + imgH;
    self.passwordIMG = [[UIImageView alloc] initWithFrame:CGRectMake(textX, textY, textW, imgH)];
    
    textY = textY + 14 + imgH;
    self.password1Text = [[UITextField alloc] initWithFrame:CGRectMake(textX,textY,textW, textH)];
    
    textY = textY + textH + imgH;
    self.password1IMG = [[UIImageView alloc] initWithFrame:CGRectMake(textX, textY, textW, imgH)];
    
    
    
    UIColor *color = [UIColorUtil colorWithHexString:@"#DEDEDE"];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:Font_Helvetica size:16], NSFontAttributeName,
                                color, NSForegroundColorAttributeName, nil];
    self.passwordText.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Create Password (8-16)" attributes:attributes];
    self.password1Text.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Repeat Password" attributes:attributes];
    
    self.passwordText.font  = [UIFont fontWithName:Font_Helvetica size:16];
    self.password1Text.font = [UIFont fontWithName:Font_Helvetica size:16];
    
    
    self.passwordText.secureTextEntry  = YES;
    self.password1Text.secureTextEntry = YES;

    self.passwordText.keyboardType  = UIKeyboardTypeDefault;
    self.password1Text.keyboardType = UIKeyboardTypeDefault;
    

    self.passwordText.returnKeyType  = UIReturnKeyNext;
    self.password1Text.returnKeyType = UIReturnKeyNext;
    
    [self.passwordIMG setBackgroundColor:kRegisterLineColor];
    [self.password1IMG setBackgroundColor:kRegisterLineColor];
    
    self.passwordText.tintColor  = kRegisterTextTintColor;
    self.password1Text.tintColor = kRegisterTextTintColor;
    
    self.passwordText.textColor  = kRegisterTextColor;
    self.password1Text.textColor = kRegisterTextColor;
    
    self.passwordText.delegate  = self;
    self.password1Text.delegate = self;
    
    
    [self addSubview:self.passwordText];
    [self addSubview:self.password1Text];
    [self addSubview:self.passwordIMG];
    [self addSubview:self.password1IMG];    
}


#pragma -mark 弹出键盘
- (void)become_FirstResponder
{
    [self.passwordText becomeFirstResponder];
}

#pragma -mark 导航按钮事件
- (void)navBackAction:(UIButton *)sender
{
    [super navBackAction:sender];
    self.block(@"Back");
}

- (void)navNextAction:(UIButton *)sender
{
    if (IsEmpty(self.passwordText.text)){
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
    self.password1IMG = nil;
    self.password1Text = nil;
    self.passwordIMG = nil;
    self.passwordText = nil;
}
@end
