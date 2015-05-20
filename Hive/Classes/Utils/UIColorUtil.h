//
//  UIColorUtil.h
//  Hive
//
//  Created by BaoJun on 15/3/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  十六进制字符 转换 颜色
 */
@interface UIColorUtil : NSObject
+(UIColor *) colorWithHexString: (NSString *) stringToConvert;
+(UIColor *) colorWithCode87b4d2;

+ (UIColor *)gradient:(double)percent
                  top:(double)topX
               bottom:(double)bottomX
                 init:(UIColor*)init
                 goal:(UIColor*)goal;

/**
 *  设置 列表 负标题
 *
 *  @return 返回指定颜色
 */
+ (UIColor *)colorWithCode888888;
/**
 *  设置 列表 横线
 *
 *  @return 返回指定颜色
 */
+ (UIColor *)colorWithCoded9d9d9;


/**
 *  注册 输入框值
 *
 *  @return 返回颜色值
 */
+ (UIColor *)colorWithCodea0a0a0;

/**
 *  图片转换成颜色
 *
 *  @param imgString 图片名称
 *
 *  @return 返回图片颜色
 */
+ (UIColor *)colorWithImgae:(NSString *)imgString;
@end
