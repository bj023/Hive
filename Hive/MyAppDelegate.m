//
//  MyAppDelegate.m
//  Hive
//
//  Created by mac on 15/5/13.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "MyAppDelegate.h"
#import <Reachability.h>


@implementation MyAppDelegate

// MyAppDelegate.m
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    switch (status)
    {
        case NotReachable:
            // 没有网络连接
            NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            NSLog(@"正在使用wifi网络");
            break;
    }
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
}


+ (BOOL)Request3G
{
    BOOL GetMy3G = NO;
    //监测网络
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus])
    {
        case NotReachable:
            // 没有网络连接
            NSLog(@"没有网络");
            GetMy3G = NO;
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            NSLog(@"正在使用3G网络");
            GetMy3G = YES;
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            NSLog(@"正在使用wifi网络");
            GetMy3G = YES;
            break;
    }
    return GetMy3G;
}
@end
