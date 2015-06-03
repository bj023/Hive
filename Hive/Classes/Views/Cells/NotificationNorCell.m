//
//  NotificationNorCell.m
//  Hive
//
//  Created by BaoJun on 15/3/31.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "NotificationNorCell.h"
#import "Utils.h"

@interface NotificationNorCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *intrLabel;
@property (strong, nonatomic) UIImageView *lineIMG;
@property (strong, nonatomic) UISwitch *notificationSwitch;
@end

@implementation NotificationNorCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"notificationNorCell";
    NotificationNorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NotificationNorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
            self.selectionStyle  = UITableViewCellSelectionStyleNone;
            self.backgroundColor = [UIColor whiteColor];
            self.accessoryType = UITableViewCellAccessoryNone;

            CGFloat titleX = 16;
            CGFloat titleY = 9;
            CGFloat titleW = 200;
            CGFloat titleH = 20;
            if (!self.titleLabel) {
                self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
                self.titleLabel.font = SettingsFont;
                self.titleLabel.textColor = [UIColor blackColor];
                self.titleLabel.backgroundColor = [UIColor clearColor];
                [self.contentView addSubview:self.titleLabel];
            }
            
            
            CGFloat introX = titleX;
            CGFloat introY = titleY + titleH;
            CGFloat introW = titleW;
            CGFloat introH = titleH;
            if (!self.intrLabel) {
                self.intrLabel = [[UILabel alloc] initWithFrame:CGRectMake(introX, introY, introW, introH)];
                self.intrLabel.font = [UIFont systemFontOfSize:12];
                self.intrLabel.textColor = [UIColorUtil colorWithHexString:@"#B3B3B3"];
                self.intrLabel.textAlignment = NSTextAlignmentLeft;
                self.intrLabel.backgroundColor = [UIColor clearColor];
                [self.contentView addSubview:self.intrLabel];
            }
            
            if (!self.notificationSwitch) {
                self.notificationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(UIWIDTH - 65, [NotificationNorCell getNotificationCellHeight]/2 - 15, 40, 30)];
                self.notificationSwitch.onTintColor = [UIColorUtil colorWithHexString:@"#64baff"];
                [self.contentView addSubview:self.notificationSwitch];
                [self.notificationSwitch addTarget:self action:@selector(switchChangeValue:) forControlEvents:UIControlEventValueChanged];
            }
            
            self.lineIMG = [[UIImageView alloc] init];
            self.lineIMG.backgroundColor = kLine_Color;
            [self.contentView addSubview:self.lineIMG];
            self.lineIMG.frame = CGRectMake(16, [NotificationNorCell getNotificationCellHeight] - kLine_Height, UIWIDTH - 16, kLine_Height);
        }
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

- (void)switchChangeValue:(UISwitch *)mswitch
{
    if (self.indexPath.row == 1) {
        self.intrLabel.text = @"Show name and message";
    }else
        self.intrLabel.text = mswitch.on?@"On":@"Off";

    
    self.block(self.indexPath);
}

- (void)setCellDate:(NSString *)title Detail:(NSString *)detail AccessView:(BOOL)flag
{
    self.titleLabel.text = title;
    self.intrLabel.text = detail;
    
    
    if (self.indexPath.row == 4) {
        
        BOOL hiding = [NSDataUtil valueHiding];
        
        self.notificationSwitch.on = hiding;
        self.intrLabel.text = hiding?@"on":@"Off";
        
    }else if(self.indexPath.row == 1){
        self.notificationSwitch.on = YES;
        self.intrLabel.text = @"Show name and message";
    }else{
        self.notificationSwitch.on = YES;
        self.intrLabel.text = @"On";
    }

}

- (void)dealloc
{
    self.titleLabel = nil;
    self.intrLabel = nil;
    self.lineIMG = nil;
    self.notificationSwitch = nil;
}

+ (CGFloat)getNotificationCellHeight
{
    return 107/2;
}

@end
