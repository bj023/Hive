//
//  UserInforCell.m
//  Hive
//
//  Created by mac on 15/4/18.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "UserInforCell.h"
#import "Utils.h"

@interface UserInforCell ()
@property (nonatomic, strong)UIImageView *lineIMG;
@end

@implementation UserInforCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"UserInforCell";
    UserInforCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UserInforCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.lineIMG = [[UIImageView alloc] init];
        self.lineIMG.backgroundColor = kLine_Color;
        [self.contentView addSubview:self.lineIMG];
        //self.lineIMG.frame = CGRectMake(16, [UserInforCell getUserInforCellHeight] - 1, UIWIDTH - 16, 1);
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.lineIMG.frame = CGRectMake(16, self.frame.size.height - kLine_Height, UIWIDTH - 16, kLine_Height);
    
    if ([self.textLabel.text isEqualToString:@"Intro"]) {
        
        self.textLabel.frame = CGRectMake(16, 10, 40, 20);

        self.detailTextLabel.numberOfLines = 0;

        CGFloat detailX = 16;
        CGFloat detailY = self.textLabel.frame.origin.y + self.textLabel.frame.size.height + 5;
        CGFloat detailW = UIWIDTH - detailX *2;
        CGFloat detailH = self.frame.size.height - self.detailTextLabel.frame.origin.y - 10;
        self.detailTextLabel.frame = CGRectMake(detailX, detailY, detailW, detailH);
    }
}

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (CGFloat)getUserInforCellHeight
{
    return 107/2;
}

@end
