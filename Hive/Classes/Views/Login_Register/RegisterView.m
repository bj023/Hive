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
    CGFloat introY = self.phoneNumLineIMG.frame.origin.y + 30/2;
    CGFloat introW = UIWIDTH - 2 * introX;
    CGFloat introH = 50;
    
    self.phoneNumIntroLabel                 = [[UILabel alloc] init];
    
    UIFont *tetxFont = [UIFont fontWithName:Font_Helvetica size:14];
    CGSize textSize = [UIFontUtil sizeWithString:ValidationCodeStrin font:tetxFont maxSize:CGSizeMake(introW, MAXFLOAT)];
    introH = textSize.height + 10;
    
    debugLog(@"%lf",introH);
    
    self.phoneNumIntroLabel.frame           = CGRectMake(introX, introY, introW, introH);
    self.phoneNumIntroLabel.backgroundColor = [UIColor clearColor];
    self.phoneNumIntroLabel.numberOfLines   = 0;
//    self.phoneNumIntroLabel.text            = ValidationCodeStrin;
    // 行间距
    
    self.phoneNumIntroLabel.textColor = [UIColorUtil colorWithHexString:@"#B2B2B2"];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:ValidationCodeStrin];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:Font_Bold size:14] range:NSMakeRange(28, 12)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:Font_Bold size:14] range:NSMakeRange([ValidationCodeStrin length] - 14, 14)];
    self.phoneNumIntroLabel.attributedText = str;
    
    /*
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;// 字体的行间距
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{
                                 NSFontAttributeName : tetxFont,
                                 NSParagraphStyleAttributeName : paragraphStyle,
                                 NSForegroundColorAttributeName : [UIColorUtil colorWithHexString:@"#B2B2B2"]
                                 };
    self.phoneNumIntroLabel.attributedText = [[NSAttributedString alloc] initWithString:ValidationCodeStrin attributes:attributes];
    */
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
