//
//  ChatBubbleView.m
//  Hive
//
//  Created by mac on 15/4/28.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ChatBubbleView.h"
#import "Utils.h"
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

#define MESSAGE_FONT_SIZE [UIFont systemFontOfSize:16] // 字体


@interface ChatBubbleView ()

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
    CGFloat messageX = kMessage_Left ;//- (_isMe?2:-3);
    CGFloat messageW = self.frame.size.width -  kMessage_Left - kMessage_Right;
    CGFloat messageH = self.frame.size.height - kMessage_Top - kMessage_Buttom;
    
    _messageLabel.frame = CGRectMake(messageX, messageY, messageW, messageH);
}

- (void)setMessage:(NSString *)message
{
    _messageLabel.text = message;
}

- (void)setIsMe:(BOOL)isMe
{
    _isMe = isMe;
    _messageLabel.textColor = isMe?[UIColor whiteColor]:[UIColorUtil colorWithHexString:@"#1a1a1a"];
}

- (void)setImageUrl:(NSURL *)url
{
    [self sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageProgressiveDownload];
}

- (void)setImageURLStr:(NSString *)urlStr
{
    [self setImageUrl:[NSURL URLWithString:urlStr]];
}

- (UIImage *)imageWithUrl:(NSString *)urlStr
{
    if([[SDImageCache sharedImageCache] diskImageExistsWithKey:urlStr])
    {
        UIImage* image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
        if(!image)
        {
            NSData* data = [[SDImageCache sharedImageCache] performSelector:@selector(imageFromDiskCacheForKey:) withObject:urlStr];
            image = [UIImage imageWithData:data];
        }
        if(!image)
        {
            return image;
        }
    }
    return nil;
}
@end
