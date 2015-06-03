//
//  SettingsController.h
//  Hive
//
//  Created by BaoJun on 15/3/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "MainViewController.h"

typedef void(^ClickCellAtIndex)(NSIndexPath *indexpath);
typedef void(^SelectPhoto)(NSString *str);

@interface SettingsController : MainViewController
@property (nonatomic, copy) ClickCellAtIndex clickCellAtIndex;
@property (nonatomic, copy) SelectPhoto selectBlock;

- (void)reloadSetting_ProfileData;


- (void)updateViewState;

- (void)set_HeadIMG:(UIImage *)image;
@end
