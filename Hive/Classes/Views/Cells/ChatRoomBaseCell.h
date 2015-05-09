//
//  ChatRoomBaseCell.h
//  Hive
//
//  Created by 那宝军 on 15/5/7.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIMGView.h"
#import "ChatTimeView.h"
#import "ChatBubbleView.h"

#define HEAD_SIZE 40 // 头像大小
#define HEAD_PADDING 10 // 头像到cell的内间距和头像到bubble的间距
#define CELLPADDING 8 // Cell之间间距

#define NAME_LABEL_WIDTH 180 // nameLabel宽度
#define NAME_LABEL_HEIGHT 20 // nameLabel 高度
#define NAME_LABEL_PADDING 0 // nameLabel间距
#define NAME_LABEL_FONT_SIZE 14 // 字体
#define TIME_LABEL_WIDTH 40


@class ChatRoomModel;
@interface ChatRoomBaseCell : UITableViewCell

@property (nonatomic, strong)ChatTimeView *timeView;
@property (nonatomic, strong)CustomIMGView *headImgaeView;
@property (nonatomic, strong)ChatBubbleView *bubbleView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)ChatRoomModel *message;

+ (CGFloat)getCellHeight:(ChatRoomModel *)message;

@end