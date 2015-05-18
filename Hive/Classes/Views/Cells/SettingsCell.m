//
//  SettingsCell.m
//  Hive
//
//  Created by BaoJun on 15/3/26.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "SettingsCell.h"
#import "Utils.h"

@interface SettingsCell ()
@property (strong, nonatomic) UILabel     *titleLabel;
@property (strong, nonatomic) UIImageView *lineIMG;
@end

@implementation SettingsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"settingsCell";
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat titleX = 16;
        CGFloat titleY = 9;
        CGFloat titleW = 200;
        CGFloat titleH = [SettingsCell getSettingsCellHeight] - 10;
        if (!self.titleLabel) {
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
            self.titleLabel.font = SettingsFont;
            self.titleLabel.textColor = [UIColor blackColor];
            self.titleLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:self.titleLabel];
        }
        
        self.lineIMG = [[UIImageView alloc] init];
        self.lineIMG.backgroundColor = [UIColorUtil colorWithCodeefeff4];
        [self.contentView addSubview:self.lineIMG];
        self.lineIMG.frame = CGRectMake(16, [SettingsCell getSettingsCellHeight] - kLine_Height, UIWIDTH - 16, kLine_Height);
        
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

- (void)settingData:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)dealloc
{
    self.titleLabel = nil;
    self.lineIMG = nil;
}

+ (CGFloat)getSettingsCellHeight
{
    return 107/2;
}
@end
