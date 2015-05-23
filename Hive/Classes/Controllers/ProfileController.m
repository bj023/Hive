//
//  ProfileController.m
//  Hive
//
//  Created by BaoJun on 15/3/31.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ProfileController.h"
#import "Utils.h"
#import "UserInforCell.h"

@interface ProfileController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *profileTable;

@end

@implementation ProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavBar];
    [self configTableView];
    [self configViewBackGround];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}

- (void)configNavBar
{
    self.title = @"Profile";
    
    
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

- (void)backNav
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configViewBackGround
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

#pragma  -mark 初始化 表格
- (void)configTableView
{
    if (!self.profileTable) {
        
        CGRect frmae = self.view.bounds;
        frmae.size.height -= present_Navigation_Y;
        self.profileTable = [[UITableView alloc] initWithFrame:frmae style:UITableViewStyleGrouped];
        self.profileTable.delegate = self;
        self.profileTable.dataSource = self;
        self.profileTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.profileTable.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.profileTable];
    }
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }else
        return self.profileTable.frame.size.height - 44 * 2 - 120 - 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 1?15:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 && indexPath.section == 0) {
        return 120;
    }
    return [UserInforCell getUserInforCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 - section;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        UserInforCell *cell = [UserInforCell cellWithTableView:tableView];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = [[UserInfoManager sharedInstance] getCurrentUserInfo].userName;
        }else{
            cell.textLabel.text = @"Intro";
            cell.detailTextLabel.text = [[UserInfoManager sharedInstance] getCurrentUserInfo].userIntro;
        }
        
        return cell;
    }else if (indexPath.section == 1){
        LogOutCell *cell = [LogOutCell cellWithTableView:tableView];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    debugLog(@"%ld-%ld",indexPath.section ,indexPath.row);
    if (indexPath.section == 1) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [HttpTool sendRequestLogOutsuccess:^(id json) {
            
            ResponseManagerModel *res = [[ResponseManagerModel alloc] initWithString:json error:nil];
            
            if (res.RETURN_CODE == 200) {
                [[XMPPManager sharedInstance] signOut];
                [[UserInfoManager sharedInstance] logOut];
                [self handleSetRootViewController];
            }else
                [self showErrorWithText:ErrorRequestText];

            
        } faliure:^(NSError *error) {
            [self showErrorWithText:ErrorText];
        }];
    }
}


- (void)showErrorWithText:(NSString *)text
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [MBProgressHUD showTextHUDAddedTo:self.view withText:text animated:YES];
}

- (void)handleSetRootViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setRootViewController" object:nil];
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UserInforCell getUserInforCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInforCell *cell = [UserInforCell cellWithTableView:tableView];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Name";
        cell.detailTextLabel.text = [[UserInfoManager sharedInstance] getCurrentUserInfo].userName;
    }else{
        cell.textLabel.text = @"Intro";
        cell.detailTextLabel.text = [[UserInfoManager sharedInstance] getCurrentUserInfo].userIntro;
    }
    
    return cell;
}

- (void)dealloc
{
    self.profileTable.delegate = nil;
    self.profileTable = nil;
}
@end
