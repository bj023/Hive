//
//  ChatBubbleView.h
//  Hive
//
//  Created by mac on 15/4/28.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMessage_Top 7.5
#define kMessage_Left 16

#define kMessage_Buttom 9
#define kMessage_Right 18



@interface ChatBubbleView : UIImageView

@property (nonatomic, strong)NSString *message;

@property (nonatomic, strong)UILabel *messageLabel;
@property (nonatomic, assign)BOOL isMe;

@end
