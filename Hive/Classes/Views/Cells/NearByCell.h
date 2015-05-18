//
//  NearByCell.h
//  Hive
//
//  Created by BaoJun on 15/4/2.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  自定义 附近人 Cell
 */
@class NearByModel;


@interface NearByCell : UITableViewCell

@property (strong, nonatomic)NSIndexPath *indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)getNearByCellHeight;

- (void)set_NearByCellData:(NearByModel *)model;

- (void)set_NearByCellUserData;

@end
