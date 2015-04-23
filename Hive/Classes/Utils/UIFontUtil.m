//
//  UIFontUtil.m
//  x_app
//
//  Created by howaylee on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIFontUtil.h"

@implementation UIFontUtil
+(UIFont *) size12{
    return [UIFont fontWithName:@"Helvetica" size:12];  
}
+(UIFont *) size13{
    return [UIFont fontWithName:@"Helvetica" size:13];    
}
+(UIFont *) size14{
    return [UIFont fontWithName:@"Helvetica" size:14];    
}
+(UIFont *) size15{
    return [UIFont fontWithName:@"Helvetica" size:15];    
}

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
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超过了指定的范围，返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围，返回的就是真实的范围
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}
@end
