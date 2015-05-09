//
//  ChatBubbleView.h
//  Hive
//
//  Created by 那宝军 on 15/4/28.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMessage_Top 8
#define kMessage_Left 20

@interface ChatBubbleView : UIImageView

@property (nonatomic, strong)NSString *message;

@property (nonatomic, assign)BOOL isMe;

@end
