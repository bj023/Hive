//
//  LoginToolView.m
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "LoginToolView.h"
#import "Utils.h"

@interface LoginToolView ()

@end

@implementation LoginToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initToolView];
    }
    return self;
}


- (void)initToolView
{
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame = CGRectMake(10, 0, 70, self.frame.size.height);
    [signBtn setTitle:@"Sign up" forState:UIControlStateNormal];
    [signBtn setTitleColor:[UIColorUtil colorWithCodea0a0a0] forState:UIControlStateNormal];
    signBtn.titleLabel.font = TextFont;
    [self addSubview:signBtn];
    
    UIButton *termsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    termsBtn.frame = CGRectMake(self.frame.size.width - 70, 0, 60, self.frame.size.height);
    [termsBtn setTitle:@"Terms" forState:UIControlStateNormal];
    [termsBtn setTitleColor:[UIColorUtil colorWithCodea0a0a0] forState:UIControlStateNormal];
    termsBtn.titleLabel.font = TextFont;
    [self addSubview:termsBtn];
    
    [signBtn addTarget:self action:@selector(clickSignBtn:) forControlEvents:UIControlEventTouchUpInside];
    [termsBtn addTarget:self action:@selector(clickTermsBtn:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)clickSignBtn:(UIButton *)sender
{
    self.block(@"Sign up");
}

- (void)clickTermsBtn:(UIButton *)sender
{
    self.block(@"Terms");
}
@end
