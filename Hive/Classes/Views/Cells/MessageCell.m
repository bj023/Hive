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
#import "MessageModel.h"
#import "UtilDate.h"

@interface MessageCell ()

@property (strong, nonatomic)MessageModel *chatModel;

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
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    CGFloat headW = 114/2;
    CGFloat headH = headW;
    CGFloat headY = [MessageCell getMessageCellHeight]/2 - headW/2;
    if (!self.headIMG) {
        self.headIMG = [[CustomIMGView alloc] initWithFrame:CGRectMake(headX, headY, headW, headH)];
        self.headIMG.layer.cornerRadius = headH/2;
        self.headIMG.clipsToBounds = YES;
        self.headIMG.backgroundColor = [UIColor clearColor];
        self.headIMG.layer.borderWidth = kHeadIMG_Line_Height;
        self.headIMG.layer.borderColor = kHeadIMG_Layer_Color.CGColor;
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
        self.dateLabel.textColor = [UIColorUtil colorWithHexString:@"#B3B3B3"];
    }
    
    CGFloat nameX = headX + headW + padding;
    CGFloat nameH = 20;
    CGFloat nameY = [MessageCell getMessageCellHeight]/2 - nameH/2 - 12;
    CGFloat nameW = timeX - nameX;
    if (!self.userNameLabel) {
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, nameY, nameW, nameH)];
        self.userNameLabel.font = [UIFont fontWithName:Font_Regular size:16];
        self.userNameLabel.textAlignment = NSTextAlignmentLeft;
        self.userNameLabel.textColor = [UIColorUtil colorWithHexString:@"#111111"];
    }
    
    CGFloat messageX = nameX;
    CGFloat messageY = [MessageCell getMessageCellHeight]/2;// 偏移量
    CGFloat messageW = UIWIDTH - headX - headW -2 * padding;
    CGFloat messageH = 20;
    if (!self.messageLabel) {
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageX, messageY, messageW, messageH)];
        self.messageLabel.font = [UIFont fontWithName:Font_Helvetica size:14];
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
        self.messageLabel.textColor = [UIColorUtil colorWithHexString:@"#B3B3B3"];
    }
    
    
    CGFloat readX = UIWIDTH - 40;
    CGFloat readY = [MessageCell getMessageCellHeight] - 40;
    CGFloat readW = 26;
    CGFloat readH = readW;
    if (!self.unreadLabel) {
        self.unreadLabel = [[UILabel alloc] init];
        self.unreadLabel.frame = CGRectMake(readX, readY, readW, readH);
        self.unreadLabel.textAlignment = NSTextAlignmentCenter;
        self.unreadLabel.font = [UIFont systemFontOfSize:31/2];
        self.unreadLabel.backgroundColor = [UIColorUtil colorWithHexString:@"#FF5B2F"];
        self.unreadLabel.textColor = [UIColor whiteColor];
        self.unreadLabel.layer.cornerRadius = readH/2;
        self.unreadLabel.layer.masksToBounds = YES;
    }
    
    
    UIImageView *lineIMG = [[UIImageView alloc] initWithFrame:CGRectMake(headX + headW + padding, [MessageCell getMessageCellHeight] - kLine_Height, UIWIDTH - headX - headW - padding, kLine_Height)];
    lineIMG.backgroundColor = kLine_Color;
    [self addSubview:lineIMG];
    
    [self addSubview:self.headIMG];
    [self addSubview:self.dateLabel];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.messageLabel];
    [self addSubview:self.unreadLabel];

    [self.headIMG addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadIMG:)]];
}

+ (CGFloat)getMessageCellHeight
{
    return 138/2;
}

- (void)set_MessageCellData:(MessageModel *)model
{
    if (!model) {
        return;
    }
    self.chatModel = model;
    self.userNameLabel.text = model.toUserName;

    self.messageLabel.text = model.msg_content;
    
    //[self.headIMG setImageURLStr:User_Head(model.toUserID)];
    
    [self loadUserIconPath:model.toUserID];
    
    NSString *current_time = [UtilDate dateFromString:[UtilDate getCurrentTime] withFormat:DateFormat_MM];
    NSString *publis_time = [UtilDate dateFromString:model.msg_time withFormat:DateFormat_MM];
    // 时间判断
    if ([current_time intValue]>[publis_time intValue]) {
        self.dateLabel.text = [UtilDate dateFromString:model.msg_time withFormat:DateFormat_MM_dd];
    }else{
        current_time = [UtilDate dateFromString:[UtilDate getCurrentTime] withFormat:DateFormat_DD];
        publis_time = [UtilDate dateFromString:model.msg_time withFormat:DateFormat_DD];
        
        if ([current_time intValue]>[publis_time intValue]) {
            self.dateLabel.text = [UtilDate dateFromString:model.msg_time withFormat:DateFormat_MM_dd];
        }else
            self.dateLabel.text = [UtilDate dateFromString:model.msg_time withFormat:DateFormat_HM];
    }
    

    debugLog(@"未读数->%@",_chatModel.unReadCount);
    
    if ([_chatModel.unReadCount isEqualToString:@"0"]) {
        self.unreadLabel.hidden = YES;
    }else{
        self.unreadLabel.hidden = NO;
        if ([_chatModel.unReadCount intValue] > 99) {
            _unreadLabel.text = @"99+";
        }else
            _unreadLabel.text = _chatModel.unReadCount;
    }
    
    debugLog(@"%@",model);
}

- (void)loadUserIconPath:(NSString *)userID
{
    [HttpTool sendRequestProfileWithUserID:userID success:^(id json) {
        ResponseChatUserInforModel *res = [[ResponseChatUserInforModel alloc] initWithString:json error:nil];
        if (res.RETURN_CODE == 200) {

            NearByModel *model = res.RETURN_OBJ;
            [self.headIMG setImageURLStr:model.iconPath];
            
        }

    } faliure:^(NSError *error) {
        
    }];
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
