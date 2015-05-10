//
//  ChatCell.m
//  Hive
//
//  Created by 那宝军 on 15/4/8.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ChatCell.h"
#import "CustomIMGView.h"
#import "Utils.h"
#import "ChatRoomModel.h"


#define HEAD_SIZE 40 // 头像大小
#define HEAD_PADDING 10 // 头像到cell的内间距和头像到bubble的间距
#define MESSAGE_FONT_SIZE [UIFont systemFontOfSize:16] // 字体

#define Message_X 23
#define Message_Y 8
@interface ChatCell ()
@property (strong, nonatomic)CustomIMGView *headIMG;
@property (strong, nonatomic)UIImageView *bubbleIMG;
@property (strong, nonatomic)UILabel *userInforLabel;
@property (strong, nonatomic)UILabel *messageLabel;
@property (strong, nonatomic)UILabel *timeLabel;
@end

@implementation ChatCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"ChatCell";
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initChatCell];
        [self addRecognizer];
    }
    
    return self;
}

#pragma -mark 初始化
- (void)initChatCell
{
    CGFloat padding = 10;
    CGFloat headX = padding;
    CGFloat headY = padding;
    CGFloat headW = HEAD_SIZE;// 图片的直径
    CGFloat headH = headW;
    if (!self.headIMG) {
        self.headIMG = [[CustomIMGView alloc] initWithFrame:CGRectMake(headX, headY, headW, headH)];
        self.headIMG.layer.cornerRadius = headH/2;
        self.headIMG.clipsToBounds = YES;
        self.headIMG.backgroundColor = [UIColorUtil colorWithCoded9d9d9];
    }
    
    CGFloat userX = headW + padding + HEAD_PADDING + 7;
    CGFloat userY = headY;
    CGFloat userW = UIWIDTH - headW - 3 * padding;
    CGFloat userH = 20; // 高度
    if (!self.userInforLabel) {
        self.userInforLabel = [[UILabel alloc] initWithFrame:CGRectMake(userX, userY, userW, userH)];
        self.userInforLabel.font = [UIFont systemFontOfSize:12];
        self.userInforLabel.textAlignment = NSTextAlignmentLeft;
        self.userInforLabel.textColor = [UIColor grayColor];
    }
    
    if (!self.bubbleIMG) {
        self.bubbleIMG = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.bubbleIMG.backgroundColor = [UIColor clearColor];
        self.bubbleIMG.userInteractionEnabled =YES;
    }
    
    if (!self.messageLabel) {
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.messageLabel.font = MESSAGE_FONT_SIZE;
        self.messageLabel.textColor = [UIColor blackColor];
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
        self.messageLabel.numberOfLines = 0;
    }
    
    if (!self.timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.textColor = [UIColor grayColor];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    [self.bubbleIMG addSubview:self.messageLabel];
    [self.contentView addSubview:self.headIMG];
    [self.contentView addSubview:self.userInforLabel];
    [self.contentView addSubview:self.bubbleIMG];
    [self.contentView addSubview:self.timeLabel];
}

- (void)addRecognizer
{
    [self.bubbleIMG addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHeadIMGAction:)]];
    [self.bubbleIMG addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBubbleIMGAction:)]];
    

   
    [self.headIMG addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadIMGAction:)]];
}

// 长按头像手势

- (void)longPressHeadIMGAction:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.longBlock(self.indexPath);
    }
}

- (void)tapBubbleIMGAction:(UITapGestureRecognizer *)sender
{
    self.tapBubbleBlock(self.indexPath);
}

- (void)tapHeadIMGAction:(UITapGestureRecognizer *)sender
{
    self.tapBlock(self.indexPath);
}

