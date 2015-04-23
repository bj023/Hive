//
//  UIFontUtil.h
//  x_app
//
//  Created by howaylee on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  返回指定大小字体
 */
@interface UIFontUtil : NSObject
+(UIFont *) size12;
+(UIFont *) size13;
+(UIFont *) size14;
+(UIFont *) size15;

/**
 *  计算文本的宽度
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;
@end
