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

@interface MessagesController ()<UITableViewDataSource, UITableViewDelegate, MessageCellDelegate ,UISearchResultsUpdating, UISearchBarDelegate>
{
    UIView *_topView;
}

@property (strong, nonatomic) UITableView *messageTable;
@property (strong, nonatomic) NSMutableArray *messageArr;

@property (nonatomic, retain) NSMutableArray *searchResultDataArray;            // 存放搜索出结果的数组
@property (nonatomic, retain) UISearchController *searchController;             // 搜索控制器
@property (nonatomic, retain) UITableViewController *searchTVC;                 // 搜索使用的表示图控制器
@end

@implementation MessagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configMessageData];
    [self configTableView];
    [self configSearBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)configSearBtn
{
    /* */
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWIDTH, 44)];
    _topView.backgroundColor = [UIColorUtil colorWithHexString:@"#eeeeee"];
    self.messageTable.tableHeaderView = _topView;
    
    UIButton *searBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searBtn.frame = CGRectMake(8 , 7, UIWIDTH - 16, 30);
    searBtn.backgroundColor = [UIColor whiteColor];
    searBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    searBtn.layer.cornerRadius = 5;
    [searBtn setTitle:@"Search" forState:UIControlStateNormal];
    [searBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [searBtn addTarget:self action:@selector(searchBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:searBtn];
}

#pragma mark 搜索按钮事件（点击搜索按钮，推出搜索控制器）
- (void)searchBarButtonItemAction:(id)sender
{
    // 创建出搜索使用的表示图控制器
    self.searchTVC = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    _searchTVC.tableView.dataSource = self;
    _searchTVC.tableView.delegate = self;
    
    // 使用表示图控制器创建出搜索控制器
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:_searchTVC];
    // 搜索框检测代理
    //（这个需要遵守的协议是 <UISearchResultsUpdating> ，这个协议中只有一个方法，当搜索框中的值发生变化的时候，代理方法就会被调用）
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.placeholder = @"输入要查找的内容";
    _searchController.searchBar.prompt = @"Search";
    _searchController.searchBar.delegate = self;
    // 因为搜索是控制器，所以要使用模态推出（必须是模态，不可是push）
    [self presentViewController:_searchController animated:YES completion:nil];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    //_topView.frame = CGRectMake(0, 0, UIWIDTH, 44);
    [self configSearBtn];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    //_topView.frame = CGRectMake(0, 0, UIWIDTH, 0);
    [_topView removeFromSuperview];
}

- (void)configMessageData
{
    self.messageArr = [NSMutableArray arrayWithArray:[ChatModel MR_findAll]];
    debugLog(@"%@",self.messageArr);
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
    return (tableView == self.messageTable ? _messageArr.count : _searchResultDataArray.count);

    //return self.messageArr.count;
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
    [cell set_MessageCellData:(tableView == self.messageTable?self.messageArr[indexPath.row]:self.searchResultDataArray[indexPath.row])];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [_searchController dismissViewControllerAnimated:NO completion:nil];

    self.chatBlock((tableView == self.messageTable?self.messageArr[indexPath.row]:self.searchResultDataArray[indexPath.row]));
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

#pragma mark - UISearchResultsUpdating Method
#pragma mark 监听者搜索框中的值的变化
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    // 1. 获取输入的值
    NSString *conditionStr = searchController.searchBar.text;
    // 2. 创建谓词，准备进行判断的工具
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName CONTAINS [CD] %@ OR message CONTAINS [CD] %@", conditionStr, conditionStr];
    
    // 3. 使用工具获取匹配出的结果
    self.searchResultDataArray = [NSMutableArray arrayWithArray:[_messageArr filteredArrayUsingPredicate:predicate]];

    // 4. 刷新页面，将结果显示出来
    [_searchTVC.tableView reloadData];
}

#pragma mark - UISearchControllDelegate Method

- (void)dealloc
{
    self.messageTable.delegate = nil;
    self.messageTable = nil;
}
@end
