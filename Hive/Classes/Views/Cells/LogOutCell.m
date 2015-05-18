//
//  LogOutCell.m
//  Hive
//
//  Created by BaoJun on 15/3/31.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "LogOutCell.h"
#import "Utils.h"

@interface LogOutCell ()
@property (strong, nonatomic) UILabel *titleLabel;
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
        
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColorUtil colorWithHexString:@"#ff5b2f"];
        
        if (!self.titleLabel) {
            
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UIWIDTH, self.frame.size.height)];
            
            self.titleLabel.font = SettingsFont;
            self.titleLabel.textColor = [UIColor whiteColor];
            self.titleLabel.backgroundColor = [UIColor clearColor];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:self.titleLabel];
            self.titleLabel.text = @"Log Out";
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

- (void)dealloc
{
    self.titleLabel = nil;
}

+ (CGFloat)getLogOutCellHeight
{
    return 43;
}

@end
