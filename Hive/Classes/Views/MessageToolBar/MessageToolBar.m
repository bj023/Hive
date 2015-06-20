//
//  MessageToolBar.m
//  Hive
//
//  Created by mac on 15/4/6.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "MessageToolBar.h"
#import "Utils.h"
#import "FaceView.h"
#import "DXChatBarMoreView.h"

@interface MessageToolBar ()<UITextViewDelegate, FaceDelegate>
{
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
}

/**
 *  按钮、输入框、toolbarView
 */
@property (strong, nonatomic) UIView *toolbarView;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UIButton *faceButton;

/**
 *  底部扩展页面
 */
@property (nonatomic) BOOL isShowButtomView;
@property (strong, nonatomic) UIView *activityButtomView;//当前活跃的底部扩展页面


@end

@implementation MessageToolBar

- (id)initWithFrame:(CGRect)frame isPulicChat:(BOOL)isShow;
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupConfig];
        [self setupSubviews:isShow];
    }
    return self;
}

- (void)setupConfig
{
    // 初始化
    self.activityButtomView = nil;
    self.isShowButtomView = NO;
    
    self.maxTextInputViewHeight = kInputTextViewMaxHeight;
    
    if (!self.toolbarView) {
        self.toolbarView = [[UIView alloc] init];
        //self.toolbarView.backgroundColor = [UIColorUtil colorWithHexString:@"f5f5f5"];
        self.toolbarView.backgroundColor = [UIColor clearColor];
        self.toolbarView.layer.borderColor = [UIColorUtil colorWithHexString:@"#c8c8c8"].CGColor;
        self.toolbarView.frame = CGRectMake(0, 0, self.frame.size.width, kVerticalPadding * 2 + kInputTextViewMinHeight);
        [self addSubview:self.toolbarView];
        
        
        UIImageView *lineIMG = [[UIImageView alloc] init];
        lineIMG.frame = CGRectMake(0, 0, UIWIDTH, 1);
        lineIMG.backgroundColor = kRegisterLineColor;
        [self.toolbarView addSubview:lineIMG];
    }
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupSubviews:(BOOL)isShow
{
    CGFloat allButtonWidth = 0.0;
    CGFloat textViewLeftMargin = 25/2;
    
    CGFloat faceW = isShow?24:24;//24
    CGFloat faceH = faceW;
    CGFloat faceY = CGRectGetHeight(self.bounds)/2 - 24/2;
    
    //表情
    if (!self.faceButton) {
        self.faceButton = [[UIButton alloc] initWithFrame:CGRectMake(textViewLeftMargin, faceY, faceW, faceH)];
        self.faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self.faceButton setImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        [self.faceButton setImage:[UIImage imageNamed:@"face"] forState:UIControlStateHighlighted];
        [self.faceButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
        [self.faceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.faceButton.tag = 1;
    }
    
    
    CGFloat sendW = 60;
    if (!self.sendButton) {
        self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - kHorizontalPadding - sendW, kVerticalPadding, sendW, kInputTextViewMinHeight)];
        self.sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
        [self.sendButton setTitleColor:kRegisterTextTintColor forState:UIControlStateNormal];
        self.sendButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:34/2];
        [self.sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        //self.sendButton.enabled = NO;
        self.sendButton.tag = 2;
    }
    
    allButtonWidth += CGRectGetWidth(self.faceButton.frame) + kHorizontalPadding * 2;
    // 输入框的高度和宽度
    CGFloat width = CGRectGetWidth(self.bounds) - (allButtonWidth ? allButtonWidth : (textViewLeftMargin * 2) )- sendW - kVerticalPadding;
    CGFloat textX = textViewLeftMargin + CGRectGetMaxX(self.faceButton.frame);
    // 初始化输入框
    
    if (!self.inputTextView) {
        self.inputTextView = [[MessageTextView  alloc] initWithFrame:CGRectMake(textX, kVerticalPadding, width, kInputTextViewMinHeight)];
        self.inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.inputTextView.scrollEnabled = YES;
        self.inputTextView.returnKeyType = UIReturnKeySend;
        self.inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
        self.inputTextView.placeHolder = @"Write here ...";
        self.inputTextView.delegate = self;
        self.inputTextView.backgroundColor = [UIColor whiteColor];
        //self.inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        //self.inputTextView.layer.borderWidth = 0.65f;
        //self.inputTextView.layer.cornerRadius = 6.0f;
    }
    _previousTextViewContentHeight = [self getTextViewContentH:_inputTextView];
    
    if (!self.faceView) {
        self.faceView = [[FaceView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), self.frame.size.width, 216)];
        [(FaceView *)self.faceView setDelegate:self];
        self.faceView.backgroundColor = [UIColor whiteColor];
        self.faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    
    if (!self.moreView) {
        self.moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), self.frame.size.width, 216) typw:ChatMoreTypeChat];
        self.moreView.backgroundColor = [UIColor whiteColor];
        self.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    [self.toolbarView addSubview:self.faceButton];
    [self.toolbarView addSubview:self.inputTextView];
    [self.toolbarView addSubview:self.sendButton];
}

