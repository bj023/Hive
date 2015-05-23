//
//  ChatViewListController.m
//  Hive
//
//  Created by 那宝军 on 15/5/20.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ChatViewListController.h"
#import "Utils.h"
#import "MessageModel.h"
#import "NearByModel.h"
#import "MessageCell.h"
#import "CustomSearchView.h"

@interface ChatViewListController ()<UITableViewDataSource, UITableViewDelegate, MessageCellDelegate,CustomSearchDelegate>
@property (strong, nonatomic) NSMutableArray        *dataSource;
@property (strong, nonatomic) UITableView           *tableView;
@property (strong, nonatomic) UIView *topView;

@end

@implementation ChatViewListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    [self refreshDataSource];
    [self configSearch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configSearch
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWIDTH, 44)];
        _topView.backgroundColor = [UIColorUtil colorWithHexString:@"#eeeeee"];
        self.tableView.tableHeaderView = _topView;
        
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
}

- (void)searchBarButtonItemAction:(id)sender
{
    CustomSearchView *searchView = [[CustomSearchView alloc] initWithFrame:self.view.bounds];
    searchView.dataSourceArray = [NSMutableArray arrayWithArray:self.dataSource];
    searchView.delegate = self;
    [searchView show];
}
// CustomSearchView 代理 回调
- (void)clickSerchChatSearView:(CustomSearchView *)searView ChatMessageModel:(MessageModel *)model
{
    [searView dismiss];
    self.chatBlock(model);
}

- (void)clickSearchHeadImg:(CustomSearchView *)searView ChatMessageModel:(MessageModel *)model
{
    [searView dismiss];
    [self tapHeadImgSendAction:model];
}

- (void)refreshDataSource
{
    self.dataSource = [self loadDataSource];
    [_tableView reloadData];
}

- (NSMutableArray *)loadDataSource
{
    return [NSMutableArray arrayWithArray:[MessageModel MR_findAllSortedBy:@"msg_time" ascending:NO]];
}


#pragma -mark 初始化 Message TableView
- (void)configTableView
{
    _dataSource = [NSMutableArray array];
    if (!self.tableView) {
        CGRect frame = self.view.bounds;
        frame.size.height -= 64;
        self.tableView                 = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate        = self;
        self.tableView.dataSource      = self;
        [self.view addSubview:self.tableView];
    }
}

#pragma -mark TableView 回调
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
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
    [cell set_MessageCellData:(_dataSource[indexPath.row])];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    //MessageModel *model = _dataSource[indexPath.row];
    self.chatBlock(_dataSource[indexPath.row]);
}

- (void)tapHeadImgSendAction:(MessageModel *)model
{
    //点击头像 查看个人信息
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpTool sendRequestProfileWithUserID:model.toUserID success:^(id json) {
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
@end
