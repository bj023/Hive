//
//  NSTimeUtil.m
//  Hive
//
//  Created by 那宝军 on 15/4/24.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "NSTimeUtil.h"
#import "Utils.h"
#import <CoreLocation/CoreLocation.h>
#import <Reachability.h>

static CGFloat const chageImageTime = 60.0;

@interface NSTimeUtil ()<CLLocationManagerDelegate, UIAlertViewDelegate>
{
    NSTimer * _moveTime;
    BOOL _isTimeUp;
    CLLocationManager *_locationManager;
    
    BOOL _isShowAlert;
    
    NSString *_coordinateLongitude;
    NSString *_coordinateLatitude;
    
    NSArray *_userIDs;
}

@end

@implementation NSTimeUtil

+ (NSTimeUtil *)sharedInstance
{
    static NSTimeUtil *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [[self alloc] init];
        [instance initLocation];
        [instance initTime];
    });
    return instance;
}

- (void)initLocation
{
    if(nil == _locationManager){
        _locationManager = [[CLLocationManager alloc] init];//创建位置管理器
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 100.0;
        
        if (iOS8)
            [_locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
    }
}

- (void)initTime
{
    _moveTime = [NSTimer scheduledTimerWithTimeInterval:chageImageTime target:self selector:@selector(animalLocation) userInfo:nil repeats:YES];
    _isTimeUp = NO;
}

- (void)setUpTime
{
    if (!_isTimeUp) {
        [_moveTime setFireDate:[NSDate dateWithTimeIntervalSinceNow:chageImageTime]];
    }
    _isTimeUp = NO;
}

- (void)animalLocation
{
    _isTimeUp = YES;
    [self startUpdatelocation];
}

- (void)startUpdatelocation
{
    [_locationManager startUpdatingLocation];
}

- (BOOL)locationAuthorizationStatus
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        return NO;
    }else
        return YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorString;
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"Access to Location Services denied by user";
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
    
    if (!_isShowAlert) {
        _isShowAlert = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

    }
}

- (NSString *)getCoordinateLatitude
{
    return _coordinateLatitude;
}

- (NSString *)getCoordinateLongitude
{
    return _coordinateLongitude;
}

- (NSArray *)getChatUserIDs
{
    return _userIDs;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * currLocation = [locations lastObject];
    _coordinateLatitude = [NSString stringWithFormat:@"%.3f",currLocation.coordinate.latitude];
    _coordinateLongitude = [NSString stringWithFormat:@"%.3f",currLocation.coordinate.longitude];
    [self sendRequestChatRoom];
    [manager stopUpdatingLocation];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        _isShowAlert = NO;
    }
}

#pragma -mark 请求网络
- (void)sendRequestChatRoom
{

    if (IsEmpty(_coordinateLatitude) ||
        IsEmpty(_coordinateLongitude)) {
        return;
    }else if (![[UserInfoManager sharedInstance] checkUserIsLogin]){
        return;
    }
    
    
    
    [HttpTool sendRequestChatRoomWithLongitude:_coordinateLongitude Latitude:_coordinateLatitude success:^(id json) {
        
        ResponseChatUsersModel *res = [[ResponseChatUsersModel alloc] initWithString:json error:nil];
        
        if (res.RETURN_CODE == 200) {
            _userIDs = res.userIDs;
        }
        
    } faliure:^(NSError *error) {
        // 获取聊天大厅用户列表失败
    }];
}





- (void)ok
{
    dispatch_queue_t myCustomQueue = dispatch_queue_create("example.MyCustomQueue", NULL);
    dispatch_async(myCustomQueue, ^{
        for (int abc=0;abc<100;abc++)
        {
            printf("1.Do some work here.\n");
        }
    });
    dispatch_async(myCustomQueue, ^{
        for (int abc=0;abc<100;abc++)
        {
            printf("2.Do some work here.\n");
        }
    });
    dispatch_queue_t myCustomQueue2 = dispatch_queue_create("example.MyCustomQueue2", NULL);
    dispatch_async(myCustomQueue2, ^{
        for (int abc=0;abc<100;abc++)
        {
            printf("3. myCustomQueue2 Do some work here.\n");
        }
    });
    dispatch_async(myCustomQueue2, ^{
        for (int abc=0;abc<100;abc++)
        {
            printf("4. myCustomQueue2 Do some work here.\n");
        }
    });
    
}

+(BOOL)Request3G
{
    BOOL GetMy3G = NO;
    //监测网络
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus])
    {
        case NotReachable:
            // 没有网络连接
            NSLog(@"没有网络");
            GetMy3G = NO;
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            NSLog(@"正在使用3G网络");
            GetMy3G = YES;
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            NSLog(@"正在使用wifi网络");
            GetMy3G = YES;
            break;
    }
    return GetMy3G;
}

@end
