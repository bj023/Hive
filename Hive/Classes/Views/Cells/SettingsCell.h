//
//  SettingsCell.h
//  Hive
//
//  Created by BaoJun on 15/3/26.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  自定义 设置页 Cell
 */

@interface SettingsCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)settingData:(NSString *)title;

+ (CGFloat)getSettingsCellHeight;
@end
