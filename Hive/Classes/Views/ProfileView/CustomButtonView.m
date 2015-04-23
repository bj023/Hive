//
//  CustomButtonView.m
//  Hive
//
//  Created by BaoJun on 15/4/2.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "CustomButtonView.h"
#import "Utils.h"

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
    
    CGFloat padding = 64/2;
    
    CGFloat followH = self.frame.size.height;
    CGFloat followW = followH;
    CGFloat followX = self.frame.size.width/2 - followW/2;
    self.followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.followBtn.frame = CGRectMake(followX, 0, followW, followH);
    self.followBtn.layer.cornerRadius = followH/2;
    self.followBtn.layer.borderWidth = 1;
    self.followBtn.layer.masksToBounds = YES;
    self.followBtn.layer.borderColor = [UIColorUtil colorWithHexString:@"#c9c9c9"].CGColor;
    [self.followBtn setTitle:@"Follow" forState:UIControlStateNormal];
    [self addSubview:self.followBtn];
    

    CGFloat talkW = followW;
    CGFloat talkH = followH;
    CGFloat talkX = followX - padding - talkW;
    UIButton *talkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    talkBtn.frame = CGRectMake(talkX, 0, talkW, talkH);
    talkBtn.layer.cornerRadius = talkH/2;
    talkBtn.layer.borderWidth = 1;
    talkBtn.layer.masksToBounds = YES;
    talkBtn.layer.borderColor = [UIColorUtil colorWithHexString:@"#c9c9c9"].CGColor;
    [talkBtn setTitle:@"Talk" forState:UIControlStateNormal];
    [self addSubview:talkBtn];
    
    CGFloat blockX = followX + followW + padding;
    CGFloat blockW = followW;
    CGFloat blockH = followH;
    self.blockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.blockBtn.frame =CGRectMake(blockX, 0, blockW, blockH);
    self.blockBtn.layer.cornerRadius = blockH/2;
    self.blockBtn.layer.borderWidth = 1;
    self.blockBtn.layer.masksToBounds = YES;
    self.blockBtn.layer.borderColor = [UIColorUtil colorWithHexString:@"#c9c9c9"].CGColor;
    [self.blockBtn setTitle:@"Block" forState:UIControlStateNormal];
    [self addSubview:self.blockBtn];
    
    
    self.followBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    talkBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.blockBtn.titleLabel.font = [UIFont systemFontOfSize:16];

    [talkBtn setTitleColor:[UIColorUtil colorWithHexString:@"#a0a0a0"] forState:UIControlStateNormal];
    [talkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.followBtn setTitleColor:[UIColorUtil colorWithHexString:@"#a0a0a0"] forState:UIControlStateNormal];
    [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.blockBtn setTitleColor:[UIColorUtil colorWithHexString:@"#a0a0a0"] forState:UIControlStateNormal];
    [self.blockBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    
    [talkBtn setBackgroundImage:[self buttonImageFromColor:[UIColorUtil colorWithHexString:@"#f89e1d"] size:talkBtn.frame.size] forState:UIControlStateHighlighted];
    [self.followBtn setBackgroundImage:[self buttonImageFromColor:[UIColorUtil colorWithHexString:@"#1b2430"] size:talkBtn.frame.size] forState:UIControlStateHighlighted];
    [self.blockBtn setBackgroundImage:[self buttonImageFromColor:[UIColor redColor] size:talkBtn.frame.size] forState:UIControlStateHighlighted];

    [talkBtn addTarget:self action:@selector(touchUpTalkInside:) forControlEvents:UIControlEventTouchUpInside];
    [talkBtn addTarget:self action:@selector(touchDown_Talk:) forControlEvents:UIControlEventTouchDown];
    [talkBtn addTarget:self action:@selector(touchDidEnd:) forControlEvents:UIControlEventTouchDragOutside];
    
    [self.followBtn addTarget:self action:@selector(touchUpFollowInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.followBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.followBtn addTarget:self action:@selector(touchDidEnd:) forControlEvents:UIControlEventTouchDragOutside];
    
    [self.blockBtn addTarget:self action:@selector(touchUpBlockInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.blockBtn addTarget:self action:@selector(touchDown_Red:) forControlEvents:UIControlEventTouchDown];
    [self.blockBtn addTarget:self action:@selector(touchDidEnd:) forControlEvents:UIControlEventTouchDragOutside];
}

- (void)touchDidEnd:(UIButton *)sender
{
    sender.layer.borderColor = [UIColorUtil colorWithHexString:@"#c9c9c9"].CGColor;
}

- (void)touchDown:(UIButton *)sender
{
    sender.layer.borderColor = [UIColorUtil colorWithHexString:@"#1b2430"].CGColor;
}

- (void)touchDown_Talk:(UIButton *)sender
{
    sender.layer.borderColor = [UIColorUtil colorWithHexString:@"#f89e1d"].CGColor;
}

- (void)touchDown_Red:(UIButton *)sender
{
    sender.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)touchUpTalkInside:(UIButton *)sender
{
    sender.layer.borderColor = [UIColorUtil colorWithHexString:@"#c9c9c9"].CGColor;
    [self clickButtonIndex:0];
}

- (void)touchUpFollowInside:(UIButton *)sender
{
    sender.layer.borderColor = [UIColorUtil colorWithHexString:@"#c9c9c9"].CGColor;
    [self clickButtonIndex:1];
}

- (void)touchUpBlockInside:(UIButton *)sender
{
    sender.layer.borderColor = [UIColorUtil colorWithHexString:@"#c9c9c9"].CGColor;
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
        self.followBtn.backgroundColor = [UIColorUtil colorWithHexString:@"#1b2430"];
        [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}


- (void)set_DataBlock:(int)block
{
    if (block == 0) {
        self.blockBtn.backgroundColor = [UIColor whiteColor];
        [self.blockBtn setTitleColor:[UIColorUtil colorWithHexString:@"a0a0a0"] forState:UIControlStateNormal];
    }else{
        self.blockBtn.backgroundColor = [UIColor redColor];
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
