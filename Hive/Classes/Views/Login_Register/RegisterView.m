//
//  RegisterView.m
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "RegisterView.h"
#import "Utils.h"

@interface RegisterView ()<UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *phoneNumLineIMG;
@property (strong, nonatomic) UILabel *phoneNumIntroLabel;

@end

@implementation RegisterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initFirstView];
    }
    
    return self;
}

- (void)initFirstView
{
    CGFloat phoneNumX = 20;
    CGFloat phoneNumY = 130;
    CGFloat phoneNumW = UIWIDTH - 40;
    CGFloat phoneNumH = 30;
    self.phoneNumText                    = [[UITextField alloc] initWithFrame:CGRectMake(phoneNumX,phoneNumY, phoneNumW, phoneNumH)];
    self.phoneNumText.font               = TextFont;
    self.phoneNumText.delegate           = self;
    self.phoneNumText.textColor          = [UIColor whiteColor];
    self.phoneNumText.tintColor          = [UIColor whiteColor];
    self.phoneNumText.keyboardType       = UIKeyboardTypeNumberPad;
    self.phoneNumText.keyboardAppearance = UIKeyboardAppearanceDark;
    self.phoneNumText.returnKeyType      = UIReturnKeyNext;
    UIColor *color = [UIColorUtil colorWithCodea0a0a0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:TextFont, NSFontAttributeName,
                                color, NSForegroundColorAttributeName, nil];
    self.phoneNumText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your phone Number" attributes:attributes];
    [self addSubview:self.phoneNumText];
    
    
    CGFloat phoneIMG_Y = phoneNumY + phoneNumH;
    self.phoneNumLineIMG     = [[UIImageView alloc] initWithFrame:CGRectMake(phoneNumX, phoneIMG_Y, phoneNumW, 1)];
    self.phoneNumLineIMG.backgroundColor = [UIColorUtil colorWithCodea0a0a0];
    [self addSubview:self.phoneNumLineIMG];

    CGFloat introX = self.phoneNumLineIMG.frame.origin.x;
    CGFloat introY = self.phoneNumLineIMG.frame.origin.y + 10;
    CGFloat introW = UIWIDTH - 2 * introX;
    CGFloat introH = 40;
    self.phoneNumIntroLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(introX, introY, introW, introH)];
    self.phoneNumIntroLabel.text            = ValidationCodeStrin;
    self.phoneNumIntroLabel.font            = HintFont;
    self.phoneNumIntroLabel.textColor       = [UIColorUtil colorWithCodea0a0a0];
    self.phoneNumIntroLabel.backgroundColor = [UIColor clearColor];
    self.phoneNumIntroLabel.numberOfLines   = 0;
    [self addSubview:self.phoneNumIntroLabel];
}

#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.phoneNumLineIMG.backgroundColor = [UIColor whiteColor];
    CGRect rect      = self.phoneNumLineIMG.frame;
    rect.size.height = 1;
    [self.phoneNumLineIMG setFrame:rect];
    if(textField == self.phoneNumText){
        [self.phoneNumLineIMG setBackgroundColor:[UIColor whiteColor]];
        CGRect rect1      = self.phoneNumLineIMG.frame;
        rect1.size.height = 1;
        [self.phoneNumLineIMG setFrame:rect1];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.phoneNumLineIMG.backgroundColor = [UIColorUtil colorWithCodea0a0a0];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.phoneNumLineIMG.backgroundColor = [UIColorUtil colorWithCodea0a0a0];
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
    self.phoneNumIntroLabel = nil;
    self.phoneNumLineIMG = nil;
    self.phoneNumText = nil;
}
@end
