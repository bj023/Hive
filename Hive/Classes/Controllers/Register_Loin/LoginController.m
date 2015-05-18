//
//  LoginController.m
//  Hive
//
//  Created by BaoJun on 15/3/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "LoginController.h"
#import "Utils.h"
#import "LoginView.h"
#import "RegisterView.h"
#import "RegisterSecondView.h"
#import "RegisterThirdView.h"
#import "RegisterFourView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"

@interface LoginController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic)UIScrollView *scrollerView;

@property (strong, nonatomic)LoginView *loginView;

@property (strong, nonatomic) RegisterView       *registerFirst;
@property (strong, nonatomic) RegisterSecondView *registerSecond;
@property (strong, nonatomic) RegisterThirdView  *registerThird;
@property (strong, nonatomic) RegisterFourView   *registerFour;

@end

@implementation LoginController
- (void)dealloc
{
    self.registerFirst = nil;
    self.registerSecond = nil;
    self.registerThird = nil;
    self.registerFour = nil;
    self.loginView = nil;
    self.scrollerView = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewBackground];
    [self configScrollerView];
    [self configRegisterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark 设置登陆背景图
- (void)setViewBackground
{
    self.view.backgroundColor = [UIColorUtil colorWithImgae:@"background"];
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self.view addSubview:backView];
}

- (void)configScrollerView
{
    self.scrollerView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.scrollerView setContentSize:CGSizeMake(UIWIDTH *5, UIHEIGHT)];
    self.scrollerView.pagingEnabled = YES;
    self.scrollerView.scrollEnabled = NO;
    [self.view addSubview:self.scrollerView];
}

#pragma -mark 登陆 & 注册 View
- (void)configRegisterView
{
    __weak LoginController *weakSelf = self;
    // 登陆
    self.loginView = [[LoginView alloc] initWithFrame:self.view.bounds];
    [self.scrollerView addSubview:self.loginView];
    
    // 注册 - 第一部
    CGRect frame = CGRectMake(UIWIDTH, 0, UIWIDTH, UIHEIGHT);
    self.registerFirst = [[RegisterView alloc] initWithFrame:frame];
    
    // 注册 - 第二步
    frame = CGRectMake(UIWIDTH*2, 0, UIWIDTH, UIHEIGHT);
    self.registerSecond = [[RegisterSecondView alloc] initWithFrame:frame];

    // 注册 - 第三步
    frame = CGRectMake(UIWIDTH*3, 0, UIWIDTH, UIHEIGHT);
    self.registerThird = [[RegisterThirdView alloc] initWithFrame:frame];
    
    // 注册 - 第四步
    frame = CGRectMake(UIWIDTH*4, 0, UIWIDTH, UIHEIGHT);
    self.registerFour = [[RegisterFourView alloc] initWithFrame:frame];
    
    [self.scrollerView addSubview:self.registerFirst];
    [self.scrollerView addSubview:self.registerSecond];
    [self.scrollerView addSubview:self.registerThird];
    [self.scrollerView addSubview:self.registerFour];
    
    self.loginView.block = ^(NSString *str){
        
        if ([str isEqualToString:@"Sign up"]) {
            [weakSelf.loginView endEditing:YES];
            [weakSelf.registerFirst become_FirstResponder];
            CGRect frame = weakSelf.view.bounds;
            frame.origin.x = UIWIDTH;
            [weakSelf.scrollerView scrollRectToVisible:frame animated:YES];
        }else if([str isEqualToString:@"Terms"]){
            // 点击条款
        }else if ([str isEqualToString:@"Login"]){
            // 登陆
            [weakSelf sendLoginAction];

        }else if ([str isEqualToString:@"Forget"]){
            // 点击忘记密码
        }
    };
    
    self.registerFirst.block = ^(NSString *str){

        if ([str isEqualToString:@"Back"]) {
            CGRect frame = weakSelf.view.bounds;
            [weakSelf.loginView become_FirstResponder];
            frame.origin.x = 0;
            [weakSelf.scrollerView scrollRectToVisible:frame animated:YES];

        }else{
            [weakSelf sendRequestFist:str];
        }
        
    };
    
    self.registerSecond.block = ^(NSString *str){
        
        if ([str isEqualToString:@"Back"]) {
            CGRect frame = weakSelf.view.bounds;
            [weakSelf.registerFirst become_FirstResponder];
            frame.origin.x = UIWIDTH;
            [weakSelf.scrollerView scrollRectToVisible:frame animated:YES];

        }else{
            [weakSelf sendRequestSecond:str];
        }
    };
    
    self.registerThird.block = ^(NSString *str){
        /*
        if ([str isEqualToString:@"Back"]) {
            CGRect frame = weakSelf.view.bounds;
            [weakSelf.registerFirst become_FirstResponder];
            frame.origin.x = UIWIDTH;
            [weakSelf.scrollerView scrollRectToVisible:frame animated:YES];

        }else{
            
        }
         */
        [weakSelf sendRequestThird:str];
    };
    
    self.registerFour.block = ^(NSString *str){
        CGRect frame = weakSelf.view.bounds;
        if ([str isEqualToString:@"Back"]) {
            [weakSelf.registerThird become_FirstResponder];
            frame.origin.x = UIWIDTH*3;
            [weakSelf.scrollerView scrollRectToVisible:frame animated:YES];
        }else if([str isEqualToString:@"takePhoto"]){
            [weakSelf getImageSourceWithType:UIImagePickerControllerSourceTypeCamera];
        }else if([str isEqualToString:@"choosePhoto"]){
            [weakSelf getImageSourceWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        } else{
            debugLog(@"开始注册");
            [weakSelf sendRequestFour:str];
        }
    };
}

#pragma -mark 打开相册
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
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
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
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        // 上传图片
        [self.registerFour setHeadImgae:img];
        
    }];
}

