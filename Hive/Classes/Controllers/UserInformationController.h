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

typedef enum{
    PushNextVC = 1,
    PushNextUpdateVC = 2,
    PushNextNoneVC = 3,
} PUSH_TYPE;

@class NearByModel;
@protocol UserInformationVCDelegate;
@interface UserInformationController : UIViewController

@property (weak, nonatomic) id<UserInformationVCDelegate>delegate;
@property (strong, nonatomic) NearByModel *model;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) PUSH_TYPE pushType;
@end

@protocol UserInformationVCDelegate <NSObject>
- (void)talkCellWithNearByModel:(NearByModel *)model IndexPath:(NSIndexPath *)indexpath;
- (void)followCellWithNearByModel:(NearByModel *)model IndexPath:(NSIndexPath *)indexPath PUSHTYPE:(PUSH_TYPE)pushType;
- (void)blockCellWithNearByModel:(NearByModel *)model IndexPath:(NSIndexPath *)indexPath  PUSHTYPE:(PUSH_TYPE)pushType;
@end