//
//  MainViewController.m
//  Hive
//
//  Created by BaoJun on 15/3/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "MainViewController.h"
#import "Utils.h"
#import <Reachability.h>
#import "GPLoadingButton.h"

#define kNextWorkViewHeight  64/2

@interface MainViewController ()
{
    Reachability  *hostReach;
    UIView *_nextWorkView;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor];
    [self configNavigationBar_Appearance];
    [self checkNetwork];
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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if (iOS8)
        [[UINavigationBar appearance] setTranslucent:NO];
    //[[UINavigationBar appearance] setBarTintColor:[UIColorUtil colorWithHexString:@"#1b2430"]];
    //[[UINavigationBar appearance] setTintColor:[UIColorUtil colorWithHexString:@"#f8f8f8"]];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:NavTitleFont, NSFontAttributeName,
                                [UIColor blackColor], NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
}

#pragma -mark 检测网络
- (void)checkNetwork
{
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [hostReach startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    NSString *showString;
    switch (status)
    {
        case NotReachable:
            // 没有网络连接
            showString = @"已断开网络连接";
            [self showCusstomNetWorkView];
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            showString = @"正在使用3G网络";
            break;
        case ReachableViaWiFi:
        {
            [self removeCusstomNetWorkView];

            showString = @"正在使用wifi网络";
            if ([[UserInfoManager sharedInstance] checkUserIsLogin]) {
                [[XMPPManager sharedInstance] connect];
            }
        }
            break;
    }
}

- (void)showCusstomNetWorkView
{
    if (!_nextWorkView) {
        _nextWorkView = [[UIView alloc] init];
        _nextWorkView.frame = CGRectMake(0, 0, UIWIDTH, kNextWorkViewHeight);
        _nextWorkView.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:_nextWorkView];
        
        CGFloat titleW = 100;
        CGFloat titleH = _nextWorkView.frame.size.height;
        CGFloat titleY = 0;
        CGFloat titleX = _nextWorkView.frame.size.width/2 - titleW/2;
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
        titleLab.text = @"Connecting";
        titleLab.textColor = [UIColor whiteColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont fontWithName:GothamRoundedBook size:16];
        [_nextWorkView addSubview:titleLab];
        
        /* */
        GPLoadingButton *activityButton = [[GPLoadingButton alloc] initWithFrame:CGRectMake(titleX-kNextWorkViewHeight/2, kNextWorkViewHeight/4,kNextWorkViewHeight/2, kNextWorkViewHeight/2)];
        activityButton.rotatorColor = [UIColor whiteColor];
        [activityButton startActivity];
        [_nextWorkView addSubview:activityButton];
    }
}

- (void)removeCusstomNetWorkView
{
    [_nextWorkView removeFromSuperview];
}
@end