#pragma -mark 跳转
- (void)pushNextRegister:(NSString *)navStr
{
    CGRect frame = self.view.bounds;
    if ([navStr isEqualToString:@"Back"]) {
        [self.loginView become_FirstResponder];
        frame.origin.x = 0;
    }else{
        [self.registerSecond become_FirstResponder];
        frame.origin.x = UIWIDTH*2;
    }
    [self.scrollerView scrollRectToVisible:frame animated:YES];
}

- (void)pushThirdRegister:(NSString *)navStr
{
    CGRect frame = self.view.bounds;
    if ([navStr isEqualToString:@"Back"]) {
        [self.registerFirst become_FirstResponder];
        frame.origin.x = UIWIDTH;
    }else{
        [self.registerThird become_FirstResponder];
        frame.origin.x = UIWIDTH*3;
    }
    [self.scrollerView scrollRectToVisible:frame animated:YES];
}

- (void)pushFourRegister:(NSString *)navStr
{
    CGRect frame = self.view.bounds;
    if ([navStr isEqualToString:@"Back"]) {
        [self.registerSecond become_FirstResponder];
        frame.origin.x = UIWIDTH*2;
    }else{
        [self.registerFour become_FirstResponder];
        frame.origin.x = UIWIDTH*4;
    }
    [self.scrollerView scrollRectToVisible:frame animated:YES];
}

#pragma -mark 请求网络
// 登陆
- (void)sendLoginAction
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpTool sendRequestWithUserName:self.loginView.userName Password:self.loginView.password success:^(id json) {
        
        NSError *error = nil;
        ResponseLoginModel *res = [[ResponseLoginModel alloc] initWithString:json error:&error];
        
        debugLog(@"%d-%@",res.RETURN_CODE,res.content);

        
        if (res.RETURN_CODE == 200) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            [self handleLoginCenterManager:res.content Password:self.loginView.password];
            [self handleSetRootViewController];
        }else
            [self showErrorWithText:ErrorRequestText];
        
    } faliure:^(NSError *error) {
        [self showErrorWithText:ErrorText];
    }];
}

