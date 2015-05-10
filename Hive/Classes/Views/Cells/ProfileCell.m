//
//  ProfileCell.m
//  Hive
//
//  Created by BaoJun on 15/3/31.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ProfileCell.h"
#import "Utils.h"

@interface ProfileCell ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *intrLabel;
@property (strong, nonatomic) UIImageView *lineIMG;
@end

@implementation ProfileCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"profileCell";
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType   = UITableViewCellAccessoryDisclosureIndicator;
        
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
        CGFloat introW = UIWIDTH - introX - 16 * 2;
        CGFloat introH = titleH;
        if (!self.intrLabel) {
            self.intrLabel = [[UILabel alloc] initWithFrame:CGRectMake(introX, introY, introW, introH)];
            self.intrLabel.font = [UIFont systemFontOfSize:12];
            self.intrLabel.textColor = [UIColorUtil colorWithHexString:@"#929292"];
            self.intrLabel.textAlignment = NSTextAlignmentLeft;
            self.intrLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:self.intrLabel];
        }
        
        UIImageView *lineIMG = [[UIImageView alloc] init];
        lineIMG.frame = CGRectMake(0, 0,  UIWIDTH - 0, 1);
        lineIMG.backgroundColor = [UIColorUtil colorWithCodeefeff4];
        [self.contentView addSubview:lineIMG];
        
        self.lineIMG = [[UIImageView alloc] init];
        self.lineIMG.backgroundColor = [UIColorUtil colorWithCodeefeff4];
        [self.contentView addSubview:self.lineIMG];
        self.lineIMG.frame = CGRectMake(16, [ProfileCell getProfileCellHeight] - 1, UIWIDTH - 16, 1);
        
    }
    
    return self;
}

- (void)setProfileData:(NSString *)content IndexPath:(NSIndexPath *)indexpath
{
    CurrentUserInfo *userInfor = [[UserInfoManager sharedInstance] getCurrentUserInfo];

    self.titleLabel.text  = userInfor.userName;
    self.intrLabel.text  = content;
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
    self.intrLabel = nil;
    self.lineIMG = nil;
}

+ (CGFloat)getProfileCellHeight
{
    return 107/2;
}
@end
