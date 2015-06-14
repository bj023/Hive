//
//  RegisterFourView.m
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "RegisterFourView.h"
#import "Utils.h"
#import "SexView.h"
#import "CustomActionSheetView.h"

@interface RegisterFourView ()<UITextFieldDelegate, UIActionSheetDelegate>
{
    BOOL _isSelectHeadIMG;
}

@property (strong, nonatomic) UIImageView   *headIMG;
@property (strong, nonatomic) UILabel       *nameLabel;

@property (strong, nonatomic) SexView       *sexView;
@property (strong, nonatomic) UIImageView   *sexIMG;

@property (strong, nonatomic) UITextField   *ageText;
@property (strong, nonatomic) UIImageView   *ageIMG;
@property (strong, nonatomic) CustomActionSheetView *sheet;
@end


@implementation RegisterFourView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self hiddenNavBackBtn:YES];
        [self setNavNextBtnTitle:@"DONE"];
        [self initFourView];
    }
    return self;
}

- (void)initFourView
{
    CGFloat headY = 100;
    CGFloat headW = 170/2;
    CGFloat headH = headW;
    CGFloat headX = UIWIDTH/2 - headW/2;

    UIView *headView            = [[UIView alloc] initWithFrame:CGRectMake(headX, headY, headW, headH)];
    headView.backgroundColor    = [UIColor whiteColor];
    headView.layer.cornerRadius = headW/2;
    headView.clipsToBounds      = YES;
    [self addSubview:headView];
    // 添加点击事件
    [headView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadIMGAction)]];
    
    CGFloat lineW = 5;
    self.headIMG                    = [[UIImageView alloc] initWithFrame:CGRectMake(lineW/2, lineW/2, headW-lineW, headH-lineW)];
    self.headIMG.layer.cornerRadius = (headW-lineW)/2;
    self.headIMG.clipsToBounds      = YES;
    self.headIMG.image              = [UIImage imageNamed:@"profile"];
    [headView addSubview:self.headIMG];
    
    CGFloat nameX = 30;
    CGFloat nameY = headH + headY + 10;
    CGFloat nameW = UIWIDTH - nameX * 2;
    CGFloat nameH = 30;
    self.nameLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(nameX, nameY, nameW, nameH)];
    self.nameLabel.font            = [UIFont fontWithName:GothamRoundedBold size:48/2];
    self.nameLabel.textColor       = [UIColor blackColor];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textAlignment   = NSTextAlignmentCenter;
    self.nameLabel.text            = _nameString;
    [self addSubview:self.nameLabel];
    
    // 性别
    CGFloat sexX = nameX;
    CGFloat sexY = nameY + nameH + 50;
    CGFloat sexW = nameW;
    CGFloat sexH = 60/2;
    self.sexView = [[SexView alloc] initWithFrame:CGRectMake(sexX, sexY, sexW, sexH)];
    [self addSubview:self.sexView];
    
    CGFloat sexImgX = sexX;
    CGFloat sexImgY = sexY + sexH + 15;
    CGFloat sexImgW = sexW;
    CGFloat sexImgH = 1;
    self.sexIMG = [[UIImageView alloc] initWithFrame:CGRectMake(sexImgX, sexImgY, sexImgW, sexImgH)];
    [self.sexIMG setBackgroundColor:kRegisterLineColor];
    [self addSubview:self.sexIMG];
    
    
    CGFloat ageX = sexImgX;
    CGFloat ageY = sexImgY + 14;
    CGFloat ageW = sexImgW;
    CGFloat ageH = 30;
    self.ageText                    = [[UITextField alloc] initWithFrame:CGRectMake(ageX, ageY, ageW, ageH)];
    //self.ageText.keyboardAppearance = UIKeyboardAppearanceDark;
    self.ageText.keyboardType       = UIKeyboardTypeNumberPad;
    self.ageText.returnKeyType      = UIReturnKeyNext;
    self.ageText.textColor          = kRegisterTextColor;
    self.ageText.tintColor          = kRegisterTextTintColor;
    self.ageText.delegate           = self;
    UIColor *color = [UIColorUtil colorWithHexString:@"#DEDEDE"];
    self.ageText.font = [UIFont fontWithName:Font_Helvetica size:18];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:Font_Helvetica size:16], NSFontAttributeName,
                                color, NSForegroundColorAttributeName, nil];
    
    self.ageText.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"How old are you" attributes:attributes];
    [self addSubview:self.ageText];
    
    CGFloat ageImgX = ageX;
    CGFloat ageImgY = ageY + ageH;
    CGFloat ageImgW = ageW;
    CGFloat ageImgH = 1;
    self.ageIMG = [[UIImageView alloc] initWithFrame:CGRectMake(ageImgX, ageImgY, ageImgW, ageImgH)];
    [self.ageIMG setBackgroundColor:kRegisterLineColor];
    [self addSubview:self.ageIMG];
    
    CGFloat x = ageX;
    CGFloat y = ageImgY + 30/2;
    CGFloat w = UIWIDTH - 2*x;
    CGFloat h = 30;
    
    UILabel * introLabel = [[UILabel alloc] init];
    
    UIFont *tetxFont = [UIFont fontWithName:Font_Helvetica size:14];
    CGSize textSize = [UIFontUtil sizeWithString:ValidationCodeStrin font:tetxFont maxSize:CGSizeMake(w, MAXFLOAT)];
    h = textSize.height + 10;

    introLabel.frame = CGRectMake(x, y, w, h);
    introLabel.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;// 字体的行间距
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *introAttributes = @{
                                      NSFontAttributeName : tetxFont,
                                      NSParagraphStyleAttributeName : paragraphStyle,
                                      NSForegroundColorAttributeName : [UIColorUtil colorWithHexString:@"#B2B2B2"]
                                      };
    introLabel.attributedText = [[NSAttributedString alloc] initWithString:RegisterFourString attributes:introAttributes];
    
    [self addSubview:introLabel];
}