- (void)sendRequestFist:(NSString *)navStr
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpTool sendRequestRegisterPhoneNum:_registerFirst.phoneNumText.text success:^(id json) {
        
        ResponseManagerModel *res = [[ResponseManagerModel alloc] initWithString:json error:nil];
        if (res.RETURN_CODE == 200) {

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            [self pushNextRegister:navStr];
            
        }else
            [self showErrorWithText:ErrorRequestText];
        
    } faliure:^(NSError *error) {
        [self showErrorWithText:ErrorText];
    }];
}

- (void)sendRequestSecond:(NSString *)navStr
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpTool sendRequestRegisterCode:[_registerSecond hponeCode] PhoneNum:_registerFirst.phoneNumText.text success:^(id json) {
        ResponseManagerModel *res = [[ResponseManagerModel alloc] initWithString:json error:nil];
        if (res.RETURN_CODE == 200) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [self pushThirdRegister:navStr];
            
        }else
            [self showErrorWithText:ErrorRequestText];
    } faliure:^(NSError *error) {
        [self showErrorWithText:ErrorText];
    }];
}

- (void)sendRequestThird:(NSString *)navStr
{
    debugLog(@"注册第三步");

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [HttpTool sendRequestRegisterEmail:_registerThird.emailText.text UserName:_registerThird.userNameText.text Passwowd:_registerThird.passwordText.text PhoneNum:_registerFirst.phoneNumText.text success:^(id json) {
        
        NSError *error = nil;
        ResponseLoginModel *res = [[ResponseLoginModel alloc] initWithString:json error:&error];
        
        debugLog(@"%d-%@",res.RETURN_CODE,res.content);
        
        if (res.RETURN_CODE == 200) {

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
           
            [self handleLoginCenterManager:res.content Password:_registerThird.passwordText.text];

            [self pushFourRegister:navStr];
            
        }else
            [self showErrorWithText:ErrorRequestText];
        
    } faliure:^(NSError *error) {
        [self showErrorWithText:ErrorText];
    }];
}

- (void)sendRequestFour:(NSString *)navStr
{
    debugLog(@"注册第四步");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [HttpTool sendRequestRegisterUserInforSex:[_registerFour getSex] Age:[_registerFour getAge] success:^(id json) {
        
        ResponseManagerModel *res = [[ResponseManagerModel alloc] initWithString:json error:nil];

        if (res.RETURN_CODE == 200) {
            
            [self uploadHeadImg];
            
        }else
            [self showErrorWithText:ErrorRequestText];
        
    } faliure:^(NSError *error) {
        [self showErrorWithText:ErrorText];
    }];

}

- (void)uploadHeadImg
{
    NSData *imgData = UIImageJPEGRepresentation([_registerFour getImgData], 0.1);
    [HttpTool sendRequestUploadHeadImg:imgData success:^(id json) {
        
        ResponseManagerModel *res = [[ResponseManagerModel alloc] initWithString:json error:nil];

        if (res.RETURN_CODE == 200) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [self handleSetRootViewController];
            
        }else
            [self showErrorWithText:ErrorRequestText];
        

    } faliure:^(NSError *error) {
        [self showErrorWithText:ErrorText];
    }];
}

- (void)showErrorWithText:(NSString *)text
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    [MBProgressHUD showTextHUDAddedTo:self.view withText:text animated:YES];
}

#pragma -mark 保存用户信息到本地
- (void)handleLoginCenterManager:(LoginModel *)loginModel Password:(NSString *)xmpp_password
{
    CurrentUserInfo *user = [[CurrentUserInfo alloc]init];
    user.deviceToken = loginModel.deviceToken;
    user.userID = loginModel.userId;
    user.userHead = loginModel.iconPath;
    user.userName = loginModel.userName;
    user.userSex = loginModel.gender;
    user.userIntro = loginModel.label;
    user.userAge  = [NSString stringWithFormat:@"%d",loginModel.age];
    user.xmppPassWord = xmpp_password;
    user.isStealth = [NSString stringWithFormat:@"%d",loginModel.hide];
    UserInfoManager *manager = [UserInfoManager sharedInstance];
    [manager saveUserInfoToDisk:user];
}

- (void)handleSetRootViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setRootViewController" object:nil];
}
@end
