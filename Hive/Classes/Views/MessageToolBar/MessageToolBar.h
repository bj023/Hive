//
//  MessageToolBar.h
//  Hive
//
//  Created by 那宝军 on 15/4/6.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageTextView.h"

#define kInputTextViewMinHeight 36
#define kInputTextViewMaxHeight 200
#define kHorizontalPadding 8
#define kVerticalPadding 5

@protocol MessageToolBarDelegate;
@interface MessageToolBar : UIView
/**
 *  用于输入文本消息的输入框
 */
@property (strong, nonatomic) MessageTextView *inputTextView;
@property (nonatomic, weak) id <MessageToolBarDelegate> delegate;

@property (strong, nonatomic) UIView *faceView;


@property (assign, nonatomic) NSInteger aNameLength;
/**
 *  文字输入区域最大高度，必须 > KInputTextViewMinHeight(最小高度)并且 < KInputTextViewMaxHeight，否则设置无效
 */
@property (nonatomic) CGFloat maxTextInputViewHeight;

+ (CGFloat)defaultHeight;
@end

@protocol MessageToolBarDelegate <NSObject>

/**
 *  文字输入框开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(MessageTextView *)messageInputTextView;

/**
 *  文字输入框将要开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(MessageTextView *)messageInputTextView;

/**
 *  发送文字消息，可能包含系统自带表情
 *
 *  @param text 文字消息
 */
- (void)didSendText:(NSString *)text;

/**
 *  发送第三方表情，不会添加到文字输入框中
 *
 *  @param faceLocalPath 选中的表情的本地路径
 */
- (void)didSendFace:(NSString *)faceLocalPath;

@required
/**
 *  高度变到toHeight
 */
- (void)didChangeFrameToHeight:(CGFloat)toHeight;

@end