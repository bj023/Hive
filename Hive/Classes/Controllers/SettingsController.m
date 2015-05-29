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

#define kTopHeight 326/2
#define kHeadSize 178/2
#define kTopY 216/2

@interface SettingsController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
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

- (void)reloadSetting_ProfileData
{
    [self.settingTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
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
                  @"Hide",
                  @"Be Followed",
                  @"My Following",
                  @"Block List",
                  @"Privacy Police",
                  @"Terms of Service",
                  @"Clear All Chats"];

}

#pragma -mark 设置 TableView HeadView
- (void)setTableHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.settingTableView.bounds.size.width, kTopHeight)];
    headView.backgroundColor = [UIColorUtil colorWithHexString:@"#f1efee"];
    self.settingTableView.tableHeaderView = headView;
    
    self.headIMG = [self getProfileIMG];
    
    [headView addSubview:self.headIMG];
    
    CurrentUserInfo *user = [[UserInfoManager sharedInstance] getCurrentUserInfo];

    
    [self.headIMG setImageURLStr:User_Head(user.userID) placeholder:nil];

    
    //self.headIMG.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:User_Head(user.userID)]]];
    debugLog(@"用户头像->%@",User_Head(user.userID));
    
    [self.headIMG addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadIMGAction:)]];

}

- (void)setTableFooterView
{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWIDTH, 60)];
    footView.backgroundColor = [UIColor whiteColor];
    self.settingTableView.tableFooterView = footView;
    
    UIButton *mlogOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mlogOutBtn.frame = CGRectMake(0, 10, UIWIDTH, 40);
    mlogOutBtn.titleLabel.font = SettingsFont;
    [mlogOutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mlogOutBtn setTitle:@"Log Out" forState:UIControlStateNormal];
    [footView addSubview:mlogOutBtn];
    [mlogOutBtn addTarget:self action:@selector(clickLogOutBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickLogOutBtn:(id)sender
{
    [self sendRequestLogOut];
}

#pragma -mark 头像
- (CustomIMGView *)getProfileIMG
{
    CGFloat width = kHeadSize;
    CGFloat headY = kTopHeight/2 - kHeadSize/2;
    CGRect frame = CGRectMake(self.settingTableView.bounds.size.width/2 - width/2, headY, width, width);
    CustomIMGView *headIMG = [[CustomIMGView alloc] initWithFrame:frame];
    headIMG.backgroundColor = [UIColor clearColor];
    headIMG.layer.cornerRadius = width/2;
    headIMG.clipsToBounds = YES;
    headIMG.layer.borderWidth = kHeadIMG_Line_Height;
    headIMG.layer.borderColor = kHeadIMG_Layer_Color.CGColor;
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
        [self setTableFooterView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SettingsCell getSettingsCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ProfileCell *cell = [ProfileCell cellWithTableView:tableView];
        [cell setProfileData:[[UserInfoManager sharedInstance] getCurrentUserInfo].userIntro IndexPath:indexPath];
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
        ResponseManagerModel *res = [[ResponseManagerModel alloc] initWithString:json error:nil];
        if (res.RETURN_CODE == 200) {
            [NSDataUtil setHidingWithValue:string];
        }
    } faliure:^(NSError *error) {
        
    }];
}

- (void)sendRequestBeFollow
{
    NSString *string = [NSDataUtil beFollow]?@"0":@"1";
    [HttpTool sendRequestBeFollow:string success:^(id json) {
        ResponseManagerModel *res = [[ResponseManagerModel alloc] initWithString:json error:nil];
        if (res.RETURN_CODE == 200) {
            [NSDataUtil setBeFollowWithValue:string];
        }
    } faliure:^(NSError *error) {
        
    }];
}

- (void)sendRequestLogOut
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpTool sendRequestLogOutsuccess:^(id json) {
        
        ResponseManagerModel *res = [[ResponseManagerModel alloc] initWithString:json error:nil];
        
        if (res.RETURN_CODE == 200) {
            [[XMPPManager sharedInstance] signOut];
            [[UserInfoManager sharedInstance] logOut];
            [self handleSetRootViewController];
        }else
            [self showHudWith:ErrorRequestText];
        
        
    } faliure:^(NSError *error) {
        [self showHudWith:ErrorText];
    }];
}

#pragma -mark 头像点击事件
- (void)clickHeadIMGAction:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"take photo",@"choose from photos", nil];
    
    [sheet showInView:self.view];
    /*
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
     */
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
        {
            [self takePhoto];
        }
            break;
        case 1:
        {
            [self choosePhoto];
        }
            break;
        default:
            break;
    }
    
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
    NSData *imgData = UIImageJPEGRepresentation(image, 0.1);
    [HttpTool sendRequestUploadHeadImg:imgData success:^(id json) {
        [self showHudWith:@"上传成功"];
    } faliure:^(NSError *error) {
        [self showHudWith:@"上传失败"];
    }];
    
}
- (void)showHudWith:(NSString *)text
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showTextHUDAddedTo:self.view withText:text animated:YES];
}


- (void)handleSetRootViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setRootViewController" object:nil];
}

- (void)dealloc
{
    self.settingTableView.delegate = nil;
    self.headIMG = nil;
    self.settingTableView = nil;
    self.sheet = nil;
}
@end
