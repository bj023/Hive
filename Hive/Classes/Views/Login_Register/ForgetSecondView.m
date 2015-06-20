//
//  ForgetSecondView.m
//  Hive
//
//  Created by 那宝军 on 15/6/15.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ForgetSecondView.h"
#import "Utils.h"

@interface ForgetSecondView ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *validationText;
@end

@implementation ForgetSecondView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSecondView];
    }
    return self;
}

- (void)initSecondView
{
    
    CGFloat x = 0 ;
    CGFloat y = 182/2;
    CGFloat w = UIWIDTH;
    CGFloat h = 20;
    UILabel *alertLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    alertLab.text = @"Enter the verification code";
    alertLab.textAlignment = NSTextAlignmentCenter;
    alertLab.font = [UIFont fontWithName:GothamRoundedBold size:34/2];
    [self addSubview:alertLab];
    
    y = y+h;
    UILabel *alertLab1 = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    alertLab1.text = @"we texted you";
    alertLab1.textAlignment = NSTextAlignmentCenter;
    alertLab1.font = [UIFont fontWithName:GothamRoundedBold size:34/2];
    [self addSubview:alertLab1];
    
    alertLab.textColor = [UIColorUtil colorWithHexString:@"#424242"];
    alertLab1.textColor = [UIColorUtil colorWithHexString:@"#424242"];
    
    
    x = 117/2;
    y = 375/2;
    w = UIWIDTH - x - 121/2;
    h = 30;
    self.validationText                     = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
    //self.validationText.keyboardAppearance = UIKeyboardAppearanceDark;
    self.validationText.keyboardType        = UIKeyboardTypeNumberPad;
    self.validationText.returnKeyType       = UIReturnKeyNext;
    self.validationText.delegate            = self;
    self.validationText.textColor           = kRegisterTextColor;
    self.validationText.tintColor           = kRegisterTextTintColor;
    self.validationText.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.validationText];
    
    // 线
    UIImageView *lineIMG = [[UIImageView alloc] initWithFrame:CGRectMake(x, y+h, w, 1)];
    lineIMG.backgroundColor = kRegisterLineColor;
    [self addSubview:lineIMG];
}


#pragma -mark 弹出键盘
- (void)become_FirstResponder
{
    [self.validationText becomeFirstResponder];
}

#pragma -mark 导航按钮事件
- (void)navBackAction:(UIButton *)sender
{
    [super navBackAction:sender];
    self.block(@"Back");
}

- (void)navNextAction:(UIButton *)sender
{
    if (IsEmpty(self.validationText.text))
    {
        [MBProgressHUD showTextHUDAddedTo:self withText:@"Please enter your phone code" animated:YES];
        return;
    }
    
    [super navNextAction:sender];
    self.block(@"Next");
}

- (NSString *)hponeCode
{
    return _validationText.text;
}
@end
