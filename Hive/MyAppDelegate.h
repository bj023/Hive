//
//  MyAppDelegate.h
//  Hive
//
//  Created by mac on 15/5/13.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@class Reachability;
@interface MyAppDelegate : NSObject <UIApplicationDelegate>
{
    Reachability  *hostReach;
}

@end
