//
//  UILabel+Size.m
//  Hive
//
//  Created by BaoJun on 15/4/3.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "UILabel+Size.h"
#import "Utils.h"

@implementation UILabel (Size)
/**
 *  计算文本的宽度
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    if (IsEmpty(str)) {
        return CGSizeMake(0, 0);
    }
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超过了指定的范围，返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围，返回的就是真实的范围
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}
@end
