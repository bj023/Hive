//
//  ChatBaseCell.h
//  Hive
//
//  Created by mac on 15/4/28.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIMGView.h"
#import "ChatTimeView.h"
#import "ChatBubbleView.h"

#define HEAD_SIZE 55 // 头像大小
#define HEAD_PADDING 25/2 // 头像到cell的内间距和头像到bubble的间距
#define CELLPADDING 8 // Cell之间间距

#define NAME_LABEL_WIDTH 180 // nameLabel宽度
#define NAME_LABEL_HEIGHT 20 // nameLabel 高度
#define NAME_LABEL_PADDING 0 // nameLabel间距
#define NAME_LABEL_FONT_SIZE 14 // 字体
#define TIME_LABEL_WIDTH 40

#define TIME_HEIGHT 22 // 时间周期高度

@class ChatModel;
@interface ChatBaseCell : UITableViewCell

@property (nonatomic, strong)ChatTimeView *timeView;
@property (nonatomic, strong)CustomIMGView *headImgaeView;
@property (nonatomic, strong)ChatBubbleView *bubbleView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)ChatModel *message;

+ (CGFloat)getCellHeight:(ChatModel *)message;

@end
