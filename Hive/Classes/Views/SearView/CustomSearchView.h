//
//  CustomSearchView.h
//  Hive
//
//  Created by 那宝军 on 15/5/23.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageModel;
@protocol CustomSearchDelegate;
@interface CustomSearchView : UIView
@property (nonatomic, weak)id<CustomSearchDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

- (void)show;
- (void)dismiss;

@end

@protocol CustomSearchDelegate <NSObject>

- (void)clickSearchHeadImg:(CustomSearchView *)searView ChatMessageModel:(MessageModel *)model;

- (void)clickSerchChatSearView:(CustomSearchView *)searView ChatMessageModel:(MessageModel*)model;

@end