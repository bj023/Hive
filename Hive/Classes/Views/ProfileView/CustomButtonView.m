//
//  CustomButtonView.m
//  Hive
//
//  Created by BaoJun on 15/4/2.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "CustomButtonView.h"
#import "Utils.h"

#define kButtonSize 150/2

#define kLeft_Right_Padding 95/2

// 按钮线条颜色
#define kButton_Layout_Line_Color [UIColorUtil colorWithHexString:@"#d2d2d2"]

#define kButton_Select [UIColorUtil colorWithHexString:@"#ff5b2f"] // 红色

@interface CustomButtonView ()
@property (strong, nonatomic)UIButton *followBtn;
@property (strong, nonatomic)UIButton *blockBtn;
@end

@implementation CustomButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initButtonView];
    }
    return self;
}

- (void)initButtonView
{
    /*
    CGFloat padding = 40;
    CGFloat width = (self.frame.size.width - padding * 4 ) / 3;
    UIButton *talkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    talkBtn.frame = CGRectMake(padding, 0, width, width);
    talkBtn.layer.cornerRadius = width/2;
    talkBtn.layer.borderWidth = 1;
    talkBtn.layer.masksToBounds = YES;
    talkBtn.layer.borderColor = [UIColorUtil colorWithHexString:@"#cfcfcf"].CGColor;
    [talkBtn setTitle:@"Talk" forState:UIControlStateNormal];
    [talkBtn setTitleColor:[UIColorUtil colorWithHexString:@"#aeaeae"] forState:UIControlStateNormal];
    [self addSubview:talkBtn];
    
    self.followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.followBtn.frame = CGRectMake(width + padding * 2, 0, width, width);
    self.followBtn.layer.cornerRadius = width/2;
    self.followBtn.layer.borderWidth = 1;
    self.followBtn.layer.masksToBounds = YES;
    self.followBtn.layer.borderColor = [UIColorUtil colorWithHexString:@"#cfcfcf"].CGColor;
    [self.followBtn setTitle:@"Follow" forState:UIControlStateNormal];
    [self.followBtn setTitleColor:[UIColorUtil colorWithHexString:@"#aeaeae"] forState:UIControlStateNormal];
    [self addSubview:self.followBtn];
    
    self.blockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.blockBtn.frame =CGRectMake(width * 2 + padding * 3, 0, width, width);
    self.blockBtn.layer.cornerRadius = width/2;
    self.blockBtn.layer.borderWidth = 1;
    self.blockBtn.layer.masksToBounds = YES;
    self.blockBtn.layer.borderColor = [UIColorUtil colorWithHexString:@"#cfcfcf"].CGColor;
    [self.blockBtn setTitle:@"Block" forState:UIControlStateNormal];
    [self.blockBtn setTitleColor:[UIColorUtil colorWithHexString:@"#aeaeae"] forState:UIControlStateNormal];
    [self addSubview:self.blockBtn];

    [self.blockBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [talkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.followBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    */
    
    //CGFloat padding = UIWIDTH/2 - kButtonSize/2 - kButtonSize - kLeft_Right_Padding;
    
    /*
    CGFloat followH = kButtonSize;//self.frame.size.height;
    CGFloat followW = followH;
    CGFloat followX = UIWIDTH/2 - kButtonSize/2;//self.frame.size.width/2 - followW/2;
    self.followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.followBtn.frame = CGRectMake(followX, 0, followW, followH);
    self.followBtn.layer.cornerRadius = followH/2;
    self.followBtn.layer.borderWidth = 1;
    self.followBtn.layer.masksToBounds = YES;
    self.followBtn.layer.borderColor = kButton_Layout_Line_Color.CGColor;
    [self.followBtn setTitle:@"Follow" forState:UIControlStateNormal];
    [self addSubview:self.followBtn];
    

    CGFloat talkW = followW;
    CGFloat talkH = followH;
    CGFloat talkX = kLeft_Right_Padding;//followX - padding - talkW;
    UIButton *talkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    talkBtn.frame = CGRectMake(talkX, 0, talkW, talkH);
    talkBtn.layer.cornerRadius = talkH/2;
    talkBtn.layer.borderWidth = 1;
    talkBtn.layer.masksToBounds = YES;
    talkBtn.layer.borderColor = kButton_Layout_Line_Color.CGColor;
    [talkBtn setTitle:@"Talk" forState:UIControlStateNormal];
    [self addSubview:talkBtn];
    
    CGFloat blockX = UIWIDTH - kLeft_Right_Padding - kButtonSize;
    CGFloat blockW = followW;
    CGFloat blockH = followH;
    self.blockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.blockBtn.frame =CGRectMake(blockX, 0, blockW, blockH);
    self.blockBtn.layer.cornerRadius = blockH/2;
    self.blockBtn.layer.borderWidth = 1;
    self.blockBtn.layer.masksToBounds = YES;
    self.blockBtn.layer.borderColor = kButton_Layout_Line_Color.CGColor;
    [self.blockBtn setTitle:@"Block" forState:UIControlStateNormal];
    [self addSubview:self.blockBtn];
    
    */
    
    CGFloat x = 74/2;
    CGFloat y = 0;
    CGFloat w = (UIWIDTH - 2 * x)/3 * 5/6;
    CGFloat h = w;
    
    
    CGFloat followH = h;
    CGFloat followW = w;
    CGFloat followX = UIWIDTH/2 - w/2;//self.frame.size.width/2 - followW/2;
    self.followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.followBtn.frame = CGRectMake(followX, y, followW, followH);
    self.followBtn.layer.cornerRadius = followH/2;
    self.followBtn.layer.borderWidth = 1;
    self.followBtn.layer.masksToBounds = YES;
    self.followBtn.layer.borderColor = kButton_Layout_Line_Color.CGColor;
    [self.followBtn setTitle:@"Follow" forState:UIControlStateNormal];
    [self addSubview:self.followBtn];
    
    
    CGFloat talkW = followW;
    CGFloat talkH = followH;
    CGFloat talkX = x;//followX - padding - talkW;
    UIButton *talkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    talkBtn.frame = CGRectMake(talkX, y, talkW, talkH);
    talkBtn.layer.cornerRadius = talkH/2;
    talkBtn.layer.borderWidth = 1;
    talkBtn.layer.masksToBounds = YES;
    talkBtn.layer.borderColor = kButton_Layout_Line_Color.CGColor;
    [talkBtn setTitle:@"Chat" forState:UIControlStateNormal];
    [self addSubview:talkBtn];
    
    CGFloat blockX = UIWIDTH - x - w;
    CGFloat blockW = followW;
    CGFloat blockH = followH;
    self.blockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.blockBtn.frame =CGRectMake(blockX, y, blockW, blockH);
    self.blockBtn.layer.cornerRadius = blockH/2;
    self.blockBtn.layer.borderWidth = 1;
    self.blockBtn.layer.masksToBounds = YES;
    self.blockBtn.layer.borderColor = kButton_Layout_Line_Color.CGColor;
    [self.blockBtn setTitle:@"Block" forState:UIControlStateNormal];
    [self addSubview:self.blockBtn];
    
    
    self.followBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    talkBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.blockBtn.titleLabel.font = [UIFont systemFontOfSize:15];

    [talkBtn setTitleColor:[UIColorUtil colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [talkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.followBtn setTitleColor:[UIColorUtil colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.blockBtn setTitleColor:[UIColorUtil colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self.blockBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    
    [talkBtn setBackgroundImage:[self buttonImageFromColor:[UIColorUtil colorWithHexString:@"#f89e1d"] size:talkBtn.frame.size] forState:UIControlStateHighlighted];
    [self.followBtn setBackgroundImage:[self buttonImageFromColor:kButton_Select size:talkBtn.frame.size] forState:UIControlStateHighlighted];
    [self.blockBtn setBackgroundImage:[self buttonImageFromColor:kButton_Select size:talkBtn.frame.size] forState:UIControlStateHighlighted];

    [talkBtn addTarget:self action:@selector(touchUpTalkInside:) forControlEvents:UIControlEventTouchUpInside];
    [talkBtn addTarget:self action:@selector(touchDown_Talk:) forControlEvents:UIControlEventTouchDown];
    [talkBtn addTarget:self action:@selector(touchDidEnd:) forControlEvents:UIControlEventTouchDragOutside];
    
    [self.followBtn addTarget:self action:@selector(touchUpFollowInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.followBtn addTarget:self action:@selector(touchDown_Red:) forControlEvents:UIControlEventTouchDown];
    [self.followBtn addTarget:self action:@selector(touchDidEnd:) forControlEvents:UIControlEventTouchDragOutside];
    
    [self.blockBtn addTarget:self action:@selector(touchUpBlockInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.blockBtn addTarget:self action:@selector(touchDown_Red:) forControlEvents:UIControlEventTouchDown];
    [self.blockBtn addTarget:self action:@selector(touchDidEnd:) forControlEvents:UIControlEventTouchDragOutside];
}

- (void)touchDidEnd:(UIButton *)sender
{
    sender.layer.borderColor = kButton_Layout_Line_Color.CGColor;
}

- (void)touchDown:(UIButton *)sender
{
    // 关注
    sender.layer.borderColor = [UIColorUtil colorWithHexString:@"#1b2430"].CGColor;
}

- (void)touchDown_Talk:(UIButton *)sender
{
    sender.layer.borderColor = [UIColorUtil colorWithHexString:@"#f89e1d"].CGColor;
}

- (void)touchDown_Red:(UIButton *)sender
{
    // 选择Block 按钮颜色
    sender.layer.borderColor = kButton_Select.CGColor;
}

- (void)touchUpTalkInside:(UIButton *)sender
{
    sender.layer.borderColor = kButton_Layout_Line_Color.CGColor;
    [self clickButtonIndex:0];
}

- (void)touchUpFollowInside:(UIButton *)sender
{
    sender.layer.borderColor = kButton_Layout_Line_Color.CGColor;
    [self clickButtonIndex:1];
}

- (void)touchUpBlockInside:(UIButton *)sender
{
    sender.layer.borderColor = kButton_Layout_Line_Color.CGColor;
    [self clickButtonIndex:2];
}

// 回调
- (void)clickButtonIndex:(NSInteger)theindex
{
    if ([self.delegate respondsToSelector:@selector(clickButtonWithIndex:)]) {
        [self.delegate clickButtonWithIndex:theindex];
    }
}

- (void)set_DataFollow:(int)follow
{
    if (follow == 0) {
        self.followBtn.backgroundColor = [UIColor whiteColor];
        [self.followBtn setTitleColor:[UIColorUtil colorWithHexString:@"a0a0a0"] forState:UIControlStateNormal];
    }else{
        //self.followBtn.backgroundColor = [UIColorUtil colorWithHexString:@"#1b2430"];
        self.followBtn.backgroundColor = kButton_Select;
        [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}


- (void)set_DataBlock:(int)block
{
    if (block == 0) {
        self.blockBtn.backgroundColor = [UIColor whiteColor];
        [self.blockBtn setTitleColor:[UIColorUtil colorWithHexString:@"a0a0a0"] forState:UIControlStateNormal];
    }else{
        self.blockBtn.backgroundColor = kButton_Select;
        [self.blockBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (UIImage *)buttonImageFromColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
