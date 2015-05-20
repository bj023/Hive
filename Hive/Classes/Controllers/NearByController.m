//
//  NearByController.m
//  Hive
//
//  Created by BaoJun on 15/3/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "NearByController.h"
#import "Utils.h"
#import "NearByCell.h"
#import "CustomActionSheetView.h"
#import "NSTimeUtil.h"
#import <MJRefresh.h>

#define kSelectBtnTopPadding 9
#define kSelectBtnRightPadding 70
#define kSelectBtnHeight 26
#define kSelectBtnWidth 60

#define kTopViewHeight 50/2

@interface NearByController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    UIRefreshControl *_refreshControl;
}
@property (strong, nonatomic) UITableView *nearByTable;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIButton *selectBtn;
@property (strong, nonatomic) CustomActionSheetView *sheet;
@property (assign, nonatomic) SelectType selectType;
@end

@implementation NearByController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configPeopleNearBy];
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)getSelectBtuuon
{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setTitle:@"Select" forState:UIControlStateNormal];
        [_selectBtn setTitleColor:[UIColorUtil colorWithHexString:@"#64baff"] forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = [UIFont fontWithName:GothamRoundedBold size:16];
        _selectBtn.frame = CGRectMake(UIWIDTH - kSelectBtnRightPadding, kSelectBtnTopPadding, kSelectBtnWidth, kSelectBtnHeight);
        _selectBtn.layer.borderColor = [UIColorUtil colorWithHexString:@"#64baff"].CGColor;
        _selectBtn.layer.cornerRadius = 5;
        _selectBtn.layer.borderWidth = 1;
        [_selectBtn addTarget:self action:@selector(clickSelectAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (void)clickSelectAction
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"ALL",@"Male",@"Female", nil];
    [sheet showInView:self.view];
    
    /*
    self.sheet = [[CustomActionSheetView alloc] initWithFrame:self.view.bounds withTitles:@[@"ALL",@"Male",@"Female",@"Cancel"]];
    [self.sheet showWithBackgroundColor:[UIColor whiteColor]];
    
    __weak NearByController *weakSelf = self;
    self.sheet.clickActionSheetAtIdex = ^(NSInteger index){
        if (index == 0) {
            weakSelf.selectType = (int)index;
            [weakSelf sendNearByActionWithRequestType:RequestCommonType];
        }else if (index == 1 || index == 2) {
            weakSelf.selectType = (int)index;
            [weakSelf sendNearByActionWithRequestType:RequestCommonType];
        }
    };
     */
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    debugLog(@"%@",actionSheet.subviews);

    for (UIView *view in actionSheet.subviews) {
        if ([view isEqual:[UIButton class]]) {
            UIButton *button = (UIButton *) view;
            
            button.titleLabel.font = [UIFont fontWithName:GothamRoundedBook size:16];
            //改变颜色
            [button setTitleColor:[UIColorUtil colorWithHexString:@"#64baff"] forState:UIControlStateNormal];
            //btn的选择状态,否则选择后不变背景
        }
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            self.selectType = (int)index;
            [self sendNearByActionWithRequestType:RequestCommonType];
        }
            break;
        case 1:
        case 2:
        {
            self.selectType = (int)index;
            [self sendNearByActionWithRequestType:RequestCommonType];
        }
            break;
        default:
            break;
    }
}

- (void)moveSelectButtonWithPadding:(CGFloat)padding
{
    _selectBtn.frame = CGRectMake(padding - kSelectBtnRightPadding, kSelectBtnTopPadding, kSelectBtnWidth, kSelectBtnHeight);
}

#pragma -mark people nearby
- (void)configPeopleNearBy
{
    UIView *peopleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWIDTH, kTopViewHeight)];
    peopleView.backgroundColor = [UIColorUtil colorWithHexString:@"#f1efee"];
    [self.view addSubview:peopleView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, kTopViewHeight)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor grayColor];
    titleLab.font = [UIFont fontWithName:GothamRoundedBook size:14];
    titleLab.text = @"People Nearby";
    [peopleView addSubview:titleLab];
}

