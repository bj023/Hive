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

@interface MessageCell : UITableViewCell

@property (strong, nonatomic)NSIndexPath *indexPath;
//@property (copy,   nonatomic)clickUserHeadIMG block;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)getMessageCellHeight;

- (void)set_MessageCellData;
@end
