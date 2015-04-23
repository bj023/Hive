//
//  UserInformationController.h
//  Hive
//
//  Created by BaoJun on 15/3/31.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "MainViewController.h"

/**
 *  查看个人主页
 */

@class NearByModel;
@protocol UserInformationVCDelegate;
@interface UserInformationController : UIViewController

@property (weak, nonatomic) id<UserInformationVCDelegate>delegate;
@property (strong, nonatomic) NearByModel *model;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end

@protocol UserInformationVCDelegate <NSObject>
- (void)followCellWithNearByModel:(NearByModel *)model IndexPath:(NSIndexPath *)indexPath;
- (void)blockCellWithNearByModel:(NearByModel *)model IndexPath:(NSIndexPath *)indexPath;
@end