//
//  ViewController.m
//  Hive
//
//  Created by BaoJun on 15/3/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ViewController.h"
#import "SLPagingViewController.h"
#import "UIColorUtil.h"
#import "SettingsController.h"
#import "MessagesController.h"
#import "HiveController.h"
#import "NearByController.h"
#import <MAMapKit/MAMapKit.h>
#import "Utils.h"
#import "ProfileController.h"
#import "BlockListController.h"
#import "FollowController.h"
#import "UserInformationController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define APIKey @"588013a8aa2e427d04f67917d98d0315"

@interface ViewController ()<MAMapViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UserInformationVCDelegate>
{
    SLPagingViewController *pageViewController;
    
    SettingsController *_settingsVC;
    MessagesController *_messagesVC;
    HiveController *_hiveVC;
    NearByController *_nearByVC;
    
    MAMapView *_mapView;
    
    UILabel *_messageLabel; // Message 标题
}
@property (strong, nonatomic)UINavigationController *navigationController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = YES;
    [self configPagingVC];
    //[self initMapView];
    [self clickCellAction];
    [self clickUserHeadAction];
    //[self performSelector:@selector(removeMapView) withObject:nil afterDelay:3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark TWitter 导航效果
- (void)configPagingVC
{
    UIColor *orange = [UIColorUtil colorWithHexString:@"#ffffff"];
    UIColor *gray = [UIColorUtil colorWithHexString:@"#5a5e66"];

    pageViewController = [[SLPagingViewController alloc] initWithNavBarItems:[self titlesArr]
                                                            navBarBackground:[UIColorUtil colorWithHexString:@"#1b2430"]
                                                                 controllers:[self twitterVC]
                                                             showPageControl:NO];
    
    pageViewController.navigationSideItemsStyle = SLNavigationSideItemsStyleDefault;
    // Tinder Like
    pageViewController.pagingViewMoving = ^(NSArray *subviews){
        //int i = 0;
        for(UIImageView *v in subviews){
            UIColor *c = gray;
            if(v.frame.origin.x > 45
               && v.frame.origin.x < 145)
                // Left part
                c = [UIColorUtil gradient:v.frame.origin.x
                               top:46
                            bottom:144
                              init:orange
                              goal:gray];
            else if(v.frame.origin.x > 145
                    && v.frame.origin.x < 245)
                // Right part
                c = [UIColorUtil gradient:v.frame.origin.x
                               top:146
                            bottom:244
                              init:gray
                              goal:orange];
            else if(v.frame.origin.x == 145)
                c = orange;
            v.tintColor= c;
            if([v isKindOfClass:[UILabel class]]){
                UILabel *label = (UILabel *) v;
                [label setTextColor:c];
            }
        }
    };
    
    [pageViewController.navigationBarView addSubview:[_nearByVC getSelectBtuuon]];
    __weak  HiveController *weakHive = _hiveVC;
    __weak NearByController *weakNearByVC = _nearByVC;
    
    pageViewController.didChangedPage = ^(NSInteger currentPageIndex){
        // Do something
        NSLog(@"index %ld", (long)currentPageIndex);
        if (currentPageIndex == 3) {
            [weakNearByVC sendNearByAction];
        }
        [weakHive set_HiddenKeyboard];
    };

    pageViewController.pagingViewMovingRedefine = ^(UIScrollView * scrollView, NSArray *subviews){

        if (scrollView.contentOffset.x < subviews.count * UIWIDTH && (subviews.count-1) * UIWIDTH) {
            //[weakNearByVC hiddenSelectButton:YES];
            CGFloat padding = subviews.count * UIWIDTH - scrollView.contentOffset.x;
            [weakNearByVC moveSelectButtonWithPadding:padding];
        }
    };
    
    _navigationController = [[UINavigationController alloc] initWithRootViewController:pageViewController];
    [self.view addSubview:_navigationController.view];
    [self addChildViewController:_navigationController];
    //_navigationController.view.alpha = 0;

    [pageViewController setCurrentIndex:2 animated:YES];
}

- (NSArray *)twitterVC
{
    if (!_settingsVC)
        _settingsVC = [[SettingsController alloc] init];
    if (!_messagesVC)
        _messagesVC = [[MessagesController alloc] init];
    if (!_hiveVC)
        _hiveVC     = [[HiveController alloc] init];
    if (!_nearByVC)
        _nearByVC   = [[NearByController alloc] init];
    _settingsVC.view.frame = self.view.bounds;
    _messagesVC.view.frame = self.view.bounds;
    _hiveVC.view.frame = self.view.bounds;
    _nearByVC.view.frame = self.view.bounds;

    return @[_settingsVC,_messagesVC,_hiveVC,_nearByVC];
}

