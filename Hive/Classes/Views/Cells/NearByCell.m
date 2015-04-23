//
//  NearByCell.m
//  Hive
//
//  Created by BaoJun on 15/4/2.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "NearByCell.h"
#import "CustomIMGView.h"
#import "Utils.h"

@interface NearByCell ()
@property (strong, nonatomic) CustomIMGView *headIMG;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@end

@implementation NearByCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"NearByCell";
    NearByCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NearByCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initNearByCell];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initNearByCell
{
    /*
    CGFloat headX = 24/2;
    CGFloat headW = 90/2;
    CGFloat headH = headW;
    CGFloat headY = [NearByCell getNearByCellHeight]/2 - headW/2;
    if (!self.headIMG) {
        self.headIMG = [[CustomIMGView alloc] initWithFrame:CGRectMake(headX, headY, headW, headH)];
        self.headIMG.layer.cornerRadius = headH/2;
        self.headIMG.clipsToBounds = YES;
        self.headIMG.backgroundColor = [UIColorUtil colorWithCoded9d9d9];
    }
    
    CGFloat padding = 10;
    CGFloat timeW = UIWIDTH/2 - padding;
    CGFloat timeX = UIWIDTH/2;
    CGFloat timeH = 20;
    CGFloat timeY = 6;
    
    if (!self.timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeX, timeY, timeW, timeH)];
        self.timeLabel.font = [UIFont fontWithName:Font_Light size:12];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.textColor = [UIColorUtil colorWithHexString:@"#8e8e8e"];
    }
    
    CGFloat nameX = headX + headW + padding;
    CGFloat nameH = 20;
    CGFloat nameY = [NearByCell getNearByCellHeight]/2 - nameH/2 - 12;
    CGFloat nameW = timeX - nameX;
    if (!self.userNameLabel) {
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, nameY, nameW, nameH)];
        self.userNameLabel.font = [UIFont fontWithName:Font_Medium size:33/2];
        self.userNameLabel.textAlignment = NSTextAlignmentLeft;
        self.userNameLabel.textColor = [UIColor blackColor];
    }
    
    CGFloat messageX = nameX;
    CGFloat messageY = [NearByCell getNearByCellHeight]/2;// 偏移量
    CGFloat messageW = UIWIDTH - headX - headW -2 * padding;
    CGFloat messageH = 20;
    if (!self.messageLabel) {
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageX, messageY, messageW, messageH)];
        self.messageLabel.font = [UIFont fontWithName:Font_Light size:14];
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
        self.messageLabel.textColor = [UIColorUtil colorWithHexString:@"#8e8e8e"];
    }

    
    UIImageView *lineIMG = [[UIImageView alloc] initWithFrame:CGRectMake(headX + headW + padding, [NearByCell getNearByCellHeight] - 1, UIWIDTH - headX - headW - padding, 1)];
    lineIMG.backgroundColor = [UIColorUtil colorWithCodeefeff4];
    [self addSubview:lineIMG];
    
    [self addSubview:self.headIMG];
    [self addSubview:self.timeLabel];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.messageLabel];
     */
    CGFloat headW = [NearByCell getNearByCellHeight] - 10;
    CGFloat headX = 10;
    CGFloat headH = headW;
    CGFloat headY = headX;
    if (!self.headIMG) {
        self.headIMG = [[CustomIMGView alloc] initWithFrame:CGRectMake(headX, headY, headW, headH)];
        self.headIMG.layer.cornerRadius = headH/2;
        self.headIMG.clipsToBounds = YES;
        self.headIMG.backgroundColor = [UIColorUtil colorWithCoded9d9d9];
    }

    CGFloat padding = 30/2;
    CGFloat nameX = headX + headW + padding;
    CGFloat nameH = 20;
    CGFloat nameY = [NearByCell getNearByCellHeight]/2 - nameH/2;
    CGFloat nameW = UIWIDTH/2 + headW;
    if (!self.userNameLabel) {
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, nameY, nameW, nameH)];
        self.userNameLabel.font = [UIFont fontWithName:Font_Medium size:34/2];
        self.userNameLabel.textAlignment = NSTextAlignmentLeft;
        self.userNameLabel.textColor = [UIColor blackColor];
    }

    CGFloat timeH = 20;
    CGFloat timeW = UIWIDTH/2 - padding;
    CGFloat timeX = UIWIDTH/2;
    CGFloat timeY = [NearByCell getNearByCellHeight]/2 - timeH/2;
    
    if (!self.timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeX, timeY, timeW, timeH)];
        self.timeLabel.font = [UIFont fontWithName:Font_Light size:12];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.textColor = [UIColorUtil colorWithHexString:@"#8e8e8e"];
    }
    
    UIImageView *lineIMG = [[UIImageView alloc] initWithFrame:CGRectMake(nameX, [NearByCell getNearByCellHeight] - 0.5, UIWIDTH - nameX, 0.5)];
    lineIMG.backgroundColor = [UIColorUtil colorWithHexString:@"#cdcdd1"];
    [self addSubview:lineIMG];
    
    [self addSubview:self.headIMG];
    [self addSubview:self.timeLabel];
    [self addSubview:self.userNameLabel];
}

- (void)set_NearByCellData:(NearByModel *)model
{
    self.userNameLabel.text = model.userName;
    /*
    NSString *date = [NSString stringWithFormat:@"%d-%d %d:%d",model.month,model.date,model.hours,model.minutes];
    if ([date isEqualToString:[self stringFromDate:[NSDate date]]]) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@ km | %d:%d",model.distance,model.hours,model.minutes];
    }else
        self.timeLabel.text = [NSString stringWithFormat:@"%@ km | %d-%d",model.distance,model.month,model.date];
    
    */
    
    if (!IsEmpty(model.distance)) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@ km",model.distance];
    }
    
    self.messageLabel.text = model.label;
    [self.headIMG setImageURLStr:model.iconPath];
}


static NSString *DateFormatMDHM = @"MM-dd HH:mm";
/**
 *  日期转换成字符串
 *
 *  @param date 日期
 *
 *  @return 字符串
 */
- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DateFormatMDHM];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}


- (void)dealloc
{
    self.userNameLabel = nil;
    self.messageLabel = nil;
    self.timeLabel = nil;
}

+ (CGFloat)getNearByCellHeight
{
    return 120/2;
}
@end
