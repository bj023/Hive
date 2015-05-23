//
//  UserInformationController.m
//  Hive
//
//  Created by BaoJun on 15/3/31.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "UserInformationController.h"
#import "Utils.h"
#import "CustomIMGView.h"
#import "UserInformationView.h"
#import "CustomButtonView.h"
#import "NearByModel.h"

#define TopGrayBackGroundHeight 321/2
#define kHeadSize 178/2

@interface UserInformationController ()<CustomButtonViewDelegate, UIActionSheetDelegate>
{
    CGFloat _topGrayBackGroundHeight;
}
@property (strong, nonatomic) UIScrollView *scrollerView;
@property (strong, nonatomic) CustomIMGView *headIMG;// 头像
@property (strong, nonatomic) UILabel *nameLabel;// 用户名
@property (strong, nonatomic) UserInformationView *userinfor;
@property (strong, nonatomic) UILabel *introLabel;
@property (strong, nonatomic) UITextView *introText;
@property (strong, nonatomic) CustomButtonView *buttonView;
@end

@implementation UserInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configScrollerView];
    [self configTopView];
    [self configHeadView];
    [self configToolBarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)setViewBackground
{
    self.view.backgroundColor = [UIColor whiteColor];
}
#pragma -mark 初始化 scrollerView
- (void)configScrollerView
{
    if (!self.scrollerView) {
        self.scrollerView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        self.scrollerView.backgroundColor = [UIColor whiteColor];
        self.scrollerView.pagingEnabled = YES;
        [self.view addSubview:self.scrollerView];
    }
}
#pragma -mark 初始化底部工具栏
- (void)configToolBarView
{
    UIButton *toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toolBtn.frame =CGRectMake(0, UIHEIGHT - 50, UIWIDTH, 50);
    [toolBtn setTitle:@"CLOSE" forState:UIControlStateNormal];
    [toolBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[toolBtn setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:100/255.0 green:186/255.0 blue:255/255.0 alpha:0.5] size:toolBtn.frame.size] forState:UIControlStateNormal];
    //[toolBtn setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:100/255.0 green:186/255.0 blue:255/255.0 alpha:0.6] size:toolBtn.frame.size] forState:UIControlStateHighlighted];
    //关闭颜色
    toolBtn.backgroundColor = [UIColor colorWithRed:100/255.0 green:186/255.0 blue:255/255.0 alpha:1];
    toolBtn.titleLabel.font = [UIFont fontWithName:GothamRoundedBold size:18];
    [self.view addSubview:toolBtn];
    [toolBtn addTarget:self action:@selector(clickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
}
// 关闭按钮点击事件
- (void)clickCloseBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)buttonImageFromColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma -mark 初始化 头部灰色背景
- (void)configTopView
{
    _topGrayBackGroundHeight = TopGrayBackGroundHeight * self.view.frame.size.width / 375;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWIDTH, _topGrayBackGroundHeight)];
    topView.backgroundColor = [UIColorUtil colorWithHexString:@"#f1efee"];
    [self.view addSubview:topView];
}

