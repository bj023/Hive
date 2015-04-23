//
//  ChatCell.h
//  Hive
//
//  Created by 那宝军 on 15/4/8.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MessageTypeMe = 0, // 自己发的
    MessageTypeOther = 1 //别人发得
} MessageType;

typedef void(^Long_HeadIMG_GestureBlock)(NSIndexPath *indexpath);

@interface ChatCell : UITableViewCell

@property (strong, nonatomic)NSIndexPath *indexPath;
@property (copy, nonatomic)Long_HeadIMG_GestureBlock longBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)getChatCellHeight:(NSString *)message;
- (void)set_DataWithMessage:(NSString *)message show:(BOOL)isShow;
@end
