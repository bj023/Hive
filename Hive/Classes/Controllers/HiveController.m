//
//  HiveController.m
//  Hive
//
//  Created by BaoJun on 15/3/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "HiveController.h"
#import "Utils.h"
#import "MessageToolBar.h"
#import "ChatCell.h"


@interface HiveController ()<MessageToolBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    
}
@property (strong, nonatomic)MessageToolBar *chatToolBar;

@property (strong, nonatomic)UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *mesgaeArr;
@end

@implementation HiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configMessageArr];
    [self configTableView];
    [self configMessageToolBar];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configMessageArr
{
    self.mesgaeArr = [NSMutableArray array];
}

#pragma -mark 初始化 表格
- (void)configTableView
{
    if (!self.tableView) {
        CGRect frame = self.view.bounds;
        frame.size.height -= (64 + [MessageToolBar defaultHeight]);
        self.tableView                 = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate        = self;
        self.tableView.dataSource      = self;
        [self.view addSubview:self.tableView];
        
        [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)]];
    }
}

#pragma -mark MessageToolBar
- (void)configMessageToolBar
{
    if (!self.chatToolBar) {
        self.chatToolBar = [[MessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [MessageToolBar defaultHeight] - 64, self.view.frame.size.width, [MessageToolBar defaultHeight])];
        self.chatToolBar.delegate = self;
        self.chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.view addSubview:self.chatToolBar];
    }
}

#pragma -mark TableView 回调
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mesgaeArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ChatCell getChatCellHeight:self.mesgaeArr[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *cell = [ChatCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    [cell set_DataWithMessage:self.mesgaeArr[indexPath.row] show:indexPath.row%2 == 0];
    
    cell.longBlock = ^(NSIndexPath *indexpath){
        // 长按 头像手势
        debugLog(@"长按 头像手势");
        self.chatToolBar.inputTextView.text = @"@自定义";
    };
    
    return cell;
}

#pragma mark - MessageToolBarDelegate
- (void)inputTextViewWillBeginEditing:(MessageTextView *)messageInputTextView{
    //[_menuController setMenuItems:nil];
}

- (void)inputTextViewDidBeginEditing:(MessageTextView *)messageInputTextView
{

}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    CGRect rect = self.tableView.frame;
    rect.origin.y = 0;
    rect.size.height = self.view.frame.size.height - toHeight - [MessageToolBar defaultHeight] - 20;
    self.tableView.frame = rect;
    
    [self scrollViewToBottom:NO];
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self sendTextMessage:text];
    }
}

- (void)didSendFace:(NSString *)faceLocalPath
{
    debugMethod();
}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

-(void)sendTextMessage:(NSString *)textMessage
{
    
    [[XMPPManager sharedInstance] sendNewMessage:textMessage];
    
    [self.mesgaeArr addObject:textMessage];
    
    [self.tableView reloadData];

    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesgaeArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - GestureRecognizer
// 点击背景隐藏
-(void)keyBoardHidden
{
    [self set_HiddenKeyboard];
}

- (void)set_HiddenKeyboard
{
    [self.chatToolBar endEditing:YES];
}


- (void)showHudWith:(NSString *)text
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [MBProgressHUD showTextHUDAddedTo:self.view withText:text animated:YES];
}

- (void)dealloc
{
    self.chatToolBar = nil;
    self.tableView = nil;
    self.mesgaeArr = nil;
}
@end
