//
//  LogOutCell.m
//  Hive
//
//  Created by BaoJun on 15/3/31.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "LogOutCell.h"
#import "Utils.h"
#import "SettingsCell.h"

@interface LogOutCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *iconIMG;
@property (strong, nonatomic) UIImageView *lineIMG;

@end

@implementation LogOutCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"logOutCell";
    LogOutCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LogOutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //self.selectionStyle  = UITableViewCellSelectionStyleNone;
        //self.backgroundColor = [UIColorUtil colorWithHexString:@"#ff5b2f"];
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    CGFloat w = 15;
    CGFloat h = w;
    CGFloat x = 16;
    CGFloat y = [SettingsCell getSettingsCellHeight]/2 - h/2;
    if (!_iconIMG) {
        _iconIMG = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _iconIMG.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_iconIMG];
    }
    
    
    x = x + h + 10;
    y = 0;
    w = UIWIDTH - x;
    h  = [SettingsCell getSettingsCellHeight];
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _titleLabel.font = SettingsFont;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
    }
    
    x = 16;
    y = [SettingsCell getSettingsCellHeight] - kLine_Height;
    w = UIWIDTH - 16;
    h = kLine_Height;
    
    if (!_lineIMG) {
        _lineIMG = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _lineIMG.backgroundColor = kLine_Color;
        [self.contentView addSubview:self.lineIMG];
    }
}

- (void)setIconIMG:(NSString *)iconStr Title:(NSString *)title
{
    _iconIMG.image = [UIImage imageNamed:iconStr];
    _titleLabel.text = title;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    self.titleLabel = nil;
    self.iconIMG = nil;
}

@end
