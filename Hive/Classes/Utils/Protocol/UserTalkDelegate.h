//
//  UserTalkDelegate.h
//  Hive
//
//  Created by 那宝军 on 15/5/8.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NearByModel.h"

@protocol UserTalkDelegate <NSObject>

- (void)clickTalkAction:(NearByModel *)model;

@end
