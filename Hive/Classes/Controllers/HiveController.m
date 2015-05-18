//
//  HiveController.m
//  Hive
//
//  Created by BaoJun on 15/3/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "HiveController.h"
#import "Utils.h"
#import "MessageToolBar.h"
#import "ChatRoomCell.h"
#import "ChatRoomModel.h"
#import "NSTimeUtil.h"
#import "ChatMessageDelegate.h"
#import "UserInformationController.h"
#import "DataBaseModel.h"

@interface HiveController ()<MessageToolBarDelegate, UITableViewDataSource, UITableViewDelegate, ChatPublicMessageDelegate, ChatRoomViewCellDelegate>
{
    NSString *_isAname;
    
    NSString *_lastTime;
    
    UIRefreshControl *_refreshControl;
}
@property (strong, nonatomic)MessageToolBar *chatToolBar;

@property (strong, nonatomic)UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *mesgaeArr;
@end

@implementation HiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    [self configMessageArr];
    [self configMessageToolBar];
    [XMPPManager sharedInstance].publicDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configMessageArr
{
    
    for (ChatRoomModel *model in [ChatRoomModel MR_findAll]) {
        debugLog(@"%@",model.msg_Interval_time);
    }
    
    self.mesgaeArr = [NSMutableArray array];
    
    NSArray *array = [DataBaseModel getChatWithStartChatRoom:nil andCount:10];
    NSRange range = NSMakeRange(0, [array count]);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.mesgaeArr insertObjects:array atIndexes:indexSet];
    
    if (self.mesgaeArr.count == 0) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesgaeArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });
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
        
        //[self.tableView addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)]];
        
        _refreshControl = [[UIRefreshControl alloc] init];
        //refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
        [_refreshControl addTarget:self action:@selector(beginPullDownRefreshing:) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:_refreshControl];
        
    }
}

- (void)beginPullDownRefreshing:(id)sender
{
    [_refreshControl endRefreshing];
    
    NSArray *array = [DataBaseModel getChatWithStartChatRoom:_mesgaeArr.count==0?nil:self.mesgaeArr[0] andCount:10];
    NSRange range = NSMakeRange(0, [array count]);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.mesgaeArr insertObjects:array atIndexes:indexSet];

    [self.tableView reloadData];

}

#pragma -mark MessageToolBar
- (void)configMessageToolBar
{
    if (!self.chatToolBar) {
        CGRect frame = CGRectMake(0, self.view.frame.size.height - [MessageToolBar defaultHeight] - 64, self.view.frame.size.width, [MessageToolBar defaultHeight]);
        self.chatToolBar = [[MessageToolBar alloc] initWithFrame:frame isPulicChat:YES];
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
    
    ChatRoomModel *moel = self.mesgaeArr[indexPath.row];

    return [ChatRoomCell getCellHeight:moel];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatRoomCell *cell = [ChatRoomCell cellWithTableView:tableView Delegate:self];
    cell.indexPath = indexPath;
    cell.message = self.mesgaeArr[indexPath.row];
    return cell;
}

#pragma -mark cell 代理 
- (void)tapHeadImgSendActionWithMessage:(ChatRoomModel *)message
{
    //点击头像 查看个人信息
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpTool sendRequestProfileWithUserID:message.userID success:^(id json) {
        ResponseChatUserInforModel *res = [[ResponseChatUserInforModel alloc] initWithString:json error:nil];
        if (res.RETURN_CODE == 200) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            // 跳转
            self.hiveBlock(res.RETURN_OBJ);
        }else
            [self showHudWith:ErrorRequestText];
        
    } faliure:^(NSError *error) {
        [self showHudWith:ErrorText];
    }];
}

- (void)tapBubbleSendActionWithMessage:(ChatRoomModel *)message
{
    // @某人
    if (![message.msg_flag isEqualToString:@"ME"]) {
        NSString *aName = [NSString stringWithFormat:@"@%@ ",message.userName];
        _isAname = message.userID;
        self.chatToolBar.inputTextView.text = aName;
        self.chatToolBar.aNameLength = [aName length];
    }
}

