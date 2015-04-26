//
//  NearByController.h
//  Hive
//
//  Created by BaoJun on 15/3/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "MainViewController.h"
#import "NearByModel.h"

typedef void(^NearByControllerBlock)(NearByModel * model, NSIndexPath *indexpath);

@interface NearByController : MainViewController

@property (copy, nonatomic) NearByControllerBlock nearByBlock;
- (void)sendNearByAction;

- (UIButton *)getSelectBtuuon;

- (void)moveSelectButtonWithPadding:(CGFloat)padding;

- (void)updateCellWithNearby:(NearByModel *)model IndexPath:(NSIndexPath *)indexpath;
- (void)removeCellWithNearby:(NearByModel *)model IndexPath:(NSIndexPath *)indexpath;

@end
