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
@property (strong, nonatomic) UILabel *introLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *sexLabel;
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
    /* */
    CGFloat headX = 22/2;
    CGFloat headW = 90/2;
    CGFloat headH = headW;
    CGFloat headY = [NearByCell getNearByCellHeight]/2 - headW/2;
    if (!self.headIMG) {
        self.headIMG = [[CustomIMGView alloc] initWithFrame:CGRectMake(headX, headY, headW, headH)];
        self.headIMG.layer.cornerRadius = headH/2;
        self.headIMG.clipsToBounds = YES;
        self.headIMG.backgroundColor = [UIColorUtil colorWithCoded9d9d9];
    }
    
    CGFloat padding = 11;
    CGFloat timeW = UIWIDTH/2 - padding;
    CGFloat timeX = UIWIDTH/2;
    CGFloat timeH = 20;
    //CGFloat timeY = 6;
    CGFloat timeY = [NearByCell getNearByCellHeight]/2 - timeH/2;
    
    if (!self.timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeX, timeY, timeW, timeH)];
        self.timeLabel.font = [UIFont fontWithName:GothamRoundedBook size:12];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.textColor = [UIColorUtil colorWithHexString:@"#b7b7b7"];
    }
    
    CGFloat nameX = headX + headW + padding;
    CGFloat nameH = 20;
    //CGFloat nameY = [NearByCell getNearByCellHeight]/2 - nameH/2 - 12;
    CGFloat nameY = [NearByCell getNearByCellHeight]/2 - nameH/2;
    CGFloat nameW = timeX - nameX;
    if (!self.userNameLabel) {
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, nameY, nameW, nameH)];
        self.userNameLabel.font = [UIFont fontWithName:Font_Regular size:17];
        self.userNameLabel.textAlignment = NSTextAlignmentLeft;
        self.userNameLabel.textColor = [UIColor blackColor];
    }
    
    CGFloat messageX = nameX;
    CGFloat messageY = [NearByCell getNearByCellHeight]/2;// 偏移量
    CGFloat messageW = UIWIDTH - headX - headW - 2 * padding - padding;
    CGFloat messageH = 20;
    if (!self.introLabel) {
        self.introLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageX, messageY, messageW, messageH)];
        self.introLabel.font = [UIFont fontWithName:Font_Helvetica size:14];
        //self.introLabel.font = [UIFont systemFontOfSize:14];;
        self.introLabel.textAlignment = NSTextAlignmentLeft;
        self.introLabel.textColor = [UIColorUtil colorWithHexString:@"#b7b7b7"];
    }
    
    /*
    CGFloat sexW = 10;
    CGFloat sexH = sexW;
    CGFloat sexX = UIWIDTH - 11 - sexW;
    CGFloat sexY = [NearByCell getNearByCellHeight]/2 - sexH/2 + 5;
    if (!self.sexLabel) {
        self.sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(sexX, sexY, sexW, sexH)];
        self.sexLabel.layer.cornerRadius = sexH/2;
        self.sexLabel.layer.masksToBounds = YES;
    }
    */
    UIImageView *lineIMG = [[UIImageView alloc] initWithFrame:CGRectMake(headX + headW + padding, [NearByCell getNearByCellHeight] - kLine_Height, UIWIDTH - headX - headW - padding, kLine_Height)];
    lineIMG.backgroundColor = kLine_Color;
    [self addSubview:lineIMG];
    
    [self addSubview:self.sexLabel];
    [self addSubview:self.headIMG];
    [self addSubview:self.timeLabel];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.introLabel];
    
    
    /*
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
     */
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
    NSString *headUrl = [NSString stringWithFormat:@"%d",model.userId];
    self.introLabel.text = model.label;
    [self.headIMG setImageURLStr:User_Head(headUrl)];

    debugLog(@"model.distance->%@",model.distance);
    //UIColor *sexColor = [model.gender isEqualToString:@"0"]?[UIColorUtil colorWithHexString:@"#64baff"]:[UIColorUtil colorWithHexString:@"#ff5b2f"];
    //self.sexLabel.backgroundColor = sexColor;
}

- (void)set_NearByCellUserData
{
    self.userNameLabel.text = [[UserInfoManager sharedInstance] getCurrentUserInfo].userName;
    NSString *urlString = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
    [self.headIMG setImageURLStr:User_Head(urlString)];
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
    self.introLabel = nil;
    self.timeLabel = nil;
}

+ (CGFloat)getNearByCellHeight
{
    return 109/2;
}
@end
