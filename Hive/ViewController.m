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
#import "ChatViewController.h"
#import "ChatModel.h"
#import "MessageModel.h"
#import "ChatManager.h"
#import "WelcomeView.h"
#import <Reachability.h>

#define APIKey @"588013a8aa2e427d04f67917d98d0315"

@interface ViewController ()<MAMapViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UserInformationVCDelegate, BlockListControllerDelegate, FollowControllerDelegate>
{
    
    SettingsController *_settingsVC;
    MessagesController *_messagesVC;
    HiveController *_hiveVC;
    NearByController *_nearByVC;
    //MessageTableViewController *_messagesVC;
    
    MAMapView *_mapView;
    
    UILabel *_messageLabel; // Message 标题
    
    Reachability  *hostReach;

}

@property (strong, nonatomic)SLPagingViewController *pageViewController;
@property (strong, nonatomic)UINavigationController *nav;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configPagingVC];
    //[self initMapView];
    [self clickCellAction];
    [self clickUserHeadAction];
    [self performSelector:@selector(configWelcomeView) withObject:nil afterDelay:0.5];
    [self checkNetwork];
    [self addNotification];
    
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMessageVC) name:@"reloadChatMessage" object:nil];
}


- (void)reloadMessageVC
{
    debugLog(@"收到消息通知");
    
    [self setChatsUnReadCount];
    [_messagesVC reloadChatMessage];
    

}

#pragma -mark 检测网络
- (void)checkNetwork
{
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [hostReach startNotifier];
    
}

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    NSString *showString;
    switch (status)
    {
        case NotReachable:
            // 没有网络连接
            showString = @"已断开网络连接";
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            showString = @"正在使用3G网络";
            break;
        case ReachableViaWiFi:
        {
            showString = @"正在使用wifi网络";
            if ([[UserInfoManager sharedInstance] checkUserIsLogin]) {
                [[XMPPManager sharedInstance] connect];
            }
        }
            break;
    }
    debugLog(@"%@",showString);
    
//    UIAlertView *showAler = [[UIAlertView alloc] initWithTitle:showString
//                                                       message:nil
//                                                      delegate:nil
//                                             cancelButtonTitle:@"Cancel"
//                                             otherButtonTitles: nil];
//    [showAler show];
}


