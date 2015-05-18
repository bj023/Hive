//
//  chatViewCell.m
//  Hive
//
//  Created by mac on 15/4/28.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "chatViewCell.h"
#import "Utils.h"
#import "ChatModel.h"


@interface chatViewCell ()

@end

@implementation chatViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView Delegate:(id<ChatViewCellDelegate>)delegate
{
    static NSString *identifier = @"ChatViewCell";
    chatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[chatViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier Delegate:delegate];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Delegate:(id<ChatViewCellDelegate>)delegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.delegate = delegate;
        
        // 发送进度显示view
        _activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE)];
        [_activityView setHidden:NO];
        [self.contentView addSubview:_activityView];
        
        // 重发按钮
        _retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _retryButton.frame = CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE);
        //[_retryButton addTarget:self action:@selector(retryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_retryButton setBackgroundImage:[UIImage imageNamed:@"messageSendFail.png"] forState:UIControlStateNormal];
        [_retryButton setBackgroundColor:[UIColor clearColor]];
        [_activityView addSubview:_retryButton];
        _retryButton.hidden = YES;
        
        // 菊花
        _activtiy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activtiy.frame = CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE);
        _activtiy.backgroundColor = [UIColor clearColor];
        _activtiy.hidden = YES;
        [_activityView addSubview:_activtiy];
        
        //已读
        _hasRead = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE)];
        _hasRead.text = @"Read";
        _hasRead.textColor = [UIColor whiteColor];
        _hasRead.textAlignment = NSTextAlignmentCenter;
        _hasRead.backgroundColor = [UIColorUtil colorWithHexString:@"e8e8e8"];
        _hasRead.layer.cornerRadius = 8;
        _hasRead.layer.masksToBounds = YES;
        _hasRead.hidden = YES;
        _hasRead.font = [UIFont systemFontOfSize:12];
        [_hasRead sizeToFit];
        [_activityView addSubview:_hasRead];
        
        /*
        
        // 发送进度显示view
        _activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE)];
        [_activityView setHidden:NO];
        [self.contentView addSubview:_activityView];
        
        // 重发按钮
        _retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _retryButton.frame = CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE);
        //[_retryButton addTarget:self action:@selector(retryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_retryButton setBackgroundImage:[UIImage imageNamed:@"messageSendFail.png"] forState:UIControlStateNormal];
        [_retryButton setBackgroundColor:[UIColor redColor]];
        [_activityView addSubview:_retryButton];
        
        // 菊花
        _activtiy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activtiy.backgroundColor = [UIColor blueColor];
        [_activityView addSubview:_activtiy];
        
        //已读
        _hasRead = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE)];
        _hasRead.text = @"已读";
        _hasRead.textAlignment = NSTextAlignmentCenter;
        _hasRead.font = [UIFont systemFontOfSize:12];
        [_hasRead sizeToFit];
        [_activityView addSubview:_hasRead];
        */
        [self.headImgaeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadImgAction:)]];
        //[self.bubbleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBubbleAction:)]];
        [self.bubbleView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)]];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    BOOL isShow = [self.message.msg_flag isEqualToString:@"ME"]?YES:NO;
    BOOL isSend = [self.message.msg_isSend boolValue];
    BOOL isRead = [self.message.hasRead boolValue];

    
    _activityView.frame = CGRectMake(0, self.bubbleView.frame.origin.y, SEND_STATUS_SIZE, SEND_STATUS_SIZE);
    
    _hasRead.frame = CGRectMake(self.timeLabel.frame.origin.x, 3, SEND_STATUS_SIZE * 2, SEND_STATUS_SIZE - 5);
    _activtiy.frame = CGRectMake(self.timeLabel.frame.origin.x - SEND_STATUS_SIZE, 0, SEND_STATUS_SIZE, isShow?SEND_STATUS_SIZE:0);
    _retryButton.frame = CGRectMake(self.timeLabel.frame.origin.x - SEND_STATUS_SIZE, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE);

    [_activtiy startAnimating];
    if (isShow) {
        _activityView.hidden = isSend;
        _retryButton.hidden = isSend;
        _activtiy.hidden = isSend;
        
        if (isRead) {
            _hasRead.hidden = NO;
            _activityView.hidden = NO;

        }else{
            _hasRead.hidden = YES;
            _activityView.hidden = YES;
        }
        
        
    }else{
        _activityView.hidden = YES;
        _activtiy.hidden = YES;
        _hasRead.hidden = YES;
        _retryButton.hidden = YES;
    }
    
}

- (void)set_sendMessageState:(BOOL)isSend
{
    [_activtiy stopAnimating];
    _activtiy.hidden = YES;
    
    if (isSend) {
        _retryButton.hidden = YES;
    }else
    {
        _retryButton.hidden = NO;
    }
}

- (void)set_hasReadMessageState:(BOOL)isSend
{
    _activityView.hidden = NO;

    _hasRead.hidden = !isSend;
}

- (void)setMessage:(ChatModel *)message
{
    [super setMessage:message];
}

- (void)clickHeadImgAction:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(tapHeadImgSendActionWithMessage:)]) {
        [self.delegate tapHeadImgSendActionWithMessage:self.message];
    }
}

#pragma -mark 长按气泡 弹出菜单
- (void)longPressAction:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        debugLog(@"%lf-%lf",recognizer.view.frame.origin.x,recognizer.view.frame.origin.y);

        
        UIView *view = recognizer.view;
        [self becomeFirstResponder];
        UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"Copy" action:@selector(copyMessage:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:flag, nil]];
        [menu setTargetRect:view.frame inView:self];
        [menu setMenuVisible:YES animated:YES];
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
    }else if (action == @selector(copyMessage:))
    {
        return YES;
    }
    else
    {
        return NO;
        //return [super canPerformAction:action withSender:sender];
    }
}
- (void)copyMessage:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.message.msg_message];
}
@end
