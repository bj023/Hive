//
//  CustomIMGView.m
//  ZhiCai
//
//  Created by BaoJun on 15/3/23.
//  Copyright (c) 2015年 zhicai. All rights reserved.
//

#import "CustomIMGView.h"
#import <UIImageView+WebCache.h>

@implementation CustomIMGView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.clipsToBounds          = YES;
        self.contentMode            = UIViewContentModeScaleAspectFill;
        // Initialization code
    }
    return self;
}

- (void)setImageUrl:(NSURL *)url placehoder:(UIImage *)placeholder
{
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

- (void)setImageUrl:(NSURL *)url
{
    [self sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

- (void)setImageURLStr:(NSString *)urlStr placeholder:(UIImage *)placeholder
{
    [self setImageUrl:[NSURL URLWithString:urlStr]  placehoder:placeholder];
}

- (void)setImageURLStr:(NSString *)urlStr
{
    [self setImageUrl:[NSURL URLWithString:urlStr]];
}
@end
