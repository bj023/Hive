//
//  MainViewController.h
//  Hive
//
//  Created by BaoJun on 15/3/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MainViewControllerBlock)(NSString *userID);

@interface MainViewController : UIViewController

@property (copy, nonatomic) MainViewControllerBlock mainViewBlock;
@end
