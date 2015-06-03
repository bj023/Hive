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
@class MessageModel;
@interface MessageCell : UITableViewCell

@property (strong, nonatomic)NSIndexPath *indexPath;

@property (nonatomic, weak) id<MessageCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)getMessageCellHeight;

- (void)set_MessageCellData:(MessageModel *)model;


@end

@protocol MessageCellDelegate <NSObject>

@optional
- (void)deleteMessageCellData:(NSIndexPath *)indexpath;
- (void)tapHeadImgSendAction:(MessageModel *)model;

@end