#pragma -mark 初始化 用户头像
- (void)configHeadView
{
    CGFloat headW = kHeadSize; // 改变 头像大小 只需改变 headW
    CGFloat HeadH = headW;
    CGFloat headX = UIWIDTH/2 - HeadH/2;
    CGFloat headY = _topGrayBackGroundHeight - HeadH/2;
    
    
    if (!self.headIMG) {
        /*
        CGFloat lineW = 6; // 代表2 像素
        UIImageView *headBG = [[UIImageView alloc] initWithFrame:CGRectMake(headX - lineW, headY - lineW, headW + lineW, HeadH + lineW)];
        headBG.layer.cornerRadius = headBG.frame.size.height/2;
        headBG.clipsToBounds = YES;
        headBG.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:headBG];
        */
        
        self.headIMG = [[CustomIMGView alloc] initWithFrame:CGRectMake(headX, headY, headW, HeadH)];
        self.headIMG.layer.cornerRadius = HeadH/2;
        self.headIMG.clipsToBounds = YES;
        self.headIMG.backgroundColor = [UIColor lightTextColor];
        [self.view addSubview:self.headIMG];

    }
    
    CGFloat nameX = 20;
    CGFloat nameY = headY + HeadH + 5; // 偏移量
    CGFloat nameW = UIWIDTH - nameX * 2;
    CGFloat nameH = 44;
    if (!self.nameLabel) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, nameY, nameW, nameH)];
        self.nameLabel.font = [UIFont fontWithName:Font_Regular size:17];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.textColor = [UIColor blackColor];
        [self.view addSubview:self.nameLabel];
    }
    
    CGFloat userInfoW = UIWIDTH;
    CGFloat userInfoH = 20;
    CGFloat userInfoX = UIWIDTH/2 - userInfoW/2;
    CGFloat userInfoY = nameY + nameH + 5;// 偏移量
    if (!self.userinfor) {
        self.userinfor = [[UserInformationView alloc] initWithFrame:CGRectMake(userInfoX, userInfoY, userInfoW, userInfoH)];
        [self.userinfor set_UserInfoData:self.model.gender
                                     Age:[NSString stringWithFormat:@"%d",self.model.age]
                                Distance:self.model.distance];
        [self.view addSubview:self.userinfor];
    }
    
    NSString *introString = self.model.label;
    UIFont *introFont = [UIFont systemFontOfSize:16];
    CGFloat introW = 600/2;
    CGFloat introX = UIWIDTH/2 - introW/2;
    CGFloat introY = userInfoY + userInfoH + 8;// 偏移量
    CGSize introSize;
    if (!self.introText) {
        
        introSize = [self sizeWithString:introString font:introFont maxSize:CGSizeMake(introW, MAXFLOAT)];

        /*
        self.introLabel = [[UILabel alloc] initWithFrame:CGRectMake(introX, introY, introW, 80)];
        self.introLabel.numberOfLines = 0;
        self.introLabel.backgroundColor = [UIColor clearColor];
        self.introLabel.textAlignment = NSTextAlignmentCenter;
        self.introLabel.textColor = [UIColorUtil colorWithHexString:@"#aeaeae"];

        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:introString];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:14];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [introString length])];
        [self.introLabel setAttributedText:attributedString1];
        [self.introLabel sizeToFit];

        [self.view addSubview:self.introLabel];
         */
        
        self.introText = [[UITextView alloc] init];
        self.introText.frame = CGRectMake(introX, introY, introW, introSize.height + 30);
        self.introText.textColor = [UIColorUtil colorWithHexString:@"#aeaeae"];
        self.introText.userInteractionEnabled = NO;
        self.introText.font = introFont;
        [self.view addSubview:self.introText];
        self.introLabel.backgroundColor = [UIColor redColor];
        
        //    textview 改变字体的行间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4;// 字体的行间距
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{
                                     NSFontAttributeName : introFont,
                                     NSParagraphStyleAttributeName : paragraphStyle,
                                     NSForegroundColorAttributeName : [UIColorUtil colorWithHexString:@"#aeaeae"]
                                     };
        self.introText.attributedText = [[NSAttributedString alloc] initWithString:introString attributes:attributes];
    }
    
    CGFloat buttonX = 0;
    //CGFloat buttonY = introY + self.introText.frame.size.height + 40;// 偏移量
    CGFloat buttonY = 807/2;
    CGFloat buttonW = UIWIDTH;
    CGFloat buttonH = 134/2;
    if (!self.buttonView) {
        self.buttonView = [[CustomButtonView alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        [self.buttonView set_DataFollow:self.model.isFriend];
        [self.buttonView set_DataBlock:self.model.isBlocked];
        self.buttonView.delegate = self;
        [self.view addSubview:self.buttonView];
    }
    
    self.scrollerView.contentSize = CGSizeMake(self.view.frame.size.width, buttonH + buttonY);
    
    NSString *urlString = [NSString stringWithFormat:@"%d",self.model.userId];
    urlString = User_Head(urlString);
    [self.headIMG setImageURLStr:urlString];
    self.nameLabel.text = self.model.userName;
    self.introLabel.text = introString;
    //self.introLabel.text = @"There's stuff there about what food's good for what brain functionuff there about what food's";
}

- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font };
    // 如果将来计算的文字的范围超过了指定的范围，返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围，返回的就是真实的范围
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

