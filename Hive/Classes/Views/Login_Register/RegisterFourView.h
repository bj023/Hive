//
//  RegisterFourView.h
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "BaseView.h"

/**
 *  注册第四步 年龄 - 性别 - 头像
 */

typedef void (^Block)(NSString *str);

@interface RegisterFourView : BaseView
@property (nonatomic, copy)NSString *nameString;
@property (nonatomic, copy)Block block;

- (void)become_FirstResponder;
/**
 *  选择头像后 重新设置头像
 *
 *  @param image Imgae
 */
- (void)setHeadImgae:(UIImage *)image;
@end
