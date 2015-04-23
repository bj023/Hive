//
//  MainViewController.m
//  Hive
//
//  Created by BaoJun on 15/3/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "MainViewController.h"
#import "Utils.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor];
    [self configNavigationBar_Appearance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackgroundColor
{
    self.view.backgroundColor = [UIColor whiteColor];
}
#pragma -mark 设置状态栏
- (void)configNavigationBar_Appearance
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (iOS8)
        [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColorUtil colorWithHexString:@"#1b2430"]];
    //[[UINavigationBar appearance] setTintColor:[UIColorUtil colorWithHexString:@"#f8f8f8"]];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:NavTitleFont, NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
}
@end
