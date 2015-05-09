//
//  DataBaseModel.h
//  Hive
//
//  Created by 那宝军 on 15/4/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseModel : NSObject

+ (NSPredicate *)predicateForStart:(NSInteger )start
                          andCount:(NSInteger)count;
+ (NSArray *)NSManagedObject:(Class)manager
                   findStart:(NSInteger)start
                    andCount:(NSInteger)count;

@end
