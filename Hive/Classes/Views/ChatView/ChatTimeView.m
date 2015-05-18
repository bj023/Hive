//
//  ChatTimeView.m
//  Hive
//
//  Created by mac on 15/4/28.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ChatTimeView.h"
#import "Utils.h"

@interface ChatTimeView ()
{
    UILabel *_timeLabel;
}
@end

@implementation ChatTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColorUtil colorWithHexString:@"e8e8e8"];
    

    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_timeLabel];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat timeW = self.frame.size.width - 10;
    CGFloat timeH = 20;
    CGFloat timeY = 0;
    CGFloat timeX = self.frame.size.width/2 - timeW/2;
    _timeLabel.frame = CGRectMake(timeX, timeY, timeW, timeH);
    
}

- (void)setTime:(NSString *)time
{
    if (IsEmpty(time)) {
        return;
    }
    
    NSString * weekString = [UtilDate getWeekWithDate:time];
    NSString * month_day = [UtilDate dateFromString:time withFormat:DateFormat_MM_dd];
   _timeLabel.text = [NSString stringWithFormat:@"%@ %@",weekString,month_day];
}

@end
