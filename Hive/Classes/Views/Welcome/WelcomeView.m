//
//  WelcomeView.m
//  Hive
//
//  Created by mac on 15/5/11.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "WelcomeView.h"
#import "Utils.h"

@interface WelcomeView ()
@property (strong, nonatomic)UIView *welComeView;
@end

@implementation WelcomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];

    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    CGFloat welW = 560/2;
    CGFloat welH = welW;
    CGFloat welX = UIWIDTH/2 - welW/2;
    CGFloat welY = UIHEIGHT/2 - welH/2;
    _welComeView = [[UIView alloc] initWithFrame:CGRectMake(welX, welY , welW, welH)];
    _welComeView.backgroundColor = [UIColor whiteColor];
    _welComeView.layer.cornerRadius = 6;
    _welComeView.layer.masksToBounds = YES;
    [self addSubview:_welComeView];
    
    CGFloat padding = 5;
    // 图片
    
    CGFloat welImgW = 273/2;
    CGFloat welImgH = 233/2;
    CGFloat welImgX = welW/2 - welImgW/2;
    CGFloat welImgY = 35/2;
    UIImageView *mwelImg = [[UIImageView alloc] initWithFrame:CGRectMake(welImgX, welImgY, welImgW, welImgH)];
    mwelImg.image = [UIImage imageNamed:@"wel_logo"];
    [_welComeView addSubview:mwelImg];
    // welcome
    CGFloat welLabelX = 0;
    CGFloat welLabelY = welImgY + welImgH + padding + 10/2;
    CGFloat welLabelW = welW;
    CGFloat welLabelH = 20;
    UILabel *mwelLabel = [[UILabel alloc] initWithFrame:CGRectMake(welLabelX, welLabelY, welLabelW, welLabelH)];
    mwelLabel.font = [UIFont fontWithName:GothamRoundedBold size:28/2];
    mwelLabel.textColor = [UIColor blackColor];
    mwelLabel.textAlignment = NSTextAlignmentCenter;
    mwelLabel.text = @"WELCOME";
    [_welComeView addSubview:mwelLabel];
    // 介绍
    CGFloat introX = 55/2;
    CGFloat introY = welLabelY + welLabelH + padding;
    CGFloat introW = welW - introX * 2;
    CGFloat introH = 50;
    UILabel *introLabel = [[UILabel alloc] initWithFrame:CGRectMake(introX, introY, introW, introH)];
    introLabel.numberOfLines = 0;
    NSString *introString = @"Chat with people around you .Make firends and have a good time :)";
    introLabel.textColor = [UIColorUtil colorWithHexString:@"#b7b7b7"];
    introLabel.font = [UIFont fontWithName:Font_Helvetica size:28/2];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:introString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [introString length])];
    introLabel.attributedText = attributedString;
    [_welComeView addSubview:introLabel];
    
    CGRect textFrame = CGRectMake(10, 5, welW - 20, welH - 60);
    UILabel *welLabel = [[UILabel alloc] initWithFrame:textFrame];
    welLabel.font=[UIFont systemFontOfSize:15];
    [_welComeView addSubview:welLabel];
    
    CGFloat btnX = 55/2;
    CGFloat btnH = 74/2;
    CGFloat btnY = _welComeView.frame.size.height - btnH - 15;
    CGFloat btnW = _welComeView.frame.size.width - btnX * 2;
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    okBtn.layer.cornerRadius = 74/4;
    okBtn.layer.masksToBounds = YES;
    okBtn.titleLabel.font = [UIFont fontWithName:GothamRoundedBook size:30/2];
    [okBtn setTitle:@"Fine" forState:UIControlStateNormal];
    okBtn.backgroundColor = [UIColorUtil colorWithHexString:@"#64baff"];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_welComeView addSubview:okBtn];

    [okBtn addTarget:self action:@selector(clickWelcomeBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickWelcomeBtn:(id)sender
{
    [self removeShareView];
}


- (void)showWelCome
{
    
    _welComeView.center = CGPointMake(UIWIDTH/2, 0);
    [UIView animateWithDuration:0.3 animations:^{
        _welComeView.center = CGPointMake(UIWIDTH/2, UIHEIGHT/2);
    }];
}

- (void)removeShareView
{
    [UIView animateWithDuration:0.2 animations:^{
        _welComeView.center = CGPointMake(UIWIDTH/2, UIHEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end