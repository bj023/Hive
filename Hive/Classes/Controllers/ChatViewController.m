//
//  ChatViewController.m
//  Hive
//
//  Created by 那宝军 on 15/4/26.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ChatViewController.h"
#import "Utils.h"
#import "MessageToolBar.h"
#import "chatViewCell.h"
#import "ChatModel.h"
#import "NSTimeUtil.h"
#import "ChatMessageDelegate.h"
#import "UserInformationController.h"

@interface ChatViewController ()<MessageToolBarDelegate, UITableViewDataSource, UITableViewDelegate ,ChatMessageDelegate ,ChatViewCellDelegate>
{
    
}
@property (strong, nonatomic)MessageToolBar *chatToolBar;

@property (strong, nonatomic)UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *mesgaeArr;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavBar];
    [self setBackGround];
    [self configMessageArr];
    [self configTableView];
    [self configMessageToolBar];
    [XMPPManager sharedInstance].delegate = self;;

    debugLog(@"聊天用户ID->%@",self.userID);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)setBackGround
{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)configMessageArr
{
    self.mesgaeArr = [NSMutableArray arrayWithArray:[ChatModel MR_findAll]];
    
    
    for (ChatModel *model in [ChatModel MR_findAll]) {
        debugLog(@"记录ID->%@-%@",model.id,model.hasRead);
        debugLog(@"记录read->%@",model.hasRead);
        debugLog(@"记录flag->%@",model.flag);
    }

    if (self.mesgaeArr.count == 0) {
        return;
    }
    debugLog(@"%ld",self.mesgaeArr.count);
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesgaeArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}

- (void)configNavBar
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColorUtil colorWithHexString:@"#1e2d3b"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 60, 30);
    backBtn.titleLabel.font = NavTitleFont;
    UIBarButtonItem *bacgItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = bacgItem;
    [backBtn addTarget:self action:@selector(backNav) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backNav
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark 初始化 表格
- (void)configTableView
{
    if (!self.tableView) {
        CGRect frame = self.view.bounds;
        frame.size.height -= (64 + [MessageToolBar defaultHeight]);
        self.tableView                 = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate        = self;
        self.tableView.dataSource      = self;
        [self.view addSubview:self.tableView];
        
        [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)]];
    }
}

#pragma -mark MessageToolBar
- (void)configMessageToolBar
{
    if (!self.chatToolBar) {
        self.chatToolBar = [[MessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [MessageToolBar defaultHeight], self.view.frame.size.width, [MessageToolBar defaultHeight])];
        self.chatToolBar.delegate = self;
        self.chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.view addSubview:self.chatToolBar];
    }
}

#pragma -mark TableView 回调
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mesgaeArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatModel *message = self.mesgaeArr[indexPath.row];
    return [chatViewCell getCellHeight:message];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    chatViewCell *cell = [chatViewCell cellWithTableView:tableView Delegate:self];
    cell.indexPath = indexPath;
    cell.message = self.mesgaeArr[indexPath.row];

    return cell;
}

- (void)tapHeadImgSendActionWithMessage:(ChatModel *)message
{
    //点击头像 查看个人信息
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpTool sendRequestProfileWithUserID:message.userID success:^(id json) {
        ResponseChatUserInforModel *res = [[ResponseChatUserInforModel alloc] initWithString:json error:nil];
        if (res.RETURN_CODE == 200) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            // 跳转
            [self pushUserInforVC:res.RETURN_OBJ];
        }else
            [self showHudWith:ErrorRequestText];
        
    } faliure:^(NSError *error) {
        [self showHudWith:ErrorText];
    }];
}

- (void)showHudWith:(NSString *)text
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showTextHUDAddedTo:self.view withText:text animated:YES];
}

- (void)pushUserInforVC:(NearByModel *)model
{
    UserInformationController *vc = [[UserInformationController alloc] init];
    vc.pushType = PushNextNoneVC;
    vc.model = model;
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MessageToolBarDelegate
- (void)inputTextViewWillBeginEditing:(MessageTextView *)messageInputTextView{
    //[_menuController setMenuItems:nil];
    debugMethod();
}

- (void)inputTextViewDidBeginEditing:(MessageTextView *)messageInputTextView
{
    debugMethod();
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    CGRect rect = self.tableView.frame;
    rect.origin.y = 0;
    rect.size.height = self.view.frame.size.height - toHeight - [MessageToolBar defaultHeight] - 20 + 64;
    self.tableView.frame = rect;
    
    [self scrollViewToBottom:NO];
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self sendTextMessage:text];
    }
}

- (void)didSendFace:(NSString *)faceLocalPath
{
    debugMethod();
}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

