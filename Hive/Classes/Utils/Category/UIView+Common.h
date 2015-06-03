//
//  UIView+Common.h
//  Hive
//
//  Created by mac on 15/4/20.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EaseBlankPageView;

typedef NS_ENUM(NSInteger, EaseBlankPageType)
{
    EaseBlankPageTypeView = 0,
    EaseBlankPageTypeActivity,
    EaseBlankPageTypeTask,
    EaseBlankPageTypeTopic,
    EaseBlankPageTypeTweet,
    EaseBlankPageTypeTweetOther,
    EaseBlankPageTypeProject,
    EaseBlankPageTypeFileDleted,
    EaseBlankPageTypeFolderDleted
};

@interface UIView (Common)

#pragma mark BlankPageView
@property (strong, nonatomic) EaseBlankPageView *blankPageView;
- (void)configBlankPage:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;

@end


@interface EaseBlankPageView : UIView
@property (strong, nonatomic) UIImageView *monkeyView;
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) UIButton *reloadButton;
@property (copy, nonatomic) void(^reloadButtonBlock)(id sender);
- (void)configWithType:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;
@end
