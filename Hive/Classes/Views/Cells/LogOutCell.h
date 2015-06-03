//
//  LogOutCell.h
//  Hive
//
//  Created by BaoJun on 15/3/31.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  自定义 退出 Cell
 */

@interface LogOutCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setIconIMG:(NSString *)iconStr Title:(NSString *)title;

@end
