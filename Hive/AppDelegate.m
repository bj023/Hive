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

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:[NSString stringWithFormat:@"%@.sqlite", @"Wee"]];
    
    [self addSetRootViewControllerNotification];
    
    [self registerRemoteNotification];

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

    debugLog(@"notificationSettings->%@",[notificationSettings observationInfo]);
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    
    debugLog(@"userInfo->%@",userInfo);
    
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

#endif

//处理收到的消息推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    debugLog(@"userInfo->%@",userInfo);
    debugMethod();
}

#pragma mark - 实现远程推送需要实现的监听接口
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString* token = [NSString stringWithFormat:@"%@",deviceToken];
    NSLog(@"apns -> 生成的devToken:%@", token);
    NSString *devToken = [token substringWithRange:NSMakeRange(1, 71)];
    [UserDefaultsUtil setDeviceToken:devToken];
    
    if ([[UserInfoManager sharedInstance] checkUserIsLogin]) {
        [HttpTool sendRequestUpdateDeviceToken:devToken success:^(id json) {
            debugLog(@"更新Token成功");
        } faliure:^(NSError *error) {
            debugLog(@"更新Token失败");
        }];
    }
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
    
    if ([[UserInfoManager sharedInstance] checkUserIsLogin]) {
        [[XMPPManager sharedInstance] connect];
    }
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
        
        [[NSTimeUtil sharedInstance] startUpdatelocation];
        
        if ([[XMPPManager sharedInstance] connect]) {
            debugLog(@"XMPP连接成功");
        }else
            debugLog(@"XMPP连接失败");
        
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
