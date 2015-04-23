//
//  NotificationController.m
//  Hive
//
//  Created by BaoJun on 15/3/31.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "NotificationController.h"
#import "Utils.h"
#import "NotificationNorCell.h"
#import "BlockListController.h"

@interface NotificationController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_titleArr;
}
@property (strong, nonatomic) UITableView *notificationTable;
@end

@implementation NotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavBar];
    [self setBackground];
    [self setTitleData];
    [self configTableView];
    [self sendRequestAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)configNavBar
{
    self.title = @"Notification";
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

- (void)setTitleData
{
    _titleArr = @[@[@"Notifications"],@[@"Hiding",@"Be Followed"],@[@"In-App Alert Sound",@"Vibrate"],@[@"My Following",@"Block List"],@[@"Privacy Police",@"Terms of Service"]];
}

- (void)setBackground
{
    [self.view setBackgroundColor:[UIColorUtil colorWithCodeefeff4]];
}

#pragma  -mark 初始化 表格
- (void)configTableView
{
    if (!self.notificationTable) {
        
        CGRect frmae = self.view.bounds;
        frmae.size.height -= present_Navigation_Y;
        self.notificationTable = [[UITableView alloc] initWithFrame:frmae style:UITableViewStyleGrouped];
        self.notificationTable.delegate = self;
        self.notificationTable.dataSource = self;
        self.notificationTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.notificationTable.backgroundColor = [UIColorUtil colorWithCodeefeff4];
        [self.view addSubview:self.notificationTable];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }else if(section == 1)
        return 118/2;
//    else if (section == 2)
//        return 118/2;
    else
        return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    
    if (section == 1) {
        
        CGSize size = [UIFontUtil sizeWithString:NotificationIntro font:HintFont maxSize:CGSizeMake(UIWIDTH-32, CGFLOAT_MAX)];
        
        UILabel *notificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, size.width, size.height)];
        notificationLabel.text = NotificationIntro;
        notificationLabel.font = [UIFont fontWithName:Font_Helvetica size:15];
        notificationLabel.numberOfLines = 0;
        notificationLabel.textColor = [UIColorUtil colorWithCode888888];
        [bgView addSubview:notificationLabel];
    }
    
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationNorCell *cell = [NotificationNorCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    if (indexPath.section == 0) {
        [cell setCellDate:_titleArr[indexPath.section][indexPath.row] Detail:@"Disable" AccessView:NO];
    }else if (indexPath.section == 3 || indexPath.section == 4){
        [cell setCellDate:_titleArr[indexPath.section][indexPath.row] Detail:@"" AccessView:YES];
    }else{
        [cell setCellDate:_titleArr[indexPath.section][indexPath.row] Detail:@"" AccessView:NO];
    }
    
    cell.block = ^(NSIndexPath *indexpath){
        debugLog(@"setion->%ld row->%ld",indexPath.section,indexPath.row);
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 3:
        {
            if (indexPath.row == 0) {
                
            }else{
                BlockListController *blockVC = [[BlockListController alloc] init];
                [self.navigationController pushViewController:blockVC animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma -mark 请求网络 
- (void)sendRequestAction
{
    [HttpTool sendRequestSettingsNotificationSuccess:^(id json) {
        debugLog(@"%@",json);
    } faliure:^(NSError *error) {
        
    }];
}

- (void)dealloc
{
    self.notificationTable.delegate = nil;
    self.notificationTable = nil;
}
@end
