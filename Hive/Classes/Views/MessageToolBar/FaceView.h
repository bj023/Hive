//
//  FaceView.h
//  Hive
//
//  Created by mac on 15/4/6.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FaceDelegate;
@interface FaceView : UIView
@property (nonatomic, assign) id<FaceDelegate> delegate;

@end

@protocol FaceDelegate <NSObject>

@required
//- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete;
- (void)selectedFacialView:(NSString *)str;

@end