//
//  UserInformationView.m
//  Hive
//
//  Created by BaoJun on 15/4/2.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "UserInformationView.h"
#import "Utils.h"

@interface UserInformationView ()
@property (strong, nonatomic) UILabel *sexLabel;//性别
@property (strong, nonatomic) UILabel *ageLabel;//年龄
@property (strong, nonatomic) UILabel *rangeLabel;//距离
@end

@implementation UserInformationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    
    return self;
}

- (void)initView
{
    /*
    UIFont *font = [UIFont systemFontOfSize:14];
    CGFloat lineH = 12;// 线条的高度
    
    CGFloat width = self.frame.size.width/3;// 文本的宽度
    CGFloat height = self.frame.size.height;// 文本的高度
    if (!self.sexLabel) {
        
        self.sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.sexLabel.font = font;
        self.sexLabel.textAlignment = NSTextAlignmentLeft;
        self.sexLabel.textColor = [UIColor blackColor];
        self.sexLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.sexLabel];
    }
    
    if (!self.ageLabel) {
        self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, 0, width, height)];
        self.ageLabel.font = font;
        self.ageLabel.textAlignment = NSTextAlignmentCenter;
        self.ageLabel.textColor = [UIColor blackColor];
        self.ageLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.ageLabel];
        
        UIImageView *linIMG = [[UIImageView alloc] initWithFrame:CGRectMake(self.ageLabel.frame.origin.x, self.frame.size.height/2 - lineH/2, 1, lineH)];
        linIMG.backgroundColor = [UIColor blackColor];
        [self addSubview:linIMG];
    }
    
    if (!self.rangeLabel) {
        self.rangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * 2, 0, width, height)];
        self.rangeLabel.font = font;
        self.rangeLabel.textAlignment = NSTextAlignmentRight;
        self.rangeLabel.textColor = [UIColor blackColor];
        self.rangeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.rangeLabel];
        
        UIImageView *linIMG = [[UIImageView alloc] initWithFrame:CGRectMake(self.rangeLabel.frame.origin.x, self.frame.size.height/2 - lineH/2, 1, lineH)];
        linIMG.backgroundColor = [UIColor blackColor];
        [self addSubview:linIMG];
    }
    */

    UIFont *font = [UIFont fontWithName:Font_Helvetica size:14];
    CGFloat lineH = 12;// 线条的高度
    
    CGFloat padding = ( 170/2 - 60/2 ) / 2;
    CGFloat ageW = 60;
    CGFloat ageH = self.frame.size.height;// 文本的高度
    CGFloat ageX = self.frame.size.width/2 - ageW/2;
    if (!self.ageLabel) {
        self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(ageX, 0, ageW, ageH)];
        self.ageLabel.font = font;
        self.ageLabel.textAlignment = NSTextAlignmentCenter;
        self.ageLabel.textColor = [UIColor blackColor];
        self.ageLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.ageLabel];
        
        UIImageView *linIMG_L = [[UIImageView alloc] initWithFrame:CGRectMake(ageX - padding, self.frame.size.height/2 - lineH/2, 0.5, lineH)];
        linIMG_L.backgroundColor = [UIColor blackColor];
        [self addSubview:linIMG_L];
        
        UIImageView *linIMG_R = [[UIImageView alloc] initWithFrame:CGRectMake(ageX + ageW + padding, self.frame.size.height/2 - lineH/2, 0.5, lineH)];
        linIMG_R.backgroundColor = [UIColor blackColor];
        [self addSubview:linIMG_R];
    }
    
    CGFloat sexW = 60;
    CGFloat sexX = ageX - 2 * padding - sexW - 5; // 偏移量
    CGFloat sexH = ageH;
    if (!self.sexLabel) {
        self.sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(sexX, 0, sexW, sexH)];
        self.sexLabel.font = font;
        self.sexLabel.textAlignment = NSTextAlignmentRight;
        self.sexLabel.textColor = [UIColor blackColor];
        self.sexLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.sexLabel];
    }
    
    CGFloat rangeX = ageX + ageW + 2 * padding + 5; // 偏移量
    CGFloat rangeW = 80;
    CGFloat rangeH = sexH;
    if (!self.rangeLabel) {
        self.rangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(rangeX, 0, rangeW, rangeH)];
        self.rangeLabel.font = font;
        self.rangeLabel.textAlignment = NSTextAlignmentLeft;
        self.rangeLabel.textColor = [UIColor blackColor];
        self.rangeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.rangeLabel];
    }
}

- (void)set_UserInfoData:(NSString *)sex Age:(NSString *)age Distance:(NSString *)distance
{
    self.sexLabel.text = sex;
    self.ageLabel.text = age;
    self.rangeLabel.text = distance;
}

- (void)dealloc
{
    self.sexLabel = nil;
    self.ageLabel = nil;
    self.rangeLabel = nil;
}
@end
