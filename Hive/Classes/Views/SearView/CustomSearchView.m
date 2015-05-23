//
//  CustomSearchView.m
//  Hive
//
//  Created by 那宝军 on 15/5/23.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "CustomSearchView.h"
#import "Utils.h"
#import "MessageCell.h"

#define kSearchViewHeight 44

@interface CustomSearchView ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MessageCellDelegate>
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITableView *resultTable;
@property (nonatomic, strong) NSMutableArray *resultArray;

@end

@implementation CustomSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initTableView];
    }
    return self;
}

- (void)initView
{
    if (!self.searchView) {
        self.searchView = [[UIView alloc] init];
        self.searchView.frame = CGRectMake(0, 0, UIWIDTH, kSearchViewHeight);
        self.searchView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.searchView];
        CGFloat y = 7;
        CGRect frame = CGRectMake(10, y, UIWIDTH - 100, kSearchViewHeight - 2 * y);
        UITextField *searBar = [[UITextField alloc] initWithFrame:frame];
        searBar.backgroundColor = [UIColor clearColor];
        searBar.borderStyle = UITextBorderStyleRoundedRect;
        //UIColor *color = [UIColorUtil colorWithHexString:@"#eeeeee"];
        searBar.placeholder = @"Search";
        searBar.delegate = self;
        searBar.returnKeyType = UIReturnKeySearch;
        [self.searchView addSubview:searBar];
        [searBar becomeFirstResponder];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(UIWIDTH - 90, y, 80, frame.size.height);
        [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.searchView addSubview:cancelBtn];
    }
}

- (void)clickCancelBtn:(id)sender
{
    [self removeSearchView];
}


- (void)initTableView
{
    if (!self.resultTable) {
        CGRect frame = CGRectMake(0, _searchView.frame.size.height + 20, UIWIDTH, UIHEIGHT - kSearchViewHeight - 20);
        self.resultTable = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.resultTable.delegate = self;
        self.resultTable.dataSource = self;
        [self addSubview:self.resultTable];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MessageCell getMessageCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell set_MessageCellData:(_resultArray[indexPath.row])];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(clickSerchChatSearView:ChatMessageModel:)]) {
        [self.delegate clickSerchChatSearView:self ChatMessageModel:_resultArray[indexPath.row]];
    }
}

- (void)tapHeadImgSendAction:(MessageModel *)model
{
    if ([self.delegate respondsToSelector:@selector(clickSearchHeadImg:ChatMessageModel:)]) {
        [self.delegate clickSearchHeadImg:self ChatMessageModel:model];
    }
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //[[UINavigationBar appearance] setTintColor:[UIColorUtil colorWithHexString:@"#eeeeee"]];
    //[[UINavigationBar appearance] setBarTintColor:[UIColorUtil colorWithHexString:@"#eeeeee"]];

    //self.searchView.center = CGPointMake(UIWIDTH/2, kSearchViewHeight + 44);
    [UIView animateWithDuration:0.3 animations:^{
        self.searchView.center = CGPointMake(UIWIDTH/2, kSearchViewHeight);
    }];
}

- (void)dismiss
{
    [self removeSearchView];
}

- (void)removeSearchView
{
    [self endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        //self.searchView.center = CGPointMake(UIWIDTH/2, kSearchViewHeight + 44);
        self.searchView.center = CGPointMake(UIWIDTH/2, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //debugLog(@"%@",string);
    debugLog(@"%ld",range.location);

    // 1. 获取输入的值
    NSString *conditionStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
    // 2. 创建谓词，准备进行判断的工具
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"toUserName CONTAINS [CD] %@ OR msg_content CONTAINS [CD] %@", conditionStr, conditionStr];
    // 3. 使用工具获取匹配出的结果
    self.resultArray = [NSMutableArray arrayWithArray:[_dataSourceArray filteredArrayUsingPredicate:predicate]];
    [self.resultTable reloadData];
    return YES;
}
@end
