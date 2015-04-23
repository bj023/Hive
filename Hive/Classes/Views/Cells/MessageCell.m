//
//  MessageCell.m
//  Hive
//
//  Created by BaoJun on 15/4/2.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "MessageCell.h"
#import "CustomIMGView.h"
#import "Utils.h"

@interface MessageCell ()
@property (strong, nonatomic)CustomIMGView *headIMG;// 用户头像
@property (strong, nonatomic)UILabel *userNameLabel;// 用户名
@property (strong, nonatomic)UILabel *dateLabel;// 时间
@property (strong, nonatomic)UILabel *messageLabel;// 消息内容
@property (strong, nonatomic)UILabel *unreadLabel;// 未读数
@end

@implementation MessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initMessageCell];
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

#pragma -mark 自定义 Cell
- (void)initMessageCell
{
    CGFloat headX = 24/2;
    CGFloat headW = 90/2;
    CGFloat headH = headW;
    CGFloat headY = [MessageCell getMessageCellHeight]/2 - headW/2;
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
    
    if (!self.dateLabel) {
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeX, timeY, timeW, timeH)];
        self.dateLabel.font = [UIFont fontWithName:Font_Light size:12];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.textColor = [UIColorUtil colorWithHexString:@"#8e8e8e"];
    }
    
    CGFloat nameX = headX + headW + padding;
    CGFloat nameH = 20;
    CGFloat nameY = [MessageCell getMessageCellHeight]/2 - nameH/2 - 12;
    CGFloat nameW = timeX - nameX;
    if (!self.userNameLabel) {
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, nameY, nameW, nameH)];
        self.userNameLabel.font = [UIFont fontWithName:Font_Medium size:33/2];
        self.userNameLabel.textAlignment = NSTextAlignmentLeft;
        self.userNameLabel.textColor = [UIColor blackColor];
    }
    
    CGFloat messageX = nameX;
    CGFloat messageY = [MessageCell getMessageCellHeight]/2;// 偏移量
    CGFloat messageW = UIWIDTH - headX - headW -2 * padding;
    CGFloat messageH = 20;
    if (!self.messageLabel) {
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageX, messageY, messageW, messageH)];
        self.messageLabel.font = [UIFont fontWithName:Font_Light size:14];
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
        self.messageLabel.textColor = [UIColorUtil colorWithHexString:@"#8e8e8e"];
    }
    
    
    UIImageView *lineIMG = [[UIImageView alloc] initWithFrame:CGRectMake(headX + headW + padding, [MessageCell getMessageCellHeight] - 0.5, UIWIDTH - headX - headW - padding, 0.5)];
    lineIMG.backgroundColor = [UIColorUtil colorWithHexString:@"#cdcdd1"];
    [self addSubview:lineIMG];
    
    [self addSubview:self.headIMG];
    [self addSubview:self.dateLabel];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.messageLabel];
    [self.contentView addSubview:self.unreadLabel];

    [self.headIMG addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadIMG:)]];    
}

+ (CGFloat)getMessageCellHeight
{
    return 120/2;
}

- (void)set_MessageCellData
{
    self.unreadLabel.hidden = YES;
    self.userNameLabel.text = @"Tester";
    self.dateLabel.text = @"13:14";
    self.messageLabel.text = @"Message";
    NSString *urlString = @"http://b.hiphotos.baidu.com/image/pic/item/730e0cf3d7ca7bcbdbff9d2ebc096b63f624a82f.jpg";
    [self.headIMG setImageURLStr:urlString];
}

- (void)clickHeadIMG:(id)sender
{
    self.block(self.indexPath);
}

- (void)dealloc
{
    self.headIMG = nil;
    self.userNameLabel = nil;
    self.dateLabel = nil;
    self.messageLabel = nil;
    self.unreadLabel = nil;
}
@end
