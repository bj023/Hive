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
        [self hiddenNavBackBtn:YES];
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
    [self addSubview:alertLab];
    
    CGFloat phoneNumX = 117/2;
    CGFloat phoneNumY = 375/2;
    CGFloat phoneNumW = UIWIDTH - phoneNumX - 121/2;
    CGFloat phoneNumH = 30;
    self.phoneNumText                    = [[UITextField alloc] initWithFrame:CGRectMake(phoneNumX,phoneNumY, phoneNumW, phoneNumH)];
    self.phoneNumText.font               = TextFont;
    self.phoneNumText.delegate           = self;
    self.phoneNumText.textColor          = kRegisterTextTintColor;
    self.phoneNumText.tintColor          = kRegisterTextTintColor;
    self.phoneNumText.keyboardType       = UIKeyboardTypeNumberPad;
    //self.phoneNumText.keyboardAppearance = UIKeyboardAppearanceDark;
    self.phoneNumText.returnKeyType      = UIReturnKeyNext;
    self.phoneNumText.textAlignment = NSTextAlignmentCenter;
    //UIColor *color = kRegisterLineColor;
    //NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:TextFont, NSFontAttributeName,  color, NSForegroundColorAttributeName, nil];
    //self.phoneNumText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your phone Number" attributes:attributes];
    [self addSubview:self.phoneNumText];
    
    
    CGFloat phoneIMG_Y = phoneNumY + phoneNumH ;
    self.phoneNumLineIMG     = [[UIImageView alloc] initWithFrame:CGRectMake(phoneNumX, phoneIMG_Y, phoneNumW, 1)];
    self.phoneNumLineIMG.backgroundColor = kRegisterLineColor;
    [self addSubview:self.phoneNumLineIMG];

    CGFloat introX = self.phoneNumLineIMG.frame.origin.x;
    CGFloat introY = self.phoneNumLineIMG.frame.origin.y + 60/2;
    CGFloat introW = UIWIDTH - 2 * introX;
    CGFloat introH = 40;
    self.phoneNumIntroLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(introX, introY, introW, introH)];
    self.phoneNumIntroLabel.text            = ValidationCodeStrin;
    self.phoneNumIntroLabel.font            = HintFont;
    self.phoneNumIntroLabel.textColor       = kRegisterLineColor;
    self.phoneNumIntroLabel.backgroundColor = [UIColor clearColor];
    self.phoneNumIntroLabel.numberOfLines   = 0;
    [self addSubview:self.phoneNumIntroLabel];
}

#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.phoneNumLineIMG.backgroundColor = kRegisterLineColor;
    CGRect rect      = self.phoneNumLineIMG.frame;
    rect.size.height = 1;
    [self.phoneNumLineIMG setFrame:rect];
    /*
    if(textField == self.phoneNumText){
        [self.phoneNumLineIMG setBackgroundColor:[UIColor whiteColor]];
        CGRect rect1      = self.phoneNumLineIMG.frame;
        rect1.size.height = 1;
        [self.pho
     neNumLineIMG setFrame:rect1];
    }
     */
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.phoneNumLineIMG.backgroundColor = kRegisterLineColor;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.phoneNumLineIMG.backgroundColor = kRegisterLineColor;
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
