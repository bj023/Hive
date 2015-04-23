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
#import "LogOutCell.h"

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

- (void)configNavBar
{
    self.title = @"Profile";
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 60, 30);
    backBtn.titleLabel.font = NavTitleFont;
    
    UIBarButtonItem *bacgItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = bacgItem;
    
    [backBtn addTarget:self action:@selector(backNav) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backNav
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)configViewBackGround
{
    [self.view setBackgroundColor:[UIColorUtil colorWithCodeefeff4]];
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
        self.profileTable.backgroundColor = [UIColorUtil colorWithCodeefeff4];
        [self.view addSubview:self.profileTable];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }else
        return self.profileTable.frame.size.height - 44 *3 - 30 - 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 1?15:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        cell.textLabel.text = @"name";
        return cell;
    }else if (indexPath.section == 1){
        LogOutCell *cell = [LogOutCell cellWithTableView:tableView];
        return cell;
    }
    
    return nil;
}

- (void)dealloc
{
    self.profileTable.delegate = nil;
    self.profileTable = nil;
}
@end