- (void)clickButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            if (self.pushType == PushNextNoneVC) {
                [self clickCloseBtn:nil];
            }else
                [self clickTalk];
            break;
        case 1:
            [self sendFollow];
            break;
        case 2:
            [self showBlockAlert];
            break;
        default:
            break;
    }
}

- (void)showBlockAlert
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Block"
                                                             delegate:self
                                                    cancelButtonTitle:@"cancel"
                                               destructiveButtonTitle:@"block"
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    /*
    UIAlertView *blockAlert = [[UIAlertView alloc] initWithTitle:@"Block?"
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"No"
                                               otherButtonTitles:@"Yes", nil];
    [blockAlert show];
     */
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self sendBlockRequest];
    }
}

#pragma -mark 网络请求
- (void)sendFollow
{
    if (self.model.isFriend == 0) {
        [self sendFollowRequest];
    }else if (self.model.isFriend == 1){
        [self sendCancelFollowRequest];
    }
}

- (void)sendFollowRequest
{
    [HttpTool sendRequestWithFollow:[NSString stringWithFormat:@"%d",self.model.userId] success:^(id json) {
        ResponseFollowModel *themodel = [[ResponseFollowModel alloc] initWithString:json error:nil];

        if (themodel.RETURN_CODE == 200) {
            // 关注成功
            self.model.isFriend = 1;
            [self.buttonView set_DataFollow:self.model.isFriend];
            [self updateFollow];
        }else{
            // 关注失败
            [self showHudWith:ErrorRequestText];

        }
        
    } faliure:^(NSError *error) {
        // 请求失败
        [self showHudWith:ErrorText];

    }];
}

- (void)sendCancelFollowRequest
{
    [HttpTool sendRequestWithCancelFollow:[NSString stringWithFormat:@"%d",self.model.userId] success:^(id json) {
        ResponseFollowModel *themodel = [[ResponseFollowModel alloc] initWithString:json error:nil];
        if (themodel.RETURN_CODE == 200) {
            // 取消关注成功
            self.model.isFriend = 0;
            [self.buttonView set_DataFollow:self.model.isFriend];
            [self updateFollow];
        }else{
            // 取消关注失败
            [self showHudWith:ErrorRequestText];

        }
        
    } faliure:^(NSError *error) {
        // 请求失败
        [self showHudWith:ErrorText];

    }];
}

- (void)sendBlockRequest
{
    [HttpTool sendRequestWithBLockUser:[NSString stringWithFormat:@"%d",self.model.userId] success:^(id json) {
        ResponseFollowModel *themodel = [[ResponseFollowModel alloc] initWithString:json error:nil];
        if (themodel.RETURN_CODE == 200) {
            // 屏蔽成功
            self.model.isBlocked = 1;
            [self removeBlock];
        }else{
            // 屏蔽失败
            [self showHudWith:ErrorRequestText];
        }

    } faliure:^(NSError *error) {
        // 请求失败
        [self showHudWith:ErrorText];

    }];
}

- (void)showHudWith:(NSString *)text
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [MBProgressHUD showTextHUDAddedTo:self.view withText:text animated:YES];
}

- (void)clickTalk
{
    if ([self.delegate respondsToSelector:@selector(talkCellWithNearByModel:IndexPath:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate talkCellWithNearByModel:self.model IndexPath:self.indexPath];
    }
}

- (void)updateFollow
{
    if ([self.delegate respondsToSelector:@selector(followCellWithNearByModel:IndexPath:PUSHTYPE:)]) {
        [self.delegate followCellWithNearByModel:self.model IndexPath:self.indexPath PUSHTYPE:self.pushType];
    }
}

- (void)removeBlock
{
    if ([self.delegate respondsToSelector:@selector(blockCellWithNearByModel:IndexPath:PUSHTYPE:)]) {
        [self.delegate blockCellWithNearByModel:self.model IndexPath:self.indexPath PUSHTYPE:self.pushType];
    }
    [self.buttonView set_DataBlock:self.model.isBlocked];
    [self clickCloseBtn:nil];
}

- (void)dealloc
{
    self.headIMG = nil;
    self.nameLabel = nil;
    self.userinfor = nil;
    self.buttonView = nil;
    self.scrollerView = nil;
}
@end
