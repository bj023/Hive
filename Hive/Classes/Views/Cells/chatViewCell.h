//
//  chatViewCell.h
//  Hive
//
//  Created by mac on 15/4/28.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ChatBaseCell.h"

@class ChatModel;
@protocol ChatViewCellDelegate;
#define SEND_STATUS_SIZE 20 // 发送状态View的Size
#define ACTIVTIYVIEW_BUBBLE_PADDING 5 // 菊花和bubbleView之间的间距

@interface chatViewCell : ChatBaseCell
@property (nonatomic, weak) id<ChatViewCellDelegate>delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImageView *activtiyImg;
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, strong) UIImageView *hasRead;

+ (instancetype)cellWithTableView:(UITableView *)tableView Delegate:(id<ChatViewCellDelegate>)delegate;

@end

@protocol ChatViewCellDelegate <NSObject>

- (void)tapHeadImgSendActionWithMessage:(ChatModel *)message;

- (void)deleteMessage:(ChatModel *)message IndexPath:(NSIndexPath *)indexpath;


- (void)resendMessage:(ChatModel *)message;

@end