//
//  GPLoadingButton.h
//  GPLoadingView
//
//  Created by crazypoo on 14/7/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPLoadingButton : UIButton
@property (nonatomic, strong) NSMutableArray *activityViewArray;
@property (nonatomic, strong) UIColor *rotatorColor;
@property (nonatomic, assign) CGFloat *rotatorSize;
@property (nonatomic, assign) CGFloat *rotatorSpeed;
@property (nonatomic, assign) CGFloat *rotatorPadding;
@property (nonatomic, strong) NSString *defaultTitle;
@property (nonatomic, strong) NSString *activityTitle;
-(void)startActivity;
-(void)stopActivity;
@end
