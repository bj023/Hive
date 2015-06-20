//
//  ForgetFirstView.m
//  Hive
//
//  Created by 那宝军 on 15/6/15.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ForgetFirstView.h"
#import "Utils.h"

@interface ForgetFirstView ()<UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *phoneNumLineIMG;

@end


@implementation ForgetFirstView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initFirstView];
        //[self hiddenNavBackBtn:YES];
    }
    
    return self;
}

- (void)initFirstView
{
    CGFloat x = 0 ;
    CGFloat y = 182/2;
    CGFloat w = UIWIDTH;
    CGFloat h = 40;
    UILabel *alertLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    alertLab.text = @"Enter your mobile";
    alertLab.textAlignment = NSTextAlignmentCenter;
    alertLab.font = [UIFont fontWithName:GothamRoundedBold size:34/2];
    alertLab.textColor = [UIColorUtil colorWithHexString:@"#424242"];
    [self addSubview:alertLab];
    
    CGFloat phoneNumX = 117/2;
    CGFloat phoneNumY = 375/2;
    CGFloat phoneNumW = UIWIDTH - phoneNumX - 121/2;
    CGFloat phoneNumH = 30;
    self.phoneNumText                    = [[UITextField alloc] initWithFrame:CGRectMake(phoneNumX,phoneNumY, phoneNumW, phoneNumH)];
    self.phoneNumText.font               = [UIFont fontWithName:Font_Helvetica size:18];
    self.phoneNumText.delegate           = self;
    self.phoneNumText.textColor          = kRegisterTextColor;
    self.phoneNumText.tintColor          = kRegisterTextTintColor;
    self.phoneNumText.keyboardType       = UIKeyboardTypeNumberPad;
    self.phoneNumText.returnKeyType      = UIReturnKeyNext;
    self.phoneNumText.textAlignment = NSTextAlignmentCenter;

    [self addSubview:self.phoneNumText];
    
    
    CGFloat phoneIMG_Y = phoneNumY + phoneNumH ;
    self.phoneNumLineIMG     = [[UIImageView alloc] initWithFrame:CGRectMake(phoneNumX, phoneIMG_Y, phoneNumW, 1)];
    self.phoneNumLineIMG.backgroundColor = kRegisterLineColor;
    [self addSubview:self.phoneNumLineIMG];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location > 10)
        return NO;
    return YES;
}
#pragma -mark 弹出键盘
- (void)become_FirstResponder
{
    [self.phoneNumText becomeFirstResponder];
}

#pragma -mark 导航按钮事件
- (void)navBackAction:(UIButton *)sender
{
    [super navBackAction:sender];
    self.block(@"Back");
}

- (void)navNextAction:(UIButton *)sender
{
    if (IsEmpty(self.phoneNumText.text)) {
        [MBProgressHUD showTextHUDAddedTo:self withText:@"Please enter your phone number" animated:YES];
        return;
    }
    [super navNextAction:sender];
    self.block(@"Next");
}

- (void)dealloc
{
    self.phoneNumLineIMG = nil;
    self.phoneNumText = nil;
}

@end