- (NSArray *)titlesArr
{
    UILabel *ticketNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [ticketNameLabel setText:@"Setting"];
    [ticketNameLabel setTextColor:[UIColor whiteColor]];
    [ticketNameLabel setFont:TextFont];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_messageLabel setText:@"Message"];
    [_messageLabel setTextColor:[UIColor whiteColor]];
    [_messageLabel setFont:TextFont];
    
    UILabel *ticketNameLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    [ticketNameLabel3 setText:@"We"];
    [ticketNameLabel3 setTextColor:[UIColor whiteColor]];
    [ticketNameLabel3 setFont:TitleFont];
    
    UILabel *ticketNameLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    [ticketNameLabel4 setText:@"Nearby"];
    [ticketNameLabel4 setTextColor:[UIColor whiteColor]];
    [ticketNameLabel4 setFont:TextFont];
    
    return @[ticketNameLabel,_messageLabel,ticketNameLabel3,ticketNameLabel4];
}

#pragma -mark 动画

- (void)removeMapView
{
    self.navigationController.view.alpha = 1;
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.8;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromBottom;
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    [[self.view layer] addAnimation:animation forKey:@"animation"];
    
    // 移除 地图
    [self clearMapView];
    [_mapView removeFromSuperview];
}

#pragma - mark 地图
- (void)initMapView
{
    _mapView.showsUserLocation = YES;
    
    [MAMapServices sharedServices].apiKey = APIKey;
    
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds),
                                                               CGRectGetHeight(self.view.bounds))];
        _mapView.delegate = self;
        _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 22);
        _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, 22);
        [self.view addSubview:_mapView];
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
    }
}

- (void)clearMapView
{
    _mapView.showsUserLocation = NO;
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView removeOverlays:_mapView.overlays];
    _mapView.delegate = nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation: (BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

#pragma -mark 设置页 Block 回调
- (void)clickCellAction
{
    __weak ViewController *weakSelf = self;
    _settingsVC.clickCellAtIndex = ^(NSIndexPath *indexpath){
        switch (indexpath.row) {
            case 0:
            {
                ProfileController *profile = [[ProfileController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:profile];
                [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                
            }
                break;
            case 3:
            {
                
            }
                break;
            case 4:
            {
                
            }
                break;
            case 5:
            {
                
            }
                break;
            case 6:
            {
                FollowController *followVC = [[FollowController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:followVC];
                [weakSelf presentViewController:nav animated:YES completion:nil];
            }
                break;
            case 7:
            {
                BlockListController *blockVC = [[BlockListController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:blockVC];
                [weakSelf presentViewController:nav animated:YES completion:nil];
            }
                break;
            case 8:
            {
                
            }
                break;
            case 9:
            {
                
            }
                break;
            default:
                break;
        }
    };
}
#pragma -mark 点击用户头像 Block 回调
- (void)clickUserHeadAction
{
    __weak ViewController *weakSelf = self;
    
    _hiveVC.mainViewBlock = ^(NSString *userID){
        //[weakSelf pushUserInformationControllerWithUserID:userID];
    };
    // message
    _messagesVC.mainViewBlock = ^(NSString *userID){
        //[weakSelf pushUserInformationControllerWithUserID:userID];
    };
    _messagesVC.mainViewBlock = ^(NSString *userID){
        debugLog(@"message->%@",userID);
        //[HttpTool sendRequestWithUserID:@"79"];
    };
    
    // nearBy
    _nearByVC.nearByBlock = ^(NearByModel *model, NSIndexPath *indexpath){
        [weakSelf pushUserInformationController:model IndexPath:indexpath];
    };
    
    
    _settingsVC.selectBlock = ^(NSString *str){
        if ([str isEqualToString:@"takePhoto"]) {
            [weakSelf getImageSourceWithType:UIImagePickerControllerSourceTypeCamera];
        }else
            [weakSelf getImageSourceWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    };
}

- (void)pushUserInformationController:(NearByModel *)model IndexPath:(NSIndexPath *)indexpath
{
    UserInformationController *userInformationVC = [[UserInformationController alloc] init];
    userInformationVC.delegate = self;
    userInformationVC.indexPath = indexpath;
    userInformationVC.model = model;
    [self presentViewController:userInformationVC animated:YES completion:nil];
}

- (void)followCellWithNearByModel:(NearByModel *)model IndexPath:(NSIndexPath *)indexPath
{
    [_nearByVC updateCellWithNearby:model IndexPath:indexPath];
}

- (void)blockCellWithNearByModel:(NearByModel *)model IndexPath:(NSIndexPath *)indexPath
{
    [_nearByVC removeCellWithNearby:model IndexPath:indexPath];
}

#pragma -mark 相册选择
-(void)getImageSourceWithType:(UIImagePickerControllerSourceType )sourceType
{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=sourceType;
    picker.delegate=self;
    picker.allowsEditing=YES;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{

    }];
    
}
//获取图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img;
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        img=[info objectForKey:UIImagePickerControllerEditedImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{

        // 上传图片
        [_settingsVC set_HeadIMG:img];
        
        //        _urlStr = [NSString stringWithFormat:@"%@/image/upload",__HOST__];
        //        [[HttpRequestManager sharedManager]upLoadImgWithUrl:_urlStr andImage:img andObj:self andSelector:@selector(uploadimgSuccess:) andFailedSelector:nil];
        
    }];
}
@end
