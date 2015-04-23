//
//  RegisterSecondView.m
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "RegisterSecondView.h"
#import "Utils.h"

@interface RegisterSecondView ()<UITextFieldDelegate>
@property (strong, nonatomic) UILabel *validationText1;
@property (strong, nonatomic) UILabel *validationText2;
@property (strong, nonatomic) UILabel *validationText3;
@property (strong, nonatomic) UILabel *validationText4;

@property (strong, nonatomic) UILabel *introLabel;

@property (strong, nonatomic) UITextField *validationText;
@end

@implementation RegisterSecondView

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
 
    CGFloat textX = 30;
    CGFloat textY = 130;
    CGFloat textW = (UIWIDTH - 30 * 5)/4;
    CGFloat textH = 30;
    
    self.validationText = [[UITextField alloc] initWithFrame:CGRectMake(textX, textY, textW, textH)];
    self.validationText.keyboardAppearance = UIKeyboardAppearanceDark;
    self.validationText.keyboardType = UIKeyboardTypeNumberPad;
    self.validationText.returnKeyType = UIReturnKeyNext;
    self.validationText.hidden = YES;
    self.validationText.delegate = self;
    [self addSubview:self.validationText];
    
    for (int i = 0; i<4; i++) {
        UILabel  *label = [[UILabel alloc] initWithFrame:CGRectMake((textX + textW) * i + textX, textY, textW, textH)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = TextFont;
        [self addSubview:label];
        
        UIImageView *lineIMG = [[UIImageView alloc] initWithFrame:CGRectMake((textX + textW) * i + textX, textY + textH, textW, 1)];
        lineIMG.backgroundColor = [UIColorUtil colorWithCodea0a0a0];
        [self addSubview:lineIMG];
        
        switch (i) {
            case 0:
                self.validationText1 = label;
                break;
            case 1:
                self.validationText2 = label;
                break;
            case 2:
                self.validationText3 = label;
                break;
            case 3:
                self.validationText4 = label;
                break;

            default:
                break;
        }
    }

    CGFloat introX = textX;
    CGFloat introY = textY + textH + 2;
    CGFloat introW = UIWIDTH - 2*introX;
    CGFloat introH = 30;
    self.introLabel = [[UILabel alloc] initWithFrame:CGRectMake(introX, introY, introW, introH)];
    self.introLabel.font = HintFont;
    self.introLabel.textColor = [UIColorUtil colorWithCodea0a0a0];
    self.introLabel.text = EnterCodeString;
    [self addSubview:self.introLabel];
}

#pragma -mark UITextField 代理

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location == 0) {
        self.validationText1.text = string;
    }else if (range.location == 1){
        self.validationText2.text = string;
    }else if (range.location == 2){
        self.validationText3.text = string;
    }else if (range.location == 3){
        self.validationText4.text = string;
    }else
        return NO;
    return YES;
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
    if (IsEmpty(self.validationText1.text) ||
        IsEmpty(self.validationText2.text) ||
        IsEmpty(self.validationText3.text) ||
        IsEmpty(self.validationText4.text))
    {
        [MBProgressHUD showTextHUDAddedTo:self withText:@"Please enter your phone code" animated:YES];
        return;
    }
    
    [super navNextAction:sender];
    self.block(@"Next");
}

- (NSString *)hponeCode
{
    return [NSString stringWithFormat:@"%@%@%@%@",self.validationText1.text,self.validationText2.text,self.validationText3.text,self.validationText4.text];
}

- (void)dealloc
{
    self.validationText = nil;
    self.validationText1 = nil;
    self.validationText2 = nil;
    self.validationText3 = nil;
    self.validationText4 = nil;
    self.introLabel = nil;
}
@end
