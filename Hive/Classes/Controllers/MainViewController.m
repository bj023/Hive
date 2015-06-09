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

#define kNetwork_Unavailable @"Network unavailable"
#define kNetwork_Connecting @"Connecting"

#define kNetwork_Unavailabel_Color [UIColorUtil colorWithHexString:@"#f1553d"]
#define kNetwork_Connecting_Color [UIColorUtil colorWithHexString:@"#ff9d34"]


#define kNextWorkViewHeight  64/2

@interface MainViewController ()
{
    Reachability  *hostReach;
    UIView *_nextWorkView;
    UILabel *_titleLabel;
    GPLoadingButton *_activityButton;
    
    UIView *_alertView;
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
    [[UINavigationBar appearance] setBarTintColor:[UIColorUtil colorWithHexString:@"#f7f7f7"]];// 背景色
    //[[UINavigationBar appearance] setTintColor:[UIColorUtil colorWithHexString:@"#f8f8f8"]];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:NavTitleFont, NSFontAttributeName,
                                [UIColorUtil colorWithHexString:@"#424242"], NSForegroundColorAttributeName, nil];
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
            [self performSelector:@selector(updateNetUnavailabelState) withObject:nil afterDelay:10];
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

- (void)initCusstomNetWorkView
{
    if (!_nextWorkView) {
        _nextWorkView = [[UIView alloc] init];
        _nextWorkView.frame = CGRectMake(0, 0, UIWIDTH, kNextWorkViewHeight);
        _nextWorkView.backgroundColor = kNetwork_Connecting_Color;
        [self.view addSubview:_nextWorkView];
        
        CGFloat titleW = 120;
        CGFloat titleH = _nextWorkView.frame.size.height;
        CGFloat titleY = 0;
        CGFloat titleX = _nextWorkView.frame.size.width/2 - titleW/2;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
        _titleLabel.text = kNetwork_Connecting;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:Font_Helvetica size:13];//[UIFont fontWithName:GothamRoundedBook size:16];
        [_nextWorkView addSubview:_titleLabel];
        
        /* */
        _activityButton = [[GPLoadingButton alloc] initWithFrame:CGRectMake(titleX, kNextWorkViewHeight/4,kNextWorkViewHeight/2, kNextWorkViewHeight/2)];
        _activityButton.rotatorColor = [UIColor whiteColor];
        [_activityButton startActivity];
        [_nextWorkView addSubview:_activityButton];
    }
}

- (void)updateNetUnavailabelState
{
    _activityButton.hidden = YES;
    _titleLabel.text = kNetwork_Unavailable;
    _nextWorkView.backgroundColor = kNetwork_Unavailabel_Color;
}

- (void)showCusstomNetWorkView
{
    [self initCusstomNetWorkView];
    
    [UIView animateWithDuration:0.5 animations:^{
        _nextWorkView.center = CGPointMake(UIWIDTH/2, kNextWorkViewHeight/2);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(removeAlertView) withObject:nil afterDelay:1];
    }];
}

- (void)removeCusstomNetWorkView
{
    [UIView animateWithDuration:0.5 animations:^{
        _nextWorkView.center = CGPointMake(UIWIDTH/2, -kNextWorkViewHeight/2);
    } completion:^(BOOL finished) {
        [_nextWorkView removeFromSuperview];
        _nextWorkView = nil;
    }];
}

#pragma -mark 更新成功提示
- (void)initUpdateView
{
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.frame = CGRectMake(0, -kNextWorkViewHeight, UIWIDTH, kNextWorkViewHeight);
        _alertView.backgroundColor = [UIColorUtil colorWithHexString:@"#00c300"];
        [self.view addSubview:_alertView];
        
        CGFloat titleW = 100;
        CGFloat titleH = _alertView.frame.size.height;
        CGFloat titleY = 0;
        CGFloat titleX = _alertView.frame.size.width/2 - titleW/2;

        UILabel *alertLab = [[UILabel alloc] init];
        alertLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
        alertLab.text = @"Well Done";
        alertLab.textColor = [UIColor whiteColor];
        alertLab.textAlignment = NSTextAlignmentCenter;
        alertLab.font = [UIFont fontWithName:Font_Medium size:13];
        [_alertView addSubview:alertLab];
    }
}

- (void)showUpdateSuccess
{
    [self initUpdateView];
    
    [UIView animateWithDuration:0.3 animations:^{
        _alertView.center = CGPointMake(UIWIDTH/2, kNextWorkViewHeight/2);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(removeAlertView) withObject:nil afterDelay:1];
    }];
}

- (void)removeAlertView
{
    [UIView animateWithDuration:0.3 animations:^{
        _alertView.center = CGPointMake(UIWIDTH/2, -kNextWorkViewHeight/2);
    } completion:^(BOOL finished) {
        [_alertView removeFromSuperview];
        _alertView = nil;
    }];
}
@end