#pragma -mark 区分左右 message
- (void)set_DataWithMessage:(ChatRoomModel *)message
{
    
    BOOL isShow = [message.flag isEqualToString:@"ME"]?YES:NO;
    
    if (!isShow) {
        [self setCellLeftSubviews:message.message isAname:[message.isAname isEqualToString:[[UserInfoManager sharedInstance] getCurrentUserInfo].userID]];
        self.userInforLabel.hidden = NO;
        self.headIMG.hidden = NO;
        
        if ([message.isStealth isEqualToString:@"1"]) {
            self.userInforLabel.text = @"隐身用户 0.1 km";
        }else
            self.userInforLabel.text = message.userName;

        [self.headIMG setImageURLStr:[NSString stringWithFormat:@"http://115.28.51.196/X_USER_ICON/%@.jpg",message.userID]];
        
    }else{
        [self setCellRIghtSubviews:message.message];
        self.userInforLabel.hidden = YES;
        self.headIMG.hidden = YES;
    }
    
    self.messageLabel.text = message.message;

    self.timeLabel.text = [[message.time componentsSeparatedByString:@" "] objectAtIndex:1];
}

- (void)setCellLeftSubviews:(NSString *)message isAname:(BOOL)aName
{
    CGSize size = [ChatCell sizeMessage:message];
    
    // message
    self.messageLabel.frame = CGRectMake(Message_X, Message_Y-1, size.width, size.height);
    
    CGFloat bubbleX = self.headIMG.frame.size.width + self.headIMG.frame.origin.x + HEAD_PADDING;
    CGFloat bubbleY = self.userInforLabel.frame.origin.y + self.userInforLabel.frame.size.height + HEAD_PADDING - 5;
    CGFloat bubbleW = size.width + self.messageLabel.frame.origin.x * 2 - 5;
    CGFloat bubbleH = size.height + self.messageLabel.frame.origin.y * 2;
    self.bubbleIMG.frame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
    
    //UIImage *image = [UIImage imageNamed:aName?@"chat_orange":@"chat_gray"];
    //UIImage *image = [UIImage imageNamed:aName?@"WeChat_Orange":@"WeChat_gray"];
    UIImage *image = [UIImage imageNamed:@"WeChat_gray"];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    self.bubbleIMG.image = image;
    
    self.timeLabel.frame = CGRectMake(self.bubbleIMG.frame.size.width + self.bubbleIMG.frame.origin.x + 3, self.bubbleIMG.frame.size.height + self.bubbleIMG.frame.origin.y - 25, 40, 20);

    self.messageLabel.textColor = [UIColor blackColor];
}

#pragma -mark 设置 Cell 子控件
- (void)setCellRIghtSubviews:(NSString*)message
{
    CGSize size = [ChatCell sizeMessage:message];
    
    // message
    self.messageLabel.frame = CGRectMake(Message_X - 6, Message_Y, size.width, size.height);
    
    CGFloat bubbleX = UIWIDTH - size.width - Message_X * 2 + 5; // 偏移量
    CGFloat bubbleY = Message_Y;//HEAD_PADDING * 2 + Message_Y;
    CGFloat bubbleW = size.width + Message_X * 2 - 8;
    CGFloat bubbleH = size.height + Message_Y * 2;
    self.bubbleIMG.frame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
    
    UIImage *image = [UIImage imageNamed:@"WeChat"];//myChat
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    self.bubbleIMG.image = image;
    
    self.timeLabel.frame = CGRectMake(bubbleX - 43, self.bubbleIMG.frame.size.height + self.bubbleIMG.frame.origin.y - 25, 40, 20);

    self.messageLabel.textColor = [UIColor whiteColor];

}

#pragma -mark Chat 行高
+ (CGFloat)getChatCellHeight:(NSString *)message
{
    return [ChatCell sizeMessage:message].height + 20 + HEAD_PADDING * 4 + Message_Y * 2;
}

+ (CGSize)sizeMessage:(NSString *)message
{
    CGFloat width = UIWIDTH - HEAD_SIZE - 2 * HEAD_PADDING - Message_X * 2 - 60;
    // 文本
    CGSize size = [UILabel sizeWithString:message font:MESSAGE_FONT_SIZE maxSize:CGSizeMake(width, CGFLOAT_MAX)];
    return size;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