- (void)showHudWith:(NSString *)text
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [MBProgressHUD showTextHUDAddedTo:self.view withText:text animated:YES];
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
    rect.size.height = self.view.frame.size.height - toHeight - [MessageToolBar defaultHeight] - 20;
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

-(void)sendTextMessage:(NSString *)textMessage
{
    NSString *currentTime = [UtilDate getCurrentTime];
    NSString *userID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *messageID = [NSString stringWithFormat:@"%@_%@",userID,timeSp];
    
    [self saveDateMessage:textMessage Time:currentTime MessgaeID:messageID];
    
}

- (void)saveDateMessage:(NSString *)message Time:(NSString *)currentTime MessgaeID:(NSString *)messageID
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        ChatRoomModel *model = [ChatRoomModel MR_createInContext:localContext];
        model.id = [NSNumber numberWithInteger:(self.mesgaeArr.count + 1)];
        model.userID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
        model.messageID = messageID;
        model.hasAname = self.chatToolBar.aNameLength>0?_isAname:@"";

        model.msg_message = message;
        model.msg_time = currentTime;
        model.msg_flag = @"ME";
        model.msg_longitude = [[NSTimeUtil sharedInstance] getCoordinateLongitude];
        model.msg_latitude = [[NSTimeUtil sharedInstance] getCoordinateLatitude];
        model.msg_hasTime = [XMPPManager getChatRoomTime:currentTime];
        model.msg_isSend = @"NO";
        model.msg_Interval_time = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]];
        
    } completion:^(BOOL success, NSError *error) {
        [self scrollToRowWithMessageID:messageID];
        
        [[XMPPManager sharedInstance] sendNewMessage:message Time:currentTime Message:messageID isAname:_isAname];
        // @某人 发送成功后请空
        _isAname = @"";
    }];
}

#pragma mark- 聊天 回调
- (void)sendPublicMessageSuccessMessageID:(NSString *)messageID Send:(BOOL)isSend
{
    
    for (int i = 0 ;i< self.mesgaeArr.count ; i++) {
        ChatRoomModel *model = self.mesgaeArr[i];

        if ([model.messageID isEqualToString:messageID]) {
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                
                ChatRoomModel *chatRoom = [ChatRoomModel MR_findFirstByAttribute:@"messageID" withValue:messageID inContext:localContext];
                chatRoom.msg_isSend = isSend?@"YES":@"NO";

            } completion:^(BOOL success, NSError *error) {
                
                debugLog(@"修改成功");
                
            }];

            
            dispatch_async(dispatch_get_main_queue(), ^{
                ChatRoomCell *cell = (ChatRoomCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [cell set_sendMessageState:isSend];
            });
            
            return;
        }
    }
}

- (void)receiveChatRoomMessageWithMessageID:(NSString *)messageID
{
    debugMethod();
    [self scrollToRowWithMessageID:messageID];
}

- (void)scrollToRowWithMessageID:(NSString *)messageID
{
    ChatRoomModel *model = [ChatRoomModel MR_findFirstByAttribute:@"messageID" withValue:messageID];
    
    [self.mesgaeArr addObject:model];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.mesgaeArr.count-2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//
//    });
    [self.tableView reloadData];

    debugLog(@"%@",self.mesgaeArr);
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesgaeArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark- GestureRecognizer
// 点击背景隐藏
-(void)keyBoardHidden
{
    [self set_HiddenKeyboard];
}

- (void)set_HiddenKeyboard
{
    [self.chatToolBar endEditing:YES];
}

#pragma -mark  Menu菜单
//允许 Menu菜单
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//每个cell都会点击出现Menu菜单
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return YES;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    debugMethod();
}

- (void)dealloc
{
    self.chatToolBar = nil;
    self.tableView = nil;
    self.mesgaeArr = nil;
}
@end
