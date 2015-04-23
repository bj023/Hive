//
//  CustomButtonView.h
//  Hive
//
//  Created by BaoJun on 15/4/2.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomButtonViewDelegate;
@interface CustomButtonView : UIView

@property (nonatomic, weak)id<CustomButtonViewDelegate>delegate;

- (void)set_DataFollow:(int)follow;
- (void)set_DataBlock:(int)block;

@end

@protocol CustomButtonViewDelegate <NSObject>

- (void)clickButtonWithIndex:(NSInteger)index;
@end
