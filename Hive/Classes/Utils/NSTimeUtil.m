//
//  NSTimeUtil.m
//  Hive
//
//  Created by mac on 15/4/24.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "NSTimeUtil.h"
#import "Utils.h"
#import <CoreLocation/CoreLocation.h>

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
    
//    if (!_isShowAlert) {
//        _isShowAlert = YES;
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//
//    }
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
    _coordinateLatitude = [NSString stringWithFormat:@"%lf",currLocation.coordinate.latitude];
    _coordinateLongitude = [NSString stringWithFormat:@"%lf",currLocation.coordinate.longitude];
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
            [self sendRequestUpdateLocation];
        }
        
    } faliure:^(NSError *error) {
        // 获取聊天大厅用户列表失败
    }];
}

- (void)sendRequestUpdateLocation
{
    [HttpTool sendRequestUpdateUserLocation:_coordinateLongitude Latitude:_coordinateLatitude success:^(id json) {
        debugLog(@"更新用户位置成功");
    } faliure:^(NSError *error) {
        debugLog(@"更新用户位置失败");
    }];
}


#pragma -mark 获取距离
+ (NSString *)getDistance:(NSString *)longitude latitude:(NSString *)latitude
{
    /*
    NSString *distance;
    double lng1 = [[[NSTimeUtil sharedInstance] getCoordinateLongitude] doubleValue];
    double lat1 = [[[NSTimeUtil sharedInstance] getCoordinateLatitude] doubleValue];
    double lng2 = [longitude doubleValue];
    double lat2 = [latitude doubleValue];
    
    double radLat1 = lat1*M_PI/180;
    double radLat2 = lat2*M_PI/180;
    double a = radLat1 - radLat2;
    double b = lng1*M_PI/180 - lng2*M_PI/180;
    double s = 2 * asin(sqrt(pow(sin(a/2), 2)+cos(radLat1)*cos(radLat2)*pow(sin(b/2), 2)));
    s *= 6378137.0;
    s = round(s*10000)/10000;
    s = s / 1000 ;
    
    distance = [NSString stringWithFormat:@"%.2fkm",s];
    return distance;
     */
    /*
    CLLocation *orig = [[CLLocation alloc] initWithLatitude:[[[NSTimeUtil sharedInstance] getCoordinateLatitude] doubleValue]
                                                longitude:[[[NSTimeUtil sharedInstance] getCoordinateLongitude] doubleValue]];
    CLLocation* dist = [[CLLocation alloc] initWithLatitude:[latitude doubleValue]
                                                longitude:[longitude doubleValue]];
    
    CLLocationDistance kilometers = [orig distanceFromLocation:dist]/1000;
    return [NSString stringWithFormat:@"%.2fkm",kilometers];
     */
    
    double lng1 = [[[NSTimeUtil sharedInstance] getCoordinateLongitude] doubleValue];
    double lat1 = [[[NSTimeUtil sharedInstance] getCoordinateLatitude] doubleValue];
    double lng2 = [longitude doubleValue];
    double lat2 = [latitude doubleValue];
    
    double distance = [NSTimeUtil distanceBetweenOrderBy:lat1 lat2:lat2 lng1:lng1 lng2:lng2];
    return [NSString stringWithFormat:@"%0.2lf km",distance/1000];
    
}

+ (double)distanceBetweenOrderBy:(double)lat1 lat2:(double)lat2 lng1:(double)lng1 lng2:(double)lng2
{
    double dd = M_PI/180;
    double x1=lat1*dd,x2=lat2*dd;
    double y1=lng1*dd,y2=lng2*dd;
    double R = 6371004;
    double distance = (2*R*asin(sqrt(2-2*cos(x1)*cos(x2)*cos(y1-y2) - 2*sin(x1)*sin(x2))/2));
    //km  返回
//     return  distance*1000;
    //返回 m
    return   distance;
}

@end