#pragma UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    /*
    [self.ageIMG setBackgroundColor:[UIColorUtil colorWithCodea0a0a0]];
    CGRect rect      = self.ageIMG.frame;
    rect.size.height = 1;
    [self.ageIMG setFrame:rect];
    
    if(textField == self.ageText){
        [self.ageIMG setBackgroundColor:[UIColor whiteColor]];
        CGRect rect4      = self.ageIMG.frame;
        rect4.size.height = 1;
        [self.ageIMG setFrame:rect4];
    }
     */
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    /*
    if (textField == self.ageText) {
        //注册
        [self.ageIMG setBackgroundColor:[UIColorUtil colorWithCodea0a0a0]];
        [self.ageText resignFirstResponder];
    }
     */
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //self.ageIMG.backgroundColor = [UIColorUtil colorWithCodea0a0a0];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location > 2)
        return NO;
    return YES;
}

#pragma -mark 弹出键盘
- (void)become_FirstResponder
{
    [self.ageText becomeFirstResponder];
}

- (void)setNameString:(NSString *)nameString
{
    _nameString = nameString;
    self.nameLabel.text = nameString;
}

#pragma -mark 导航按钮事件
- (void)navBackAction:(UIButton *)sender
{
    [super navBackAction:sender];
    self.block(@"Back");
}

- (void)navNextAction:(UIButton *)sender
{
    if (IsEmpty(self.ageText.text)) {
        [MBProgressHUD showTextHUDAddedTo:self withText:@"Please enter your age" animated:YES];
        return;
    }else if (IsEmpty([_sexView getSex])){
        [MBProgressHUD showTextHUDAddedTo:self withText:@"Please select your sex" animated:YES];
        return;

    }else if(!_isSelectHeadIMG){
        [MBProgressHUD showTextHUDAddedTo:self withText:@"Please select your icon" animated:YES];
        return;
    }
    [super navNextAction:sender];
    self.block(@"Next");
}

#pragma -mark 设置头像
- (void)setHeadImgae:(UIImage *)image
{
    _isSelectHeadIMG = YES;
    self.headIMG.image = image;
}

- (NSString *)getSex
{
    return [_sexView getSex];
}

- (NSString *)getAge
{
    return self.ageText.text;
}

- (UIImage *)getImgData
{
    return self.headIMG.image;
}

#pragma -mark 头像点击事件
- (void)clickHeadIMGAction
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Take photo",@"Choose from photos", nil];
    
    [sheet showInView:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
        {
            [self takePhoto];
        }
            break;
        case 1:
        {
            [self choosePhoto];
        }
            break;
        default:
            break;
    }
}
/*
- (void)clickHeadIMGAction
{
    [self endEditing:YES];
    self.sheet = [[CustomActionSheetView alloc] initWithFrame:self.bounds withTitles:@[@"Take photo",@"Choose photo"]];
    [self.sheet showWithBackgroundColor:[UIColor whiteColor]];
    
    __weak RegisterFourView *weakSelf = self;
    self.sheet.clickActionSheetAtIdex = ^(NSInteger index){
        
        if (index == 0) {
           [weakSelf takePhoto];
        }else{
            [weakSelf choosePhoto];
        }
    };
}
 */
- (void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        self.block(@"takePhoto");
    }else{
        debugLog(@"无法使用拍照功能");
    }
}

- (void)choosePhoto
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //[self getImageSourceWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        self.block(@"choosePhoto");
    } else {
        //[self showAlertViewWithInfo:@"无法访问相册"];
        debugLog(@"无法访问相册");
    }
}

- (void)dealloc
{
    self.headIMG = nil;
    self.nameLabel = nil;
    self.sexView = nil;
    self.sexIMG = nil;
    self.ageIMG = nil;
    self.ageText = nil;
    self.sheet = nil;
}
@end
