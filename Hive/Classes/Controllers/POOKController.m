//
//  POOKController.m
//  Hive
//
//  Created by 那宝军 on 15/5/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "POOKController.h"
#import "Utils.h"
#import "MessageToolBar.h"
#import "ChatRoomCell.h"
#import "ChatManager.h"
#import "ChatRoomModel.h"
#import "NSTimeUtil.h"
#import "ChatMessageDelegate.h"
#import "UserInformationController.h"
#import "ChatSendMessage.h"
#import "DataBaseModel.h"

#define kChatCount 20

@interface POOKController ()<   UITableViewDelegate, UITableViewDataSource, MessageToolBarDelegate, ChatRoomViewCellDelegate, ChatPublicMessageDelegate>
{
    dispatch_queue_t _messageQueue;
    
    
    NSString *_isAname;
    
    NSString *_lastTime;
    
    UIRefreshControl *_refreshControl;

}
@property (strong, nonatomic)MessageToolBar *chatToolBar;
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *mesgaeArr;

@end



@implementation POOKController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackGround];
    [self configMessageArr];
    [self configTableView];
    [self configMessageToolBar];
    [XMPPManager sharedInstance].publicDelegate = self;
    _messageQueue = dispatch_queue_create("easemob.com", NULL);
}

- (void)startRun
{
    dispatch_queue_t myCustomQueue = dispatch_queue_create("example.MyCustomQueue", NULL);
    dispatch_async(myCustomQueue, ^{
        
        while (1) {
            debugLog(@"example.MyCustomQueue Do some work here.");
            sleep(1);
        }
        
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark 设置背景
- (void)setBackGround
{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)configMessageArr
{
    self.mesgaeArr = [NSMutableArray array];
    
    NSArray *array = [DataShareInstance getChatsCount:kChatCount];
    
    
    NSRange range = NSMakeRange(0, [array count]);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.mesgaeArr insertObjects:array atIndexes:indexSet];
    
    
    for (ChatRoomModel *model in [ChatRoomModel MR_findAll]) {
        debugLog(@"%@-%@",model.id,model.msg_Interval_time);
    }
    
    
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
                
        _refreshControl = [[UIRefreshControl alloc] init];
        //refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
        [_refreshControl addTarget:self action:@selector(beginPullDownRefreshing:) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:_refreshControl];
        
    }
}

- (void)beginPullDownRefreshing:(id)sender
{
    [_refreshControl endRefreshing];
    NSArray *array = [DataShareInstance getChatsCount:kChatCount];
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
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (IsEmpty(message.userID)) {
        [self showHudWith:RequestFailText];
        return;
    }
    
    [HttpTool sendRequestProfileWithUserID:message.userID success:^(id json) {
        ResponseChatUserInforModel *res = [[ResponseChatUserInforModel alloc] initWithString:json error:nil];
        if (res.RETURN_CODE == 200) {
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
// 发送文本
- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self sendTextMessage:text];
    }
}
// 发送 图片
- (void)didSendFace:(NSString *)faceLocalPath
{
    [self sendImageMessage:faceLocalPath];
}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
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

#pragma -mark 发送文本消息
-(void)sendTextMessage:(NSString *)textMessage
{
    NSString *currentTime = [UtilDate getCurrentTime];
    NSString *userID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *messageID = [NSString stringWithFormat:@"%@_%@",userID,timeSp];
    

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        ChatRoomModel *model = [ChatRoomModel MR_createInContext:localContext];
        model.id = [NSDataUtil setChatRoomDataID];
        model.userID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
        model.userName = [[UserInfoManager sharedInstance] getCurrentUserInfo].userName;
        model.hasAname = self.chatToolBar.aNameLength>0?_isAname:@"";
        model.msg_message = textMessage;
        model.messageID = messageID;
        model.msg_time = currentTime;
        model.msg_flag = @"ME";
        model.msg_hasTime = [XMPPManager getChatRoomTime:currentTime];
        model.msg_longitude = [[NSTimeUtil sharedInstance] getCoordinateLongitude];
        model.msg_latitude = [[NSTimeUtil sharedInstance] getCoordinateLatitude];
        model.msg_send_type = @(SendCHatMessageNomal);
        model.msg_type = @(SendChatMessageChatType);
        model.msg_Interval_time = [UtilDate getCurrentTimeInterval];

        debugLog(@"收到聊天大厅创建记录->%@",model.id);

    } completion:^(BOOL success, NSError *error) {
        
        [self refreshDataWithMessageID:messageID];
        [self sendTextMessage:textMessage SendMessageTime:currentTime MessageID:messageID];
        
    }];
}