- (void)setMaxTextInputViewHeight:(CGFloat)maxTextInputViewHeight
{
    if (maxTextInputViewHeight > kInputTextViewMaxHeight) {
        maxTextInputViewHeight = kInputTextViewMaxHeight;
    }
    _maxTextInputViewHeight = maxTextInputViewHeight;
}

#pragma -mark 按钮点击事件
- (void)buttonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    switch (sender.tag) {
        case 1://表情
        {
            if (sender.selected) {
                [self.inputTextView resignFirstResponder];
                
                [self willShowBottomView:self.faceView];
                
            } else {
                [self.inputTextView becomeFirstResponder];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)sendButtonAction:(UIButton *)sender
{
    /*
    if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
        [self.delegate didSendText:self.inputTextView.text];
        self.inputTextView.text = @"";
        [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];
    }
     */
    [self.inputTextView resignFirstResponder];
    [self willShowBottomView:self.moreView];
}

#pragma mark - UIKeyboardNotification
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)() = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}
#pragma mark - change frame

- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
    if(bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height)
    {
        return;
    }
    
    if (bottomHeight == 0) {
        self.isShowButtomView = NO;
    }
    else{
        self.isShowButtomView = YES;
    }
    
    self.frame = toFrame;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
        [_delegate didChangeFrameToHeight:toHeight];
    }
}

- (void)willShowBottomView:(UIView *)bottomView
{
    if (![self.activityButtomView isEqual:bottomView]) {
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self willShowBottomHeight:bottomHeight];
        
        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
        }
        
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = bottomView;
    }
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        //一定要把self.activityButtomView置为空
        [self willShowBottomHeight:toFrame.size.height];
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    }
    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        // 隐藏
        [self willShowBottomHeight:0];
    }
    else{
        [self willShowBottomHeight:toFrame.size.height];
    }
}


- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < kInputTextViewMinHeight) {
        toHeight = kInputTextViewMinHeight;
    }
    if (toHeight > self.maxTextInputViewHeight) {
        toHeight = self.maxTextInputViewHeight;
    }
    
    if (toHeight == _previousTextViewContentHeight)
    {
        
        return;
    } else {
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.toolbarView.frame;
        rect.size.height += changeHeight;
        self.toolbarView.frame = rect;
        
        _previousTextViewContentHeight = toHeight;
        
        if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
            [_delegate didChangeFrameToHeight:self.frame.size.height];
        }
    }
}

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    return ceilf([textView sizeThatFits:textView.frame.size].height);
    //return textView.contentSize.height;
}

#pragma -mark TextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    
    self.faceButton.selected = NO;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@""])//如果string是空白
    {
        if (self.aNameLength > range.location) {
            self.inputTextView.text = @"";
            self.aNameLength = 0;
        }
    }
    
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:textView.text];
            self.inputTextView.text = @"";
            [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];
        }
        
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
}

#pragma mark - FaceDelegate

- (void)selectedFacialView:(NSString *)str
{
    if ([self.delegate respondsToSelector:@selector(didSendFace:)]) {
        [self.delegate didSendFace:str];
    }
    
    //NSString *chatText = self.inputTextView.text;
    //[self textViewDidChange:self.inputTextView];
}

- (void)sendFace
{
    NSString *chatText = self.inputTextView.text;
    if (chatText.length > 0) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:chatText];
            self.inputTextView.text = @"";
            [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
        }
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    _inputTextView.delegate = nil;
    _inputTextView = nil;
    _delegate = nil;
    self.faceButton = nil;
    self.faceView = nil;
    self.sendButton = nil;
    self.toolbarView = nil;
    self.activityButtomView = nil;
}

+ (CGFloat)defaultHeight
{
    return kVerticalPadding * 2 + kInputTextViewMinHeight;
}

#pragma mark - public

/**
 *  停止编辑
 */
- (BOOL)endEditing:(BOOL)force
{
    BOOL result = [super endEditing:force];
    
    self.faceButton.selected = NO;
    [self willShowBottomView:nil];
    return result;
}
@end
