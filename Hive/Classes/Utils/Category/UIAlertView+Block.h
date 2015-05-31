//
//  UIAlertView+Block.h
//  Hive
//
//  Created by 那宝军 on 15/5/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Block)
-(void) handlerClickedButton:(void (^)(NSInteger btnIndex))aBlock; 
@end
