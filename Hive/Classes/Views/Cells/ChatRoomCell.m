//
//  chatViewCell.m
//  Hive
//
//  Created by mac on 15/4/28.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ChatRoomCell.h"
#import "Utils.h"
#import "ChatRoomModel.h"


@interface ChatRoomCell ()

@end

@implementation ChatRoomCell

+ (instancetype)cellWithTableView:(UITableView *)tableView Delegate:(id<ChatRoomViewCellDelegate>)delegate
{
    static NSString *identifier = @"ChatViewCell";
    ChatRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ChatRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier Delegate:delegate];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Delegate:(id<ChatRoomViewCellDelegate>)delegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.delegate = delegate;
        
        // 发送进度显示view
        _activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE)];
        [_activityView setHidden:NO];
        [self.contentView addSubview:_activityView];
        
        _activtiyImg = [[UIImageView alloc] init];
        _activtiyImg.animationImages = @[[UIImage imageNamed:@"load1"],
                                         [UIImage imageNamed:@"load2"],
                                         [UIImage imageNamed:@"load3"]];
        _activtiyImg.animationDuration = 0.8;
        [self.contentView addSubview:_activtiyImg];
        [_activtiyImg startAnimating];
        
        // 重发按钮
        _retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        //_retryButton.frame = CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE);
        //[_retryButton addTarget:self action:@selector(retryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_retryButton setBackgroundImage:[UIImage imageNamed:@"messageSendFail.png"] forState:UIControlStateNormal];
        [_retryButton setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_retryButton];
         //_retryButton.hidden = YES;
        
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
        
        [_retryButton addTarget:self action:@selector(clickResendAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.headImgaeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadImgAction:)]];
        [self.bubbleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBubbleAction:)]];
        [self.bubbleView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressChatRoomAction:)]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:) name:UIMenuControllerWillHideMenuNotification object:nil];
    }
    
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
   
    BOOL isShow = [self.message.msg_flag isEqualToString:@"ME"]?YES:NO;
    _activityView.frame = CGRectMake(0, self.bubbleView.frame.origin.y, SEND_STATUS_SIZE, SEND_STATUS_SIZE);
    
    debugLog(@"%@-%@-%@-%@",self.indexPath,self.message.msg_flag,self.message.msg_type,self.message.msg_message);
    
    if (isShow) {
        _activityView.hidden = NO;
        
        switch ([self.message.msg_send_type intValue]) {
            case SendCHatMessageNomal:
            {
                _activtiyImg.hidden = NO;
                _retryButton.hidden = YES;
            }
                break;
            case SendChatMessageSuccessState:
            {
                _activtiyImg.hidden = YES;
                _retryButton.hidden = YES;
            }
                break;
            case SendChatMessageReadState:
            {
                _activtiyImg.hidden = YES;
                _retryButton.hidden = YES;
            }
                break;
            case SendChatMessageFailState:
            {
                _activtiyImg.hidden = YES;
                _retryButton.hidden = NO;
                [self updateBubbleFrame];
            }
                break;
            default:
                break;
        }
        
    }else{
        _activityView.hidden = YES;
        _retryButton.hidden = YES;
    }
    
}
/*
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    BOOL isShow = [self.message.msg_flag isEqualToString:@"ME"]?YES:NO;
    BOOL isSend = [self.message.msg_isSend boolValue];
    
    if (isShow) {
        
        if (!isSend) {
            _retryButton.hidden = NO;
            //_activtiyImg.hidden = YES;
            [self updateBubbleFrame];
        }else{
            _retryButton.hidden = YES;
            //[_activtiyImg stopAnimating];
            //_activtiyImg.hidden = YES;
        }
        
    }else{
        _retryButton.hidden = YES;
        _activtiyImg.hidden = YES;
    }
}
*/


- (void)updateBubbleFrame
{
    CGFloat padding = 10;
    CGFloat retryW = 30;
    CGFloat retryH = retryW;
    CGFloat retryX = UIWIDTH - retryW - padding;
    CGFloat retryY = self.bubbleView.frame.origin.y + 2;
    _retryButton.frame = CGRectMake(retryX, retryY, retryW, retryH);
    CGRect bubbleF = self.bubbleView.frame;
    bubbleF.origin.x -= (retryW + padding + 5);
    self.bubbleView.frame = bubbleF;
    
    CGRect timeF = self.timeLabel.frame;
    timeF.origin.x -= (retryW + padding + 5);
    self.timeLabel.frame = timeF;
    
    _activtiyImg.frame = CGRectMake(self.timeLabel.frame.origin.x + 7, self.timeLabel.frame.origin.y - 5, SEND_STATUS_SIZE, 4);
}

- (void)setMessage:(ChatRoomModel *)message
{
    [super setMessage:message];
    
    [self loadUserIconPath:message.userID];
    
}

- (void)clickResendAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(resendMessage:)]) {
        [self.delegate resendMessage:self.message];
    }
}


- (void)clickHeadImgAction:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(tapHeadImgSendActionWithMessage:)]) {
        [self.delegate tapHeadImgSendActionWithMessage:self.message];
    }
}

- (void)clickBubbleAction:(UITapGestureRecognizer *)sender
{
    if ([self.message.msg_type intValue] != 2) {
        [self showhighlightedBubbleView];
    }
    
    if ([self.delegate respondsToSelector:@selector(tapBubbleSendActionWithMessage:)]) {
        [self.delegate tapBubbleSendActionWithMessage:self.message];
    }
 
    [self performSelector:@selector(hiddenHighlightedBubbleView) withObject:nil afterDelay:0.5];
}

#pragma -mark 长按气泡 弹出菜单
- (void)longPressChatRoomAction:(UIGestureRecognizer *)recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateBegan && [self.message.msg_type intValue] != 2) {
        UIView *view = recognizer.view;
        [self becomeFirstResponder];
        UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"Copy" action:@selector(copyRoomMessage:)];
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
    }else if (action == @selector(copyRoomMessage:))
    {
        [self showhighlightedBubbleView];

        return YES;
    }
    else
    {
        return NO;
        //return [super canPerformAction:action withSender:sender];
    }
}
- (void)copyRoomMessage:(id)sender {
    [self hiddenHighlightedBubbleView];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:IsEmpty(self.message.msg_message)?@"":self.message.msg_message];
}

- (void)WillHideMenu:(id)sender
{
    [self hiddenHighlightedBubbleView];
}

- (void)showhighlightedBubbleView
{
    self.bubbleView.highlighted = YES;
}

- (void)hiddenHighlightedBubbleView
{
    self.bubbleView.highlighted = NO;
}

- (void)loadUserIconPath:(NSString *)userID
{
    NSString *currentUserID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
    if ([currentUserID isEqualToString:userID]) {
        return;
    }
    
    [HttpTool sendRequestProfileWithUserID:userID success:^(id json) {
        ResponseChatUserInforModel *res = [[ResponseChatUserInforModel alloc] initWithString:json error:nil];
        if (res.RETURN_CODE == 200) {
            NearByModel *model = res.RETURN_OBJ;
            [self.headImgaeView setImageURLStr:model.iconPath placeholder:nil];
        }
        
    } faliure:^(NSError *error) {
        
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
