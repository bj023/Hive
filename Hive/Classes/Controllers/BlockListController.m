//
//  BlockListController.m
//  Hive
//
//  Created by mac on 15/4/11.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "BlockListController.h"
#import "Utils.h"
#import "NearByCell.h"
#import "UserInformationController.h"

@interface BlockListController ()<UITableViewDataSource, UITableViewDelegate, UserInformationVCDelegate>
@property(nonatomic, strong) UITableView *blockTable;
@property(nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation BlockListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavBar];
    [self configTableView];
    [self sendRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = NO;
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //self.navigationController.navigationBarHidden = YES;
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

/*
- (void)configNavBar
{
    self.title = @"Block";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColorUtil colorWithHexString:@"#1e2d3b"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 60, 30);
    backBtn.titleLabel.font = NavTitleFont;
    UIBarButtonItem *bacgItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = bacgItem;
    [backBtn addTarget:self action:@selector(backNav) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, UIWIDTH, 1)];
    lineView.backgroundColor = [UIColorUtil colorWithHexString:@"e5e5ea"];
    [self.navigationController.navigationBar addSubview:lineView];
}
*/
/*
- (void)configNavBar
{
    self.title = @"Block";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 44/2 - 18/2, 18, 18);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backNav"] forState:UIControlStateNormal];
    UIBarButtonItem *bacgItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = bacgItem;
    [backBtn addTarget:self action:@selector(backNav) forControlEvents:UIControlEventTouchUpInside];
    
 
    // 导航 底部线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, UIWIDTH, 1)];
    lineView.backgroundColor = [UIColorUtil colorWithHexString:@"#f7f7f7"];
    [self.navigationController.navigationBar addSubview:lineView];
}
*/
- (void)configNavBar
{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWIDTH, 64)];
    navView.backgroundColor = [UIColorUtil colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:navView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 44/2 - 20/2 + 20, 30, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backNav"] forState:UIControlStateNormal];
    
    [navView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backNav) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(UIWIDTH/2 - 60, 20, 120, 44)];
    titleLab.text = @"BLOCK";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = NavTitleFont;
    [navView addSubview:titleLab];
}


- (void)backNav
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark 初始化 Message TableView
- (void)configTableView
{
    if (!self.blockTable) {
        CGRect frame = self.view.bounds;
        frame.origin.y = 64;
        frame.size.height -= 64;
        self.blockTable                 = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.blockTable.backgroundColor = [UIColor clearColor];
        self.blockTable.separatorStyle  = UITableViewCellSeparatorStyleNone;
        self.blockTable.delegate        = self;
        self.blockTable.dataSource      = self;
        [self.view addSubview:self.blockTable];
        
        [self.blockTable addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)]];
    }
}

- (void)swipeGesture:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self backNav];
    }
}

#pragma -mark TableView 回调
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NearByCell getNearByCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearByCell *cell = [NearByCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    
    [cell set_NearByCellData:self.dataSource[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NearByModel *_model = self.dataSource[indexPath.row];
    UserInformationController *userInformationVC = [[UserInformationController alloc] init];
    userInformationVC.delegate = self;
    userInformationVC.indexPath = indexPath;
    userInformationVC.model = _model;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:userInformationVC animated:YES completion:nil];
    });
}

// 点击 talk 回调
- (void)talkCellWithNearByModel:(NearByModel *)model IndexPath:(NSIndexPath *)indexpath
{
    if ([self.delegate respondsToSelector:@selector(clickBlock_TalkAction:)]) {
        [self.delegate clickBlock_TalkAction:model];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)followCellWithNearByModel:(NearByModel *)model IndexPath:(NSIndexPath *)indexPath PUSHTYPE:(PUSH_TYPE)pushType
{
    // 更新数据
    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [self.blockTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)blockCellWithNearByModel:(NearByModel *)model IndexPath:(NSIndexPath *)indexPath PUSHTYPE:(PUSH_TYPE)pushType
{
    [self.dataSource removeObject:model];
    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [self.blockTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma -mark 请求网络
- (void)sendRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [HttpTool sendRequestBlockListSuccess:^(id json) {

        ResponseNearByModel *res = [[ResponseNearByModel alloc] initWithString:json error:nil];
        if (res.RETURN_CODE == 200) {

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            self.dataSource = [NSMutableArray arrayWithArray:res.content];
            [self.blockTable reloadData];
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
