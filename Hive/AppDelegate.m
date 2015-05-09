//
//  AppDelegate.m
//  Hive
//
//  Created by BaoJun on 15/3/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColorUtil.h"
#import "ViewController.h"
#import "LoginController.h"
#import "Utils.h"
#import "XMPPManager.h"
#import "NSTimeUtil.h"

#define UIWIDTH [UIScreen mainScreen].bounds.size.width
#define UIHEIGHT [UIScreen mainScreen].bounds.size.height

@interface AppDelegate ()<UIScrollViewDelegate>
{
    UIView *view;
    NSInteger _pageNumber;
    NSInteger _currentPage;
}
@end

@implementation AppDelegate

#pragma mark --开始引导页--
-(void)guideStart
{
    //引导页图片列表
    NSArray *arr=[NSArray arrayWithObjects:@"1.png",@"2.png",@"3-bg.png", nil];
    _pageNumber = [arr count];
    
    //view设置
    view=[[UIView alloc]initWithFrame:self.window.bounds];
    [self.window addSubview:view];
    int height=view.frame.size.height;
    int width=view.frame.size.width;
    //添加scrollView
    UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:view.bounds];
    scroll.contentSize=CGSizeMake(width*_pageNumber, height);
    for (int i=0; i<_pageNumber; i++) {
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(width*i, 0, width, height)];
        [img setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[arr objectAtIndex:i] ofType:nil]]];
        [scroll addSubview:img];
        if (i==_pageNumber-1) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:[UIImage imageNamed:@"3-bt.png"] forState:UIControlStateNormal];
            btn.frame=CGRectMake(UIWIDTH/2 - 70, UIHEIGHT - 84, 140, 44);
            [btn addTarget:self action:@selector(startApp) forControlEvents:UIControlEventTouchUpInside];
            [img addSubview:btn];
            img.userInteractionEnabled=YES;
        }
    }
    scroll.delegate=self;
    scroll.pagingEnabled=YES;
    scroll.showsHorizontalScrollIndicator=NO;
    [view addSubview:scroll];
}

#pragma mark --引导页代理--
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    scrollView.contentOffset=CGPointMake(page*scrollView.frame.size.width, 0);
    _currentPage=page;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_currentPage==_pageNumber-1 && scrollView.contentOffset.x>scrollView.frame.size.width*(_pageNumber-1)) {
        [self startApp];
    }
}

-(void)startApp
{
    [view removeFromSuperview];
    [UserDefaultsUtil setUserDefaultsFirstUse];
    [self setRootViewController];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:[NSString stringWithFormat:@"%@.sqlite", @"Wee"]];
    
    [self addSetRootViewControllerNotification];
    
    [self registerRemoteNotification];
    
    [[NSTimeUtil sharedInstance] startUpdatelocation];

    /*
    if ([UserDefaultsUtil iSFirstUse])
        [self guideStart];
    else
        [self setRootViewController];
     */
    [self setRootViewController];
    
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma -mark 注册通知
- (void)registerRemoteNotification
{
#if !TARGET_IPHONE_SIMULATOR
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

#ifdef __IPHONE_8_0
//ios8需要调用内容
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

#pragma mark - 实现远程推送需要实现的监听接口
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString* token = [NSString stringWithFormat:@"%@",deviceToken];
    debugLog(@"apns -> 生成的devToken:%@", token);
}

#pragma mark - 接收注册推送通知功能时出现的错误，并做相关处理
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    debugLog(@"apns -> 注册推送功能时发生错误， 错误信息:\n %@", err);
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[XMPPManager sharedInstance] disconnect];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[XMPPManager sharedInstance] connect];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [MagicalRecord cleanUp];
}

#pragma -mark 监听是否改变主控制器
- (void)addSetRootViewControllerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRootViewController) name:@"setRootViewController" object:nil];
}

#pragma - mark 设置 RootViewController
- (void)setRootViewController
{
    if (![[UserInfoManager sharedInstance] checkUserIsLogin]) {
        // 未登陆状态
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        LoginController *vc = [[LoginController alloc] init];
        self.window.rootViewController = vc;
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UserInfoManager sharedInstance] loadUserInfoFromDisk];
        if ([XMPPManager sharedInstance].connect) {
            debugLog(@"连接成功");
        }else
            debugLog(@"连接失败");
        
        // 已经登陆过需要自动登陆
        ViewController *vc = [[ViewController alloc] init];
        vc.view.backgroundColor = [UIColor whiteColor];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