#pragma -mark 欢迎界面
- (void)configWelcomeView
{
    /**/
    if ([UserDefaultsUtil iSFirstUse]){
        [UserDefaultsUtil setUserDefaultsFirstUse];
        WelcomeView *mwelCome = [[WelcomeView alloc] initWithFrame:CGRectMake(0, 0, UIWIDTH, UIHEIGHT)];
        [mwelCome showWelCome];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    debugMethod();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark TWitter 导航效果
- (void)configPagingVC
{
    UIColor *orange = [UIColorUtil colorWithHexString:@"#1e2d3b"];
    UIColor *gray = [UIColorUtil colorWithHexString:@"#ced3d7"];
//[UIColorUtil colorWithHexString:@"#1b2430"]
    _pageViewController = [[SLPagingViewController alloc] initWithNavBarItems:[self titlesArr]
                                                            navBarBackground:[UIColor whiteColor]
                                                                 controllers:[self twitterVC]
                                                             showPageControl:NO];
    
    _pageViewController.navigationSideItemsStyle = SLNavigationSideItemsStyleOnBounds;
    // Tinder Like
    _pageViewController.pagingViewMoving = ^(NSArray *subviews){
        //int i = 0;
        for(UIImageView *v in subviews){
            UIColor *c = gray;
            if(v.frame.origin.x > 45
               && v.frame.origin.x < 145)
                // Left part
                c = [UIColorUtil gradient:v.frame.origin.x
                               top:46
                            bottom:140
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
    
    [_pageViewController.navigationBarView addSubview:[_nearByVC getSelectBtuuon]];
    __weak HiveController *weakHive = _hiveVC;
    __weak NearByController *weakNearByVC = _nearByVC;
    
    _pageViewController.didChangedPage = ^(NSInteger currentPageIndex){
        // Do something
        NSLog(@"index %ld", (long)currentPageIndex);
        
        if (currentPageIndex == 3) {

            [weakNearByVC sendNearByAction];
        }
        [weakHive set_HiddenKeyboard];
    };

    _pageViewController.pagingViewMovingRedefine = ^(UIScrollView * scrollView, NSArray *subviews){

        if (scrollView.contentOffset.x < subviews.count * UIWIDTH && (subviews.count-1) * UIWIDTH) {
            //[weakNearByVC hiddenSelectButton:YES];
            CGFloat padding = subviews.count * UIWIDTH - scrollView.contentOffset.x;
            [weakNearByVC moveSelectButtonWithPadding:padding];
        }
    };
    
    _nav = [[UINavigationController alloc] initWithRootViewController:_pageViewController];
    [self.view addSubview:_nav.view];
    [self addChildViewController:_nav];

    [_pageViewController setCurrentIndex:2 animated:NO];
    [self setChatsUnReadCount];
    
    debugLog(@"viewcontroller->%@",_pageViewController.viewControllers);

}

- (NSArray *)twitterVC
{
    _settingsVC = [[SettingsController alloc] init];
    
    _messagesVC = [[MessagesController alloc] init];
    
    //更改
    UINavigationController *mesNav = [[UINavigationController alloc] initWithRootViewController:_messagesVC];
    _messagesVC.navigationController.navigationBarHidden = YES;

    _hiveVC     = [[HiveController alloc] init];
    _nearByVC   = [[NearByController alloc] init];

    return @[_settingsVC,mesNav,_hiveVC,_nearByVC];
}

- (NSArray *)titlesArr
{    
    UILabel *ticketNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [ticketNameLabel setText:@"SETTING"];
    //[ticketNameLabel setTextColor:[UIColor whiteColor]];
    [ticketNameLabel setFont:TextFont];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_messageLabel setText:@"CHATS"];
    //[_messageLabel setTextColor:[UIColor whiteColor]];
    [_messageLabel setFont:TextFont];
    
    
    UILabel *ticketNameLabel3 = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [ticketNameLabel3 setText:@"POOK"];
    //[ticketNameLabel3 setTextColor:[UIColor whiteColor]];
    [ticketNameLabel3 setFont:TextFont];
    
    UILabel *ticketNameLabel4 = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [ticketNameLabel4 setText:@"NEARBY"];
    //[ticketNameLabel4 setTextColor:[UIColor whiteColor]];
    [ticketNameLabel4 setFont:TextFont];
    
//    ticketNameLabel.backgroundColor = [UIColor redColor];
//    ticketNameLabel3.backgroundColor = [UIColor blackColor];
//    ticketNameLabel4.backgroundColor = [UIColor blueColor];
//    _messageLabel.backgroundColor = [UIColor greenColor];
    
    return @[ticketNameLabel,_messageLabel,ticketNameLabel3,ticketNameLabel4];
}

- (void)setChatsUnReadCount
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[ChatManager chatMessageUnreadCount] isEqualToString:@"0"]) {
            _messageLabel.text = @"CHATS";
            
        }else
            _messageLabel.text = [NSString stringWithFormat:@"CHATS(%@)",[ChatManager chatMessageUnreadCount]];
        [_messagesVC reloadChatMessage];
    });
    
    debugLog(@"显示未读-->%@ --- %@",_messageLabel.text,[ChatManager chatMessageUnreadCount]);
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
                [weakSelf pushProfileViewController];
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
                followVC.delegate = weakSelf;
                [weakSelf.navigationController pushViewController:followVC animated:YES];
            }
                break;
            case 7:
            {
                BlockListController *blockVC = [[BlockListController alloc] init];
                blockVC.delegate = weakSelf;
                [weakSelf.navigationController pushViewController:blockVC animated:YES];

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

- (void)clickBlock_TalkAction:(NearByModel *)model
{
    [self pushChatViewController:model];
}

- (void)clickFollow_TalkAction:(NearByModel *)model
{
    [self pushChatViewController:model];
}

- (void)pushChatViewController:(NearByModel *)model
{
    [_pageViewController setCurrentIndex:1 animated:NO];

    ChatViewController *chatVC = [[ChatViewController alloc] init];
    chatVC.userID = [NSString stringWithFormat:@"%d",model.userId];
    chatVC.userName = model.userName;
    chatVC.title = model.userName;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)pushChatVC:(MessageModel *)model
{
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    chatVC.userID = model.toUserID;
    chatVC.userName = model.toUserName;
    chatVC.title = model.toUserName;
    [self.navigationController pushViewController:chatVC animated:YES];
}


#pragma -mark 点击用户头像 Block 回调
- (void)clickUserHeadAction
{
    __weak ViewController *weakSelf = self;
    
    _hiveVC.hiveBlock = ^(NearByModel *model){
        [weakSelf pushUserInforMation:model];
    };
    // message
    _messagesVC.chatBlock = ^(MessageModel *model){
        [weakSelf pushChatVC:model];
    };
    
    _messagesVC.messageBlock = ^(NearByModel *model){
        [weakSelf pushUserInforMation:model];
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
    if (indexpath.row == 0) {
        //跳转到个人修改页
        [self pushProfileViewController];
    }else{
        UserInformationController *userInformationVC = [[UserInformationController alloc] init];
        userInformationVC.delegate = self;
        userInformationVC.indexPath = indexpath;
        userInformationVC.model = model;
        userInformationVC.pushType = PushNextUpdateVC;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:userInformationVC animated:YES completion:nil];
        });
    }
}

- (void)pushUserInforMation:(NearByModel *)model
{
    UserInformationController *userInformationVC = [[UserInformationController alloc] init];
    userInformationVC.pushType = PushNextVC;
    userInformationVC.delegate = self;
    userInformationVC.model = model;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:userInformationVC animated:YES completion:nil];
    });
}


- (void)pushProfileViewController
{
    ProfileController *profile = [[ProfileController alloc] init];
    UINavigationController *profileNav = [[UINavigationController alloc] initWithRootViewController:profile];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:profileNav animated:YES completion:nil];
    });
}


#pragma -mark 用户信息 代理回调
- (void)talkCellWithNearByModel:(NearByModel *)model IndexPath:(NSIndexPath *)indexpath
{
    [self pushChatViewController:model];
}

- (void)followCellWithNearByModel:(NearByModel *)model IndexPath:(NSIndexPath *)indexPath PUSHTYPE:(PUSH_TYPE)pushType
{
    if (pushType == PushNextUpdateVC) {
        [_nearByVC updateCellWithNearby:model IndexPath:indexPath];
    }
}

- (void)blockCellWithNearByModel:(NearByModel *)model IndexPath:(NSIndexPath *)indexPath PUSHTYPE:(PUSH_TYPE)pushType
{
    if (pushType == PushNextUpdateVC) {
        [_nearByVC removeCellWithNearby:model IndexPath:indexPath];
    }
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
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
