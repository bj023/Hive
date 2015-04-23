//
//  SexView.m
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "SexView.h"
#import "Utils.h"

@interface SexView ()
@property (strong, nonatomic)UIImageView *leftIMG;
@property (strong, nonatomic)UIImageView *rightIMG;
@property (strong, nonatomic)UILabel *leftLabel;
@property (strong, nonatomic)UILabel *rightLabel;

@property (strong, nonatomic)UIImageView *leftSelectIMG;
@property (strong, nonatomic)UIImageView *rightSelectIMG;
@end

@implementation SexView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
    leftView.backgroundColor = [UIColor clearColor];
    [self addSubview:leftView];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height)];
    rightView.backgroundColor = [UIColor clearColor];
    [self addSubview:rightView];
    
    
    CGFloat leftX = 0;
    CGFloat leftY = 0;
    CGFloat leftW = self.frame.size.height;
    CGFloat leftH = leftW;
    
    self.leftIMG = [self createImageWithFrame:CGRectMake(leftX, leftY, leftW, leftH)];
    [leftView addSubview:self.leftIMG];
    
    leftX = leftW + 10;
    self.leftLabel = [self createLabelWithFrame:CGRectMake(leftX, leftY, leftView.frame.size.width - leftX, leftH)];
    self.leftLabel.text = @"Male";
    self.leftLabel.font = TextFont;
    [leftView addSubview:self.leftLabel];
    
    
    CGFloat rightX = self.frame.size.width/2;
    CGFloat rightY = 0;
    CGFloat rightW = self.frame.size.height;
    CGFloat rightH = rightW;
    
    self.rightIMG = [self createImageWithFrame:CGRectMake(rightX, rightY, rightW, rightH)];
    [self addSubview:self.rightIMG];
    
    rightX = rightW + 10;
    self.rightLabel = [self createLabelWithFrame:CGRectMake(rightX, rightY, rightView.frame.size.width - rightX, rightH)];
    self.rightLabel.text = @"Female";
    self.rightLabel.font = TextFont;
    [rightView addSubview:self.rightLabel];
    
    
    [leftView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftAction:)]];
    [rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRightAction:)]];
    
    
    CGFloat selectX = 1;
    CGFloat selectY = 1;
    CGFloat selectW = leftW - 2;
    CGFloat selectH = leftH - 2;
    
    self.leftSelectIMG = [self createImageWithFrame:CGRectMake(selectX, selectY, selectW, selectH)];
    self.leftSelectIMG.backgroundColor = [UIColorUtil colorWithHexString:@"f89f1d"];
    [self.leftIMG addSubview:self.leftSelectIMG];

    
    self.rightSelectIMG = [self createImageWithFrame:CGRectMake(selectX, selectY, selectW, selectH)];
    self.rightSelectIMG.backgroundColor = [UIColorUtil colorWithHexString:@"f89f1d"];
    [self.rightIMG addSubview:self.rightSelectIMG];
    
    self.leftSelectIMG.hidden = YES;
    self.rightSelectIMG.hidden = YES;
}

- (UIImageView *)createImageWithFrame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.layer.borderColor = [UIColorUtil colorWithCodea0a0a0].CGColor;
    imageView.layer.borderWidth = 1;
    imageView.layer.cornerRadius = frame.size.width/2;
    return imageView;
}

- (UILabel *)createLabelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColorUtil colorWithCodea0a0a0];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18];
    return label;
}

- (void)clickLeftAction:(id)sender
{
    self.leftSelectIMG.hidden = NO;
    self.rightSelectIMG.hidden = YES;
    
    self.leftIMG.layer.borderColor = [UIColor whiteColor].CGColor;
    self.leftLabel.textColor = [UIColor whiteColor];
    
    self.rightIMG.layer.borderColor = [UIColor lightTextColor].CGColor;
    self.rightLabel.textColor = [UIColorUtil colorWithCodea0a0a0];
}

- (void)clickRightAction:(id)sender
{
    self.leftSelectIMG.hidden = YES;
    self.rightSelectIMG.hidden = NO;
    
    self.leftIMG.layer.borderColor = [UIColor lightTextColor].CGColor;
    self.leftLabel.textColor = [UIColorUtil colorWithCodea0a0a0];
    
    self.rightIMG.layer.borderColor = [UIColor whiteColor].CGColor;
    self.rightLabel.textColor = [UIColor whiteColor];
}

- (void)dealloc
{
    self.leftIMG = nil;
    self.leftLabel = nil;
    self.leftSelectIMG = nil;
    self.rightIMG = nil;
    self.rightLabel = nil;
    self.rightSelectIMG = nil;
}

@end
