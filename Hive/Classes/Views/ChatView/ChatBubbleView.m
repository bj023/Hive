//
//  ChatBubbleView.m
//  Hive
//
//  Created by 那宝军 on 15/4/28.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ChatBubbleView.h"

#define MESSAGE_FONT_SIZE [UIFont systemFontOfSize:16] // 字体


@interface ChatBubbleView ()
{
    UILabel *_messageLabel;
}
@end

@implementation ChatBubbleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.font = MESSAGE_FONT_SIZE;
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.numberOfLines = 0;
        [self addSubview:_messageLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat messageY = kMessage_Top;
    CGFloat messageX = kMessage_Left - (_isMe?2:-3);
    CGFloat messageW = self.frame.size.width - 2 * kMessage_Left;
    CGFloat messageH = self.frame.size.height - 2 * kMessage_Top;
    
    _messageLabel.frame = CGRectMake(messageX, messageY, messageW, messageH);
}

- (void)setMessage:(NSString *)message
{
    _messageLabel.text = message;
}

- (void)setIsMe:(BOOL)isMe
{
    _isMe = isMe;
    _messageLabel.textColor = isMe?[UIColor whiteColor]:[UIColor blackColor];
}
@end
