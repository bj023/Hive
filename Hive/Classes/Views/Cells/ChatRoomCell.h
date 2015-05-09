//
//  chatViewCell.h
//  Hive
//
//  Created by 那宝军 on 15/4/28.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ChatRoomBaseCell.h"

@class ChatRoomModel;
@protocol ChatRoomViewCellDelegate;
#define SEND_STATUS_SIZE 20 // 发送状态View的Size
#define ACTIVTIYVIEW_BUBBLE_PADDING 5 // 菊花和bubbleView之间的间距

@interface ChatRoomCell : ChatRoomBaseCell
@property (nonatomic, weak) id<ChatRoomViewCellDelegate>delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIActivityIndicatorView *activtiy;
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, strong) UILabel *hasRead;

+ (instancetype)cellWithTableView:(UITableView *)tableView Delegate:(id<ChatRoomViewCellDelegate>)delegate;

- (void)set_sendMessageState:(BOOL)isSend;
@end

@protocol ChatRoomViewCellDelegate <NSObject>

- (void)tapHeadImgSendActionWithMessage:(ChatRoomModel *)message;

- (void)tapBubbleSendActionWithMessage:(ChatRoomModel *)message;

@end