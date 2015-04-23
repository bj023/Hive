//
//  NotificationNorCell.h
//  Hive
//
//  Created by BaoJun on 15/3/31.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  自定义 Notification Cell
 */

typedef void(^SwitchChangeValue)(NSIndexPath *indexpath);

@interface NotificationNorCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (copy, nonatomic) SwitchChangeValue block;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setCellDate:(NSString *)title Detail:(NSString *)detail AccessView:(BOOL)flag;

@end
