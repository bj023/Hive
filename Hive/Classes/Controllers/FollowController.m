//
//  FollowController.m
//  Hive
//
//  Created by mac on 15/4/19.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "FollowController.h"
#import "Utils.h"
#import "NearByCell.h"
#import "UserInformationController.h"

@interface FollowController ()<UITableViewDataSource, UITableViewDelegate, UserInformationVCDelegate>
@property(nonatomic, strong) UITableView *followTable;
@property(nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation FollowController

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
    self.title = @"Follow";
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
- (void)configNavBar
{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWIDTH, 64)];
    navView.backgroundColor = [UIColorUtil colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:navView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 44/2 - 18/2 + 20, 18, 18);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backNav"] forState:UIControlStateNormal];
    
    [navView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backNav) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(UIWIDTH/2 - 60, 20, 120, 44)];
    titleLab.text = @"FLLOW";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = NavTitleFont;
    [navView addSubview:titleLab];
    /*
     导航 底部线
     UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, UIWIDTH, 1)];
     lineView.backgroundColor = [UIColorUtil colorWithHexString:@"#f7f7f7"];
     [self.navigationController.navigationBar addSubview:lineView];
     */
}
- (void)backNav
{
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark 初始化 Message TableView
- (void)configTableView
{
    if (!self.followTable) {
        CGRect frame = self.view.bounds;
        frame.origin.y = 64;
        frame.size.height -= 64;
        self.followTable                 = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.followTable.backgroundColor = [UIColor clearColor];
        self.followTable.separatorStyle  = UITableViewCellSeparatorStyleNone;
        self.followTable.delegate        = self;
        self.followTable.dataSource      = self;
        [self.view addSubview:self.followTable];
        
        [self.followTable addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)]];

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
    NearByModel *_model = self.dataSource[indexPath.row];
    UserInformationController *userInformationVC = [[UserInformationController alloc] init];
    userInformationVC.delegate = self;
    userInformationVC.indexPath = indexPath;
    userInformationVC.model = _model;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:userInformationVC animated:YES completion:nil];
    });
}

- (void)talkCellWithNearByModel:(NearByModel *)model IndexPath:(NSIndexPath *)indexpath
{
    if ([self.delegate respondsToSelector:@selector(clickFollow_TalkAction:)]) {
        [self.delegate clickFollow_TalkAction:model];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)followCellWithNearByModel:(NearByModel *)model IndexPath:(NSIndexPath *)indexPath PUSHTYPE:(PUSH_TYPE)pushType
{
    [self.dataSource removeObject:model];
    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [self.followTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)blockCellWithNearByModel:(NearByModel *)model IndexPath:(NSIndexPath *)indexPath PUSHTYPE:(PUSH_TYPE)pushType
{
    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [self.followTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma -mark 请求网络
- (void)sendRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [HttpTool sendRequestFollowListSuccess:^(id json) {

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        ResponseNearByModel *res = [[ResponseNearByModel alloc] initWithString:json error:nil];
        if (res.RETURN_CODE == 200) {

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            self.dataSource = [NSMutableArray arrayWithArray:res.content];
            [self.followTable reloadData];
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
