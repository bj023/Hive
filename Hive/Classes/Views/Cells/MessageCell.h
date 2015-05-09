//
//  MessageCell.h
//  Hive
//
//  Created by BaoJun on 15/4/2.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  自定义 Message Cell
 */
//typedef void(^clickUserHeadIMG)(NSIndexPath *indexpath);

@protocol MessageCellDelegate;
@class ChatModel;
@interface MessageCell : UITableViewCell

@property (strong, nonatomic)NSIndexPath *indexPath;

@property (nonatomic, weak) id<MessageCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)getMessageCellHeight;

- (void)set_MessageCellData:(ChatModel *)model;


@end

@protocol MessageCellDelegate <NSObject>

- (void)deleteMessageCellData:(NSIndexPath *)indexpath;
- (void)tapHeadImgSendAction:(ChatModel *)model;

@end

