//
//  UserInforCell.m
//  Hive
//
//  Created by 那宝军 on 15/4/18.
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
        cell = [[UserInforCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.lineIMG = [[UIImageView alloc] init];
        self.lineIMG.backgroundColor = [UIColorUtil colorWithHexString:@"#cdcdd1"];
        [self.contentView addSubview:self.lineIMG];
        self.lineIMG.frame = CGRectMake(16, [UserInforCell getUserInforCellHeight] - 1, UIWIDTH - 16, 1);
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

+ (CGFloat)getUserInforCellHeight
{
    return 107/2;
}

@end
