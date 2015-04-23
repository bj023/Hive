//
//  CustomActionSheetView.m
//  Hive
//
//  Created by BaoJun on 15/3/30.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "CustomActionSheetView.h"
#import "AppDelegate.h"
#import "Utils.h"

#define Tag_ActionSheet 10000

@interface CustomActionSheetView ()
@property (strong, nonatomic)NSArray *titlesArr;
@property (strong, nonatomic)UIView *actionSheet;
@end

@implementation CustomActionSheetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initActionSheetView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        _titlesArr = titles;
        [self initActionSheetView];
    }
    return self;
}

- (void)initActionSheetView
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    CGRect frame = self.frame;
    frame.origin.x = 8;
    frame.size.width -= 16;
    frame.origin.y = self.frame.size.height;
    frame.size.height = _titlesArr.count * 44;
    self.actionSheet = [[UIView alloc] initWithFrame:frame];
    self.actionSheet.backgroundColor = [UIColor clearColor];
    self.actionSheet.layer.cornerRadius = 5;
    self.actionSheet.clipsToBounds = YES;
    [self addSubview:self.actionSheet];
    
    for (int i = 0; i<self.titlesArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:_titlesArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColorUtil colorWithCodea0a0a0] forState:UIControlStateHighlighted];
        btn.titleLabel.font = ActionSheetFont;
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = CGRectMake(0, 44*i, self.actionSheet.frame.size.width, 44);
        [self.actionSheet addSubview:btn];
        
        if (i < self.titlesArr.count) {
            UIImageView *lineIMG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 * i - 1, self.actionSheet.frame.size.width, 1)];
            lineIMG.backgroundColor = [UIColorUtil colorWithHexString:@"#d8d8d8"];
            [self.actionSheet addSubview:lineIMG];
        }
        
        btn.tag = Tag_ActionSheet + i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.actionSheet.frame;
        frame.origin.y = self.frame.size.height - _titlesArr.count * 44 - 8;
        self.actionSheet.frame = frame;
    }];
}

- (void)showWithBackgroundColor:(UIColor *)color
{
    self.actionSheet.backgroundColor = color;
    [self show];
}

- (void)removeView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.actionSheet.frame;
        frame.origin.y = UIHEIGHT;
        self.actionSheet.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeView];
}

- (void)clickBtn:(UIButton *)sender
{
    self.clickActionSheetAtIdex(sender.tag - Tag_ActionSheet);
    [self removeView];
}

- (void)dealloc
{
    self.titlesArr = nil;
    self.actionSheet = nil;
}
@end
