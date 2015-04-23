//
//  FaceView.h
//  Hive
//
//  Created by 那宝军 on 15/4/6.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FaceDelegate;
@interface FaceView : UIView
@property (nonatomic, assign) id<FaceDelegate> delegate;

- (BOOL)stringIsFace:(NSString *)string;

@end

@protocol FaceDelegate <NSObject>

@required
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete;

@end