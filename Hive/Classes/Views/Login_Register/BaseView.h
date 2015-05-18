//
//  BaseView.h
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

- (void)navBackAction:(UIButton *)sender;
- (void)navNextAction:(UIButton *)sender;

- (void)setNavNextBtnTitle:(NSString *)title;

- (void)hiddenNavBackBtn:(BOOL)hidden;
@end
