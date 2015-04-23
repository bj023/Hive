//
//  SettingsController.m
//  Hive
//
//  Created by BaoJun on 15/3/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "SettingsController.h"
#import "SettingsCell.h"
#import "ProfileCell.h"
#import "NotificationNorCell.h"
#import "Utils.h"
#import "CustomIMGView.h"
#import "CustomActionSheetView.h"

@interface SettingsController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_titleArr;
}
@property (strong, nonatomic) CustomIMGView *headIMG;
@property (strong, nonatomic) UITableView * settingTableView;
@property (strong, nonatomic) CustomActionSheetView *sheet;
@end

@implementation SettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleArr];
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTitleArr
{
    _titleArr = @[@"",//显示姓名
                  @"Notification Previews",
                  @"In-App Sound",
                  @"In-App Vibrate",
                  @"Hiding",
                  @"Be Followed",
                  @"My Following",
                  @"Block List",
                  @"Privacy Police",
                  @"Terms of Service"];

}

#pragma -mark 设置 TableView HeadView
- (void)setTableHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.settingTableView.bounds.size.width, 378/2)];
    headView.backgroundColor = [UIColor clearColor];
    self.settingTableView.tableHeaderView = headView;
    
    self.headIMG = [self getProfileIMG];
    
    [headView addSubview:self.headIMG];
    
    CurrentUserInfo *user = [[UserInfoManager sharedInstance] getCurrentUserInfo];
    [self.headIMG setImageURLStr:user.userHead];
    
    [self.headIMG addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadIMGAction:)]];

}

#pragma -mark 头像
- (CustomIMGView *)getProfileIMG
{
    CGFloat width = 80;
    CGRect frame = CGRectMake(self.settingTableView.bounds.size.width/2 - width/2, 378/4 - width/2, width, width);
    CustomIMGView *headIMG = [[CustomIMGView alloc] initWithFrame:frame];
    headIMG.backgroundColor = [UIColor grayColor];
    headIMG.layer.cornerRadius = width/2;
    headIMG.clipsToBounds = YES;
    return headIMG;
}

#pragma -mark 初始化 表格
- (void)configTableView
{
    CGRect frame = self.view.bounds;
    frame.origin.y = 0;
    frame.size.height -= present_Navigation_Y;
    if (!self.settingTableView) {
        self.settingTableView                 = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.settingTableView.delegate        = self;
        self.settingTableView.dataSource      = self;
        self.settingTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        self.settingTableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.settingTableView];
        [self setTableHeadView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SettingsCell getSettingsCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ProfileCell *cell = [ProfileCell cellWithTableView:tableView];
        [cell setProfileData:@"No Set" IndexPath:indexPath];
        return cell;
    }else if (indexPath.row < 6) {
        NotificationNorCell *cell = [NotificationNorCell cellWithTableView:tableView];
        cell.indexPath = indexPath;
        [cell setCellDate:_titleArr[indexPath.row] Detail:@"On" AccessView:NO];
        
        __weak SettingsController *weakSelf = self;
        cell.block = ^(NSIndexPath *indexpath){
            debugLog(@"setion->%ld row->%ld",indexPath.section,indexPath.row);
            if (indexPath.row == 4) {
                [weakSelf sendRequestHiding];
            }else if(indexPath.row == 5)
                [weakSelf sendRequestBeFollow];
            
         };
        
        
        return cell;
    }else {
        SettingsCell *cell = [SettingsCell cellWithTableView:tableView];
        [cell settingData:_titleArr[indexPath.row]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.clickCellAtIndex(indexPath);
}

#pragma -mark 请求网络
- (void)sendRequestHiding
{
    NSString *string = [NSDataUtil valueHiding]?@"0":@"1";
    [HttpTool sendRequestHiding:string success:^(id json) {
        ResponseNearByModel *res = [[ResponseNearByModel alloc] initWithString:json error:nil];
        if (res.RETURN_CODE == 200) {
            [NSDataUtil setHidingWithValue:[NSDataUtil valueHiding]?@"1":@"0"];
        }
    } faliure:^(NSError *error) {
        
    }];
}

- (void)sendRequestBeFollow
{
    NSString *string = [NSDataUtil beFollow]?@"0":@"1";
    [HttpTool sendRequestBeFollow:string success:^(id json) {
        ResponseNearByModel *res = [[ResponseNearByModel alloc] initWithString:json error:nil];
        if (res.RETURN_CODE == 200) {
            [NSDataUtil setBeFollowWithValue:[NSDataUtil beFollow]?@"1":@"0"];
        }
    } faliure:^(NSError *error) {
        
    }];
}

#pragma -mark 头像点击事件
- (void)clickHeadIMGAction:(id)sender
{
    self.sheet = [[CustomActionSheetView alloc] initWithFrame:self.view.bounds withTitles:@[@"Take photo",@"Choose photo"]];
    [self.sheet showWithBackgroundColor:[UIColor whiteColor]];
    
    __weak SettingsController *weakSelf = self;
    self.sheet.clickActionSheetAtIdex = ^(NSInteger index){
        
        if (index == 0) {
            [weakSelf takePhoto];
        }else{
            [weakSelf choosePhoto];
        }
    };
}
- (void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        self.selectBlock(@"takePhoto");
    }else{
        debugLog(@"无法使用拍照功能");
    }
}

- (void)choosePhoto
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.selectBlock(@"choosePhoto");
    } else {
        debugLog(@"无法访问相册");
    }
}

- (void)set_HeadIMG:(UIImage *)image
{
    self.headIMG.image = image;
}

- (void)dealloc
{
    self.settingTableView.delegate = nil;
    self.headIMG = nil;
    self.settingTableView = nil;
    self.sheet = nil;
}
@end