- (void)scrollToRowWithMessageID:(NSString *)messageID
{
    ChatModel *model = [ChatModel MR_findFirstByAttribute:@"messageID" withValue:messageID];
    
    [self.mesgaeArr addObject:model];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesgaeArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)sendTextMessage:(NSString *)textMessage
{
    NSString *currentTime = [UtilDate getCurrentTime];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *messageID = [NSString stringWithFormat:@"%@_%@",self.userID,timeSp];
    
    [self saveDateMessage:textMessage Time:currentTime MessgaeID:messageID];
    
}

- (void)saveDateMessage:(NSString *)message Time:(NSString *)currentTime MessgaeID:(NSString *)messageID
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        ChatModel *model = [ChatModel MR_createInContext:localContext];
        model.id = [NSNumber numberWithInteger:(self.mesgaeArr.count + 1)];
        model.userID = self.userID;
        model.userName = self.userName;
        model.message = message;
        model.time = currentTime;
        model.flag = @"ME";
        model.longitude = [[NSTimeUtil sharedInstance] getCoordinateLongitude];
        model.latitude = [[NSTimeUtil sharedInstance] getCoordinateLatitude];
        model.messageID = messageID;
        model.hasTime = [self getTime:currentTime];
        model.hasRead = @"NO";
        
    } completion:^(BOOL success, NSError *error) {
        
        [self scrollToRowWithMessageID:messageID];
        
        [[XMPPManager sharedInstance] sendNewMessage:message MessageID:messageID UserID:self.userID Time:currentTime];

    }];
}

- (NSString *)getTime:(NSString *)currentTime
{
    NSArray *array = [ChatModel MR_findAll];
    if (array.count == 0) {
        return currentTime;
    }
    
    ChatModel *model = [array lastObject];
    
    NSString *h_current = [UtilDate dateFromString:currentTime withFormat:DateFormat_HH];
    NSString *h_time = [UtilDate dateFromString:model.time withFormat:DateFormat_HH];
    
    NSString *m_current = [UtilDate dateFromString:currentTime withFormat:DateFormat_mm];
    NSString *m_time = [UtilDate dateFromString:model.time withFormat:DateFormat_mm];
    
    debugLog(@"chat->%@-%@  %@-%@",h_current,h_time,m_current,m_time);
    
    if ([h_current intValue]>[h_time intValue] || ([m_current intValue] - [m_time intValue] > 5)) {
        return currentTime;
    }
    return @"";
}

#pragma mark- 聊天 回调
- (void)sendPrivateMessageSuccessMessage:(NSString *)messageID
{
    
    for (int i = 0 ;i< self.mesgaeArr.count ; i++) {
        
        ChatModel *model = self.mesgaeArr[i];

        if ([model.messageID isEqualToString:messageID]) {

            //ChatModel *chatModel = [ChatModel MR_findFirstByAttribute:@"messageID" withValue:messageID];
            //model.isSend = @"YES";
            //[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstname ==[c] %@ AND lastname ==[c] %@", firstname, lastname];
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                
                ChatModel *chatModel = [ChatModel MR_findFirstByAttribute:@"messageID" withValue:messageID inContext:localContext];
                chatModel.isSend = @"YES";
                
            } completion:^(BOOL success, NSError *error) {
                
                debugLog(@"修改成功");
                
            }];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                chatViewCell *cell = (chatViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [cell set_sendMessageState:YES];
            });
            
            return;
        }
    }
}

- (void)receiveChatMessageWithMessageID:(NSString *)messageID
{
    debugMethod();
    [self scrollToRowWithMessageID:messageID];
}

- (void)receiptsChatMessageWithMessageID:(NSString *)messageID
{
    for (int i = 0 ;i< self.mesgaeArr.count ; i++) {
        
        ChatModel *model = self.mesgaeArr[i];
        
        debugLog(@"%@-%@",messageID,model.messageID);
        
        if ([model.messageID isEqualToString:messageID]) {
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                
                ChatModel *chatModel = [ChatModel MR_findFirstByAttribute:@"messageID" withValue:messageID inContext:localContext];
                chatModel.hasRead = @"YES";
                
            } completion:^(BOOL success, NSError *error) {
                debugLog(@"修改成功");
            }];

            
            dispatch_async(dispatch_get_main_queue(), ^{
                chatViewCell *cell = (chatViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [cell set_hasReadMessageState:YES];
            });
            
            return;
        }
    }
}

#pragma mark - GestureRecognizer
// 点击背景隐藏
-(void)keyBoardHidden
{
    [self set_HiddenKeyboard];
}

- (void)set_HiddenKeyboard
{
    [self.chatToolBar endEditing:YES];
}

- (void)dealloc
{
    self.chatToolBar = nil;
    self.tableView = nil;
    self.mesgaeArr = nil;
}
@end
