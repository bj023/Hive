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
#import "ChatModel.h"
#import "UtilDate.h"

@interface MessageCell ()

@property (strong, nonatomic)ChatModel *chatModel;

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
    CGFloat headX = 22/2;
    CGFloat headW = 55;
    CGFloat headH = headW;
    CGFloat headY = [MessageCell getMessageCellHeight]/2 - headW/2;
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
    CGFloat timeY = 6;
    
    if (!self.dateLabel) {
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeX, timeY, timeW, timeH)];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.font = [UIFont systemFontOfSize:12];
        self.dateLabel.textColor = [UIColorUtil colorWithHexString:@"#b7b7b7"];
    }
    
    CGFloat nameX = headX + headW + padding;
    CGFloat nameH = 20;
    CGFloat nameY = [MessageCell getMessageCellHeight]/2 - nameH/2 - 12;
    CGFloat nameW = timeX - nameX;
    if (!self.userNameLabel) {
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, nameY, nameW, nameH)];
        self.userNameLabel.font = [UIFont fontWithName:Font_Regular size:17];
        self.userNameLabel.textAlignment = NSTextAlignmentLeft;
        self.userNameLabel.textColor = [UIColor blackColor];
    }
    
    CGFloat messageX = nameX;
    CGFloat messageY = [MessageCell getMessageCellHeight]/2;// 偏移量
    CGFloat messageW = UIWIDTH - headX - headW -2 * padding;
    CGFloat messageH = 20;
    if (!self.messageLabel) {
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageX, messageY, messageW, messageH)];
        self.messageLabel.font = [UIFont fontWithName:Font_Helvetica size:14];
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
        self.messageLabel.textColor = [UIColorUtil colorWithHexString:@"#b7b7b7"];
    }
    
    
    UIImageView *lineIMG = [[UIImageView alloc] initWithFrame:CGRectMake(headX + headW + padding, [MessageCell getMessageCellHeight] - 1, UIWIDTH - headX - headW - padding, 1)];
    lineIMG.backgroundColor = [UIColorUtil colorWithCodeefeff4];
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
    return 138/2;
}

- (void)set_MessageCellData:(ChatModel *)model
{
    self.chatModel = model;
    self.unreadLabel.hidden = YES;
    self.userNameLabel.text = model.userName;
    //self.dateLabel.text = @"13:14";
    self.messageLabel.text = model.message;
    [self.headIMG setImageURLStr:[NSString stringWithFormat:@"http://115.28.51.196/X_USER_ICON/%@.jpg",model.userID]];
    
    NSString *current_time = [UtilDate dateFromString:[UtilDate getCurrentTime] withFormat:DateFormat_MM];
    NSString *publis_time = [UtilDate dateFromString:model.time withFormat:DateFormat_MM];
    // 时间判断
    if ([current_time intValue]>[publis_time intValue]) {
        self.dateLabel.text = [UtilDate dateFromString:model.time withFormat:DateFormat_MM_dd];
    }else{
        current_time = [UtilDate dateFromString:[UtilDate getCurrentTime] withFormat:DateFormat_DD];
        publis_time = [UtilDate dateFromString:model.time withFormat:DateFormat_DD];
        
        if ([current_time intValue]>[publis_time intValue]) {
            self.dateLabel.text = [UtilDate dateFromString:model.time withFormat:DateFormat_MM_dd];
        }else
            self.dateLabel.text = [UtilDate dateFromString:model.time withFormat:DateFormat_HM];
    }
    
}

- (void)clickHeadIMG:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(tapHeadImgSendAction:)]) {
        [self.delegate tapHeadImgSendAction:self.chatModel];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(cut:)){
        return NO;
    }
    else if(action == @selector(copy:)){
        return NO;
    }
    else if(action == @selector(paste:)){
        return NO;
    }
    else if(action == @selector(select:)){
        return NO;
    }
    else if(action == @selector(selectAll:)){
        return NO;
    }
    else if (action == @selector(delete:)) {
        return YES;
    }
    else
    {
        return [super canPerformAction:action withSender:sender];
    }
}

- (void)delete:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(deleteMessageCellData:)]) {
        [self.delegate deleteMessageCellData:self.indexPath];
    }
}

- (NSString *)getTime:(NSString *)time
{
    
    NSString *d_current = [UtilDate dateFromString:[UtilDate getCurrentTime] withFormat:DateFormat_DD];
    NSString *d_time = [UtilDate dateFromString:time withFormat:DateFormat_DD];
    
    NSString *m_current = [UtilDate dateFromString:[UtilDate getCurrentTime] withFormat:DateFormat_MM];
    NSString *m_time = [UtilDate dateFromString:time withFormat:DateFormat_MM];
    
    if ([d_current intValue]>[d_time intValue] || ([m_current intValue] - [m_time intValue] > 5)) {
        return [UtilDate dateFromString:time withFormat:DateFormat_MM_dd];
    }
    return [UtilDate dateFromString:time withFormat:DateFormat_HM];
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
