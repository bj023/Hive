//
//  MessagesController.m
//  Hive
//
//  Created by BaoJun on 15/3/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "MessagesController.h"
#import "MessageCell.h"
#import "Utils.h"
#import "ChatModel.h"
#import "SearchViewController.h"

@interface MessagesController ()<UITableViewDataSource, UITableViewDelegate, MessageCellDelegate>
{
    UITableViewController *_searchTVC;
    UISearchController *_searchController;
}


@property (strong, nonatomic) UITableView *messageTable;
@property (strong, nonatomic) NSMutableArray *messageArr;

@end

@implementation MessagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configMessageData];
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configMessageData
{
    self.messageArr = [NSMutableArray arrayWithArray:[ChatModel MR_findAll]];
    debugLog(@"%@",self.messageArr);
}

- (void)configSearchController
{
    
    _searchTVC = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    _searchTVC.tableView.delegate = self;
    _searchTVC.tableView.dataSource = self;
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchTVC];
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.placeholder = @"输入要查找的内容";
    _searchController.searchBar.prompt = @"查找";
    
    [self presentViewController:_searchController animated:YES completion:nil];
}

#pragma -mark 初始化 Message TableView
- (void)configTableView
{
    if (!self.messageTable) {
        CGRect frame = self.view.bounds;
        frame.size.height -= 64;
        self.messageTable                 = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.messageTable.backgroundColor = [UIColor clearColor];
        self.messageTable.separatorStyle  = UITableViewCellSeparatorStyleNone;
        self.messageTable.delegate        = self;
        self.messageTable.dataSource      = self;
        [self.view addSubview:self.messageTable];
    }
}

#pragma -mark TableView 回调
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MessageCell getMessageCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell set_MessageCellData:self.messageArr[indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.chatBlock(self.messageArr[indexPath.row]);
}

- (void)tapHeadImgSendAction:(ChatModel *)model
{
    //点击头像 查看个人信息
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpTool sendRequestProfileWithUserID:model.userID success:^(id json) {
        ResponseChatUserInforModel *res = [[ResponseChatUserInforModel alloc] initWithString:json error:nil];
        if (res.RETURN_CODE == 200) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            // 跳转
            self.messageBlock(res.RETURN_OBJ);
        }else
            [self showHudWith:ErrorRequestText];
        
    } faliure:^(NSError *error) {
        [self showHudWith:ErrorText];
    }];
}

- (void)showHudWith:(NSString *)text
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [MBProgressHUD showTextHUDAddedTo:self.view withText:text animated:YES];
}

#pragma -mark 长按 删除 回调
- (void)deleteMessageCellData:(NSIndexPath *)indexpath
{
    [self.messageArr removeObjectAtIndex:indexpath.row];
    [self.messageTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath]  withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma -mark 允许 Menu菜单
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//每个cell都会点击出现Menu菜单
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    MessageCell *cell = (MessageCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.indexPath = indexPath;
    return YES;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    debugMethod();
}

- (void)dealloc
{
    self.messageTable.delegate = nil;
    self.messageTable = nil;
}
@end
