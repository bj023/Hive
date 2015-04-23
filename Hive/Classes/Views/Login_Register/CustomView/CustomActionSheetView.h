//
//  CustomActionSheetView.h
//  Hive
//
//  Created by BaoJun on 15/3/30.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  自定义 ActionSheet
 */

typedef void(^ClickActionSheetAtIndex)(NSInteger index);

@interface CustomActionSheetView : UIView

@property (copy, nonatomic) ClickActionSheetAtIndex clickActionSheetAtIdex;

- (id)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles;

- (void)showWithBackgroundColor:(UIColor *)color;
@end
