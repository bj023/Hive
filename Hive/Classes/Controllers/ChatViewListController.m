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
        _topView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableHeaderView = _topView;
        
        UIButton *searBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searBtn.frame = CGRectMake(25/2 , 9, UIWIDTH - 25, 26);
        searBtn.backgroundColor = [UIColorUtil colorWithHexString:@"#eeeeee"];
        searBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        searBtn.layer.cornerRadius = 5;
        [searBtn setTitle:@"Search for people and messages" forState:UIControlStateNormal];
        [searBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [searBtn addTarget:self action:@selector(searchBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:searBtn];
                
        /* */
        CGSize size = [UILabel sizeWithString:@"Search for people and messages" font:searBtn.titleLabel.font maxSize:CGSizeMake(MAXFLOAT, searBtn.frame.size.height)];
        CGFloat w = 13;
        CGFloat h = w;
        CGFloat y = _topView.frame.size.height/2 - h/2;
        CGFloat x = _topView.frame.size.width/2 - w/2 - size.width/2 - 3;
        UIImageView *searchIMG = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        searchIMG.backgroundColor = [UIColor clearColor];
        searchIMG.alpha = 0.7;
        searchIMG.image = [UIImage imageNamed:@"searchIMG"];
        [_topView addSubview:searchIMG];
        
        searBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -w-3);
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
    NSString *userID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
    return [NSMutableArray arrayWithArray:[MessageModel MR_findByAttribute:@"cur_userID" withValue:userID andOrderBy:@"msg_time" ascending:NO]];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    //MessageModel *model = _dataSource[indexPath.row];
    self.chatBlock(_dataSource[indexPath.row]);
}

- (void)tapHeadImgSendAction:(MessageModel *)model
{
    //点击头像 查看个人信息
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpTool sendRequestProfileWithUserID:model.toUserID success:^(id json) {
        ResponseChatUserInforModel *res = [[ResponseChatUserInforModel alloc] initWithString:json error:nil];
        if (res.RETURN_CODE == 200) {
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
