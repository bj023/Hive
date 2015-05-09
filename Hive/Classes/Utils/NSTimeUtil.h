//
//  NSTimeUtil.h
//  Hive
//
//  Created by 那宝军 on 15/4/24.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSTimeUtil : NSObject

+ (NSTimeUtil *)sharedInstance;

- (BOOL)locationAuthorizationStatus;

- (void)startUpdatelocation;

- (NSString *)getCoordinateLatitude;

- (NSString *)getCoordinateLongitude;

- (NSArray *)getChatUserIDs;

+ (NSString *)getDistance:(NSString *)longitude latitude:(NSString *)latitude;

@end
