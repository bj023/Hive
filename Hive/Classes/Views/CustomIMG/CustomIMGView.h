//
//  CustomIMGView.h
//  ZhiCai
//
//  Created by BaoJun on 15/3/23.
//  Copyright (c) 2015年 zhicai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  封装 IMG 下载图片
 */
@interface CustomIMGView : UIImageView

/**
 *  带默认图片 下载图片
 *
 *  @param urlStr      图片地址
 *  @param placeholder 默认图片
 */

- (void)setImageURLStr:(NSString *)urlStr
           placeholder:(UIImage *)placeholder;

/**
 *  不带默认图片 下载图片
 *
 *  @param urlStr 图片地址
 */
- (void)setImageURLStr:(NSString *)urlStr;
@end
