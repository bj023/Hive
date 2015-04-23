//
//  ProfileCell.h
//  Hive
//
//  Created by BaoJun on 15/3/31.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  自定义 个人信息 Cell
 */

@interface ProfileCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)getProfileCellHeight;

- (void)setProfileData:(NSString *)content IndexPath:(NSIndexPath *)indexpath;
@end
