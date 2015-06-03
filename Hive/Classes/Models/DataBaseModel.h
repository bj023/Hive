//
//  DataBaseModel.h
//  Hive
//
//  Created by mac on 15/4/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DataShareInstance [DataBaseModel shareInstance]

@interface DataBaseModel : NSObject

+ (DataBaseModel *)shareInstance;

- (NSArray *)getChatsCount:(NSInteger)count;

@end
