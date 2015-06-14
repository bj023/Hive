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
    
    
    y = y + h + 30/2;
    w = UIWIDTH - 2*x;
    h = 50;
    
    self.introLabel = [[UILabel alloc] init];
    
    UIFont *tetxFont = [UIFont fontWithName:Font_Helvetica size:14];
    CGSize textSize = [UIFontUtil sizeWithString:ValidationCodeStrin font:tetxFont maxSize:CGSizeMake(w, MAXFLOAT)];
    h = textSize.height + 10;
    
    self.introLabel.frame = CGRectMake(x, y, w, h);
    self.introLabel.font = tetxFont;
    self.introLabel.numberOfLines = 0;
    
    self.introLabel.textColor = [UIColorUtil colorWithHexString:@"#B2B2B2"];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:EnterCodeString];

    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:Font_Bold size:14] range:NSMakeRange([EnterCodeString length] - 13, 13)];
    self.introLabel.attributedText = str;
    
    /*
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;// 字体的行间距
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{
                                 NSFontAttributeName : tetxFont,
                                 NSParagraphStyleAttributeName : paragraphStyle,
                                 NSForegroundColorAttributeName : [UIColorUtil colorWithHexString:@"#B2B2B2"]
                                 };
    self.introLabel.attributedText = [[NSAttributedString alloc] initWithString:EnterCodeString attributes:attributes];
    */
    [self addSubview:self.introLabel];
    
}

#pragma -mark UITextField 代理

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location < 4) {
        return YES;
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

/*
- (void)initSecondView
{
 
    CGFloat textX = 30;
    CGFloat textY = 130;
    CGFloat textW = (UIWIDTH - 30 * 5)/4;
    CGFloat textH = 30;
    
    self.validationText = [[UITextField alloc] initWithFrame:CGRectMake(textX, textY, textW, textH)];
    //self.validationText.keyboardAppearance = UIKeyboardAppearanceDark;
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
        lineIMG.backgroundColor = kRegisterLineColor;
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
    self.introLabel.textColor = kRegisterLineColor;
    self.introLabel.text = EnterCodeString;
    [self addSubview:self.introLabel];
    
    self.validationText1.userInteractionEnabled = YES;
    self.validationText2.userInteractionEnabled = YES;
    self.validationText3.userInteractionEnabled = YES;
    self.validationText4.userInteractionEnabled = YES;
    [self.validationText1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(become_FirstResponder)]];
    [self.validationText2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(become_FirstResponder)]];

    [self.validationText3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(become_FirstResponder)]];
    [self.validationText4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(become_FirstResponder)]];
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
*/
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
