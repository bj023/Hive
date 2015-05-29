//
//  ChatBaseCell.m
//  Hive
//
//  Created by mac on 15/4/28.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ChatRoomBaseCell.h"
#import "Utils.h"
#import "ChatRoomModel.h"
#import "NSTimeUtil.h"

#define MESSAGE_FONT_SIZE [UIFont systemFontOfSize:16] // 字体

@interface ChatRoomBaseCell ()
{
    ChatTimeView *_timeView;
    CustomIMGView *_headImgaeView;
    ChatBubbleView *_bubbleView;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
}
@end

@implementation ChatRoomBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = YES;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    _timeView = [[ChatTimeView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_timeView];
    
    _headImgaeView = [[CustomIMGView alloc] initWithFrame:CGRectZero];
    _headImgaeView.layer.cornerRadius = HEAD_SIZE/2;
    _headImgaeView.layer.masksToBounds = YES;
    _headImgaeView.userInteractionEnabled = YES;
    _headImgaeView.backgroundColor = [UIColor clearColor];
    _headImgaeView.layer.borderWidth = kHeadIMG_Line_Height;
    _headImgaeView.layer.borderColor = kHeadIMG_Layer_Color.CGColor;
    [self.contentView addSubview:_headImgaeView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.textColor = [UIColorUtil colorWithHexString:@"#b2b2b2"];
    _nameLabel.font = [UIFont fontWithName:Font_Helvetica size:23/2];
    [self.contentView addSubview:_nameLabel];
    
    _bubbleView = [[ChatBubbleView alloc] initWithFrame:CGRectZero];
    _bubbleView.userInteractionEnabled = YES;
    [self.contentView addSubview:_bubbleView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.font = [UIFont fontWithName:Font_Helvetica size:23/2];
    _timeLabel.textColor = [UIColorUtil colorWithHexString:@"#b2b2b2"];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    BOOL isShow = [_message.msg_flag isEqualToString:@"ME"]?YES:NO;
    
    _headImgaeView.hidden = isShow;
    
    _nameLabel.hidden = isShow;
    
    CGSize size = [ChatRoomBaseCell sizeMessage:_message.msg_message];
    
    if (!isShow) {
        [self setLeftFrame:size];
    }else{
        [self setRightFrame:size];
    }
}

- (void)setLeftFrame:(CGSize)messageSize
{
    
    CGFloat width = 80;
    CGFloat x = UIWIDTH/2 - width/2;
    CGFloat y = CELLPADDING + (IsEmpty(_message.msg_hasTime)?0:5);
    CGFloat height = IsEmpty(_message.msg_hasTime)?0:TIME_HEIGHT;
    // 时间周期
    _timeView.frame = CGRectMake(x, y, width, height);
    
    // 头像
    y = _timeView.frame.origin.y + height + CELLPADDING ;
    _headImgaeView.frame = CGRectMake(HEAD_PADDING, y, HEAD_SIZE, HEAD_SIZE);
    
    // 姓名
    x = _headImgaeView.frame.origin.x + _headImgaeView.frame.size.width + HEAD_PADDING;
    _nameLabel.frame = CGRectMake(x, y + (IsEmpty(_message.msg_hasTime)?0:5), NAME_LABEL_WIDTH, NAME_LABEL_HEIGHT);
    
    // 气泡
    width = messageSize.width + kMessage_Left + kMessage_Right;
    height = messageSize.height + kMessage_Top  + kMessage_Buttom;
    y = _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 2;
    _bubbleView.frame = CGRectMake(x, y, width, height);
    
    // 发表时间
    x = _bubbleView.frame.origin.x + _bubbleView.frame.size.width + HEAD_PADDING - 6;
    y = _bubbleView.frame.origin.y + _bubbleView.frame.size.height - NAME_LABEL_HEIGHT - 6;
    _timeLabel.frame = CGRectMake(x, y, TIME_LABEL_WIDTH, NAME_LABEL_HEIGHT);
    
    // 设置气泡
    BOOL isAname = [_message.hasAname isEqualToString:[[UserInfoManager sharedInstance] getCurrentUserInfo].userID];
    //UIImage *image = [UIImage imageNamed:isAname?@"chat_orange":@"chat_gray"];
    _bubbleView.messageLabel.textColor = isAname?[UIColor whiteColor]:[UIColorUtil colorWithHexString:@"#1a1a1a"];
    
    UIImage *image = [UIImage imageNamed:isAname?@"WeChat_Orange":@"WeChat_gray"];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    _bubbleView.image = image;
}

- (void)setRightFrame:(CGSize)messageSize
{
    CGFloat width = 80;
    CGFloat x = UIWIDTH/2 - width/2;
    CGFloat y = CELLPADDING + (IsEmpty(_message.msg_hasTime)?0:5);
    CGFloat height = IsEmpty(_message.msg_hasTime)?0:TIME_HEIGHT;
    // 时间周期
    _timeView.frame = CGRectMake(x, y, width, height);
    
    // 气泡
    width = messageSize.width + kMessage_Left + kMessage_Right;
    height = messageSize.height + kMessage_Top  + kMessage_Buttom;
    x = UIWIDTH - width - HEAD_PADDING + 6;
    y = _timeView.frame.origin.y + _timeView.frame.size.height + 5;
    _bubbleView.frame = CGRectMake(x, y, width, height);
    
    // 发表时间
    x = _bubbleView.frame.origin.x - TIME_LABEL_WIDTH - HEAD_PADDING + 4;
    y = _bubbleView.frame.origin.y + _bubbleView.frame.size.height - NAME_LABEL_HEIGHT - 6;
    _timeLabel.frame = CGRectMake(x, y, TIME_LABEL_WIDTH, NAME_LABEL_HEIGHT);
    
    // 设置气泡
    UIImage *image = [UIImage imageNamed:@"WeChat"];//myChat
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    _bubbleView.image = image;
}


- (void)setMessage:(ChatRoomModel *)message
{
    _message = message;
    
    BOOL isShow = [_message.msg_flag isEqualToString:@"ME"]?YES:NO;
    
    _bubbleView.isMe = isShow;
    
    if (!isShow) {
        [_headImgaeView setImageURLStr:User_Head(_message.userID)];
        
        NSString *distance = [NSTimeUtil getDistance:message.msg_longitude latitude:message.msg_latitude];
        
        if ([message.msg_hasStealth isEqualToString:@"1"]){
            _nameLabel.text = [NSString stringWithFormat:@"隐身用户 %@",distance];
        }else
            _nameLabel.text = [NSString stringWithFormat:@"%@  %@",_message.userName,distance];
        debugLog(@"%@----%@",_message.userName,distance);
    }
        
    self.timeLabel.text = [UtilDate dateFromString:_message.msg_time withFormat:DateFormat_HM];
    self.bubbleView.message = _message.msg_message;
    self.timeView.time = _message.msg_hasTime;
}

+ (CGSize)sizeMessage:(NSString *)message
{
    CGFloat width = UIWIDTH - HEAD_SIZE - 2 * HEAD_PADDING - 2 * kMessage_Left - 60;
    // 文本
    CGSize size = [UILabel sizeWithString:message font:MESSAGE_FONT_SIZE maxSize:CGSizeMake(width, CGFLOAT_MAX)];
    return size;
}

+ (CGFloat)getCellHeight:(ChatRoomModel *)message
{
    CGSize size = [ChatRoomBaseCell sizeMessage:message.msg_message];
    
    BOOL isShow = [message.msg_flag isEqualToString:@"ME"]?YES:NO;
    
    CGFloat height = size.height + kMessage_Top * 2;
    
    height = height + (isShow?0:NAME_LABEL_HEIGHT) + CELLPADDING ;
    
    height = height + (IsEmpty(message.msg_hasTime)?CELLPADDING:(TIME_HEIGHT + 10 + 5)) + CELLPADDING;
    
    return height;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