#pragma -mark 初始化 Message TableView
- (void)configTableView
{
    if (!self.nearByTable) {
        CGRect frame = self.view.bounds;
        frame.origin.y = kTopViewHeight;
        frame.size.height -= (64 + kTopViewHeight);
        self.nearByTable                 = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.nearByTable.backgroundColor = [UIColor clearColor];
        self.nearByTable.separatorStyle  = UITableViewCellSeparatorStyleNone;
        self.nearByTable.delegate        = self;
        self.nearByTable.dataSource      = self;
        [self.view addSubview:self.nearByTable];
        
        [self.nearByTable addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];

        [self.nearByTable.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
        
        _refreshControl = [[UIRefreshControl alloc] init];
        //refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
        [_refreshControl addTarget:self action:@selector(beginPullDownRefreshing:) forControlEvents:UIControlEventValueChanged];
        [self.nearByTable addSubview:_refreshControl];
    }
}

#pragma -mark TableView 回调
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NearByCell getNearByCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NearByCell *cell = [NearByCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    
    if (indexPath.row == 0) {
        [cell set_NearByCellUserData];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        [cell set_NearByCellData:self.dataSource[indexPath.row -1]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.nearByBlock(nil,indexPath);// 传递用户ID
    }else{
        NearByModel *_model = self.dataSource[indexPath.row-1];
        self.nearByBlock(_model,indexPath);// 传递用户ID
    }
}

- (void)updateCellWithNearby:(NearByModel *)model IndexPath:(NSIndexPath *)indexpath
{
    // 更新数据
    [self.dataSource replaceObjectAtIndex:indexpath.row withObject:model];
    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:indexpath.row inSection:0];
    [self.nearByTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)removeCellWithNearby:(NearByModel *)model IndexPath:(NSIndexPath *)indexpath
{
    [self.dataSource removeObject:model];
    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:indexpath.row inSection:0];
    [self.nearByTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma -mark 请求网络
- (void)beginPullDownRefreshing:(id)sender
{
    [self sendNearByActionWithRequestType:RequestRefreshType];
}

- (void)sendNearByAction
{
    if (self.dataSource.count == 0) {
        [self sendNearByActionWithRequestType:RequestCommonType];
    }
}

- (void)loadMoreData:(id)sender
{
    [self sendNearByActionWithRequestType:RequestLoadMoreType];
}

- (void)sendNearByActionWithRequestType:(SendRequestType)sendType
{
    
    NSString *latitude = [[NSTimeUtil sharedInstance] getCoordinateLatitude];
    NSString *longitude = [[NSTimeUtil sharedInstance] getCoordinateLongitude];
    
    if (IsEmpty(latitude) ||
        IsEmpty(longitude)) {
        [self showHudWith:@"获取信息失败"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSInteger startNum = sendType==RequestLoadMoreType ? self.dataSource.count:0;
    NSString *gender = self.selectType == All?@"":[NSString stringWithFormat:@"%d",self.selectType];
    [HttpTool sendRequestWithLongitude:longitude Latitude:latitude Gender:gender StartNumber:startNum NumberCount:10 success:^(id json) {
        if (sendType == RequestRefreshType) {
            [_refreshControl endRefreshing];
        }
        NSError *error = nil;
        ResponseNearByModel *res = [[ResponseNearByModel alloc] initWithString:json error:&error];
        if (!error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            switch (sendType) {
                case RequestCommonType:
                {
                    self.dataSource = [NSMutableArray arrayWithArray:res.content];

                }
                    break;
                case RequestRefreshType:
                {
                    
                    //NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,[res.content count])];
                    //[self.dataSource insertObjects:res.content atIndexes:indexes];
                    self.dataSource = [NSMutableArray arrayWithArray:res.content];

                }
                    break;
                case RequestLoadMoreType:
                {
                    [self.dataSource addObjectsFromArray:res.content];
                }
                    break;
                default:
                    break;
            }
            
            [self.nearByTable reloadData];
        }else
            [self showHudWith:ErrorRequestText];
        
        [self.nearByTable.footer endRefreshing];

        
    } faliure:^(NSError *error) {

        [self.nearByTable.footer endRefreshing];
        if (sendType == RequestRefreshType) {
            [_refreshControl endRefreshing];
        }
        [self showHudWith:ErrorText];
    }];
    
}

- (void)showHudWith:(NSString *)text
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    [MBProgressHUD showTextHUDAddedTo:self.view withText:text animated:YES];
}

- (void)dealloc
{
    self.nearByTable.delegate = nil;
    self.dataSource = nil;
    self.nearByTable = nil;
}
@end