- (void)sendImageMessage:(NSString *)imagePath
{
    NSString *currentTime = [UtilDate getCurrentTime];
    NSString *userID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *messageID = [NSString stringWithFormat:@"%@_%@",userID,timeSp];
    
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        ChatRoomModel *model = [ChatRoomModel MR_createInContext:localContext];
        model.id = [NSDataUtil setChatRoomDataID];
        model.userID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
        model.userName = [[UserInfoManager sharedInstance] getCurrentUserInfo].userName;
        //model.hasAname = self.chatToolBar.aNameLength>0?_isAname:@"";
        model.hasAname = @"";
        model.msg_message = imagePath;
        model.messageID = messageID;
        model.msg_time = currentTime;
        model.msg_flag = @"ME";
        model.msg_hasTime = [XMPPManager getChatRoomTime:currentTime];
        model.msg_longitude = [[NSTimeUtil sharedInstance] getCoordinateLongitude];
        model.msg_latitude = [[NSTimeUtil sharedInstance] getCoordinateLatitude];
        model.msg_send_type = @(SendCHatMessageNomal);
        model.msg_type = @(SendChatMessageChatIMGType);
        model.msg_Interval_time = [UtilDate getCurrentTimeInterval];
        
    } completion:^(BOOL success, NSError *error) {
        
        [self refreshDataWithMessageID:messageID];
        [self sendImageMessage:imagePath SendMessageTime:currentTime MessageID:messageID];
    }];
}

- (void)sendImageMessage:(NSString *)textMessage
         SendMessageTime:(NSString *)msg_time
               MessageID:(NSString *)msg_ID
{
    [ChatSendMessage sendTextMessageWithString:textMessage
                               SendMessageTime:msg_time
                                 SendMessageID:msg_ID
                                      AtUserID:_isAname
                                     IsChatIMG:YES
                                      CallBack:^(SendChatMessageStateType
                                                                     sendState, NSString *msg_ID) {
                                         [self updateSendMessageState:sendState MessageID:msg_ID];
                                     }];
     
}


- (void)sendTextMessage:(NSString *)textMessage
        SendMessageTime:(NSString *)msg_time
              MessageID:(NSString *)msg_ID
{
    
    [ChatSendMessage sendTextMessageWithString:textMessage
                               SendMessageTime:msg_time
                                 SendMessageID:msg_ID
                                      AtUserID:_isAname
                                     IsChatIMG:NO
                                      CallBack:^(SendChatMessageStateType
                                                 sendState, NSString *msg_ID) {
                                          _isAname = @"";

                                          [self updateSendMessageState:sendState MessageID:msg_ID];
                                      }];

}

// 添加一条消息
/*
- (void)refreshDataWithMessageID:(NSString *)msgID
{
    __weak POOKController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        ChatRoomModel *model = [ChatRoomModel MR_findFirstByAttribute:@"messageID" withValue:msgID];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.mesgaeArr addObject:model];
            //[weakSelf.tableView reloadData];
            [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.mesgaeArr.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.mesgaeArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        });
    });
}
*/
- (void)refreshDataWithMessageID:(NSString *)msgID
{
    ChatRoomModel *model = [ChatRoomModel MR_findFirstByAttribute:@"messageID" withValue:msgID];
    [self.mesgaeArr addObject:model];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesgaeArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

// 修改发送状态
- (void)updateSendMessageState:(NSInteger)state MessageID:(NSString *)msgID
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        ChatRoomModel *chatModel = [ChatRoomModel MR_findFirstByAttribute:@"messageID" withValue:msgID inContext:localContext];
        chatModel.msg_send_type = @(state);
        
    } completion:^(BOOL success, NSError *error) {
        debugLog(@"发送状态->修改成功");
        //[self refreshDataWithMessageID:msgID];
        
        [self.mesgaeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             if ([obj isKindOfClass:[ChatRoomModel class]])
             {
                 ChatRoomModel *model = (ChatRoomModel*)obj;
                 if ([model.messageID isEqualToString:msgID])
                 {
                     model.msg_send_type = @(state);
                     *stop = YES;
                 }
             }
         }];
        [self.tableView reloadData];
        /*
        for (int i = 0 ;i< self.mesgaeArr.count ; i++) {
            ChatRoomModel *model = self.mesgaeArr[i];
            if ([model.messageID isEqualToString:msgID]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
                
                return;
            }
        }
         */
    }];
}

#pragma -mark xmpp 代理回调
- (void)didReceivChatRoomeMessageId:(NSString *)msg_ID
{
    [self refreshDataWithMessageID:msg_ID];
}

- (void)dealloc
{
    self.chatToolBar = nil;
    self.tableView = nil;
    self.mesgaeArr = nil;
}
@end
