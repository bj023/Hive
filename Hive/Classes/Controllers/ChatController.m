//
//  ChatController.m
//  Hive
//
//  Created by 那宝军 on 15/5/20.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "ChatController.h"
#import "Utils.h"
#import "MessageToolBar.h"
#import "chatViewCell.h"
#import "ChatManager.h"
#import "ChatModel.h"
#import "NSTimeUtil.h"
#import "ChatMessageDelegate.h"
#import "UserInformationController.h"
#import "ChatSendMessage.h"
#import "UIActionSheet+Block.h"
#import "DataBaseModel.h"
#import "MessageModel.h"

@interface ChatController ()<   UITableViewDelegate,
                                UITableViewDataSource,UIActionSheetDelegate,
                                MessageToolBarDelegate,
                                ChatViewCellDelegate, ChatPrivateMessageDelegate>
{
    dispatch_queue_t _messageQueue;
    dispatch_queue_t _messageReadQueue;
}
@property (strong, nonatomic)MessageToolBar *chatToolBar;
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *mesgaeArr;
@end


@implementation ChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self setBackGround];
    [self configTableView];
    [self configMessageToolBar];
    [XMPPManager sharedInstance].privatedelegate = self;
    _messageQueue = dispatch_queue_create("easemob.com", NULL);
    _messageReadQueue = dispatch_queue_create("easemob.read.com", NULL);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = NO;
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [ChatManager clearUnReadCountWith:self.userID];
    [self reloadData];
    [self sendRead];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //self.navigationController.navigationBarHidden = YES;
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [ChatManager clearUnReadCountWith:self.userID];
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

- (void)configNav
{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWIDTH, 64)];
    navView.backgroundColor = [UIColorUtil colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:navView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 44/2 - 20/2 + 20, 30, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backNav"] forState:UIControlStateNormal];
    //UIBarButtonItem *bacgItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    //self.navigationItem.leftBarButtonItem = bacgItem;
    
    [navView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backNav:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(UIWIDTH/2 - 60, 20, 120, 44)];
    titleLab.text = self.title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = NavTitleFont;
    [navView addSubview:titleLab];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(UIWIDTH - 50, 44/2 - 30/2 + 20, 40, 30);
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"deleteChat"] forState:UIControlStateNormal];
    [navView addSubview:moreBtn];
    [moreBtn addTarget:self action:@selector(clickMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    /*
     导航 底部线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, UIWIDTH, 1)];
    lineView.backgroundColor = [UIColorUtil colorWithHexString:@"#f7f7f7"];
    [self.navigationController.navigationBar addSubview:lineView];
     */
}

- (void)backNav:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickMoreBtn:(id)sender
{
    UIActionSheet *deleteSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles: nil];//@"Stick on Top",
    [deleteSheet handlerClickedButton:^(NSInteger btnIndex) {
        if (btnIndex == 0) {
            //delete
            [self deleteCurrentChatMessage];
        }else if (btnIndex == 1){
            //top
        }
    }];
    [deleteSheet showInView:self.view];
}

#pragma -mark 初始化 表格
- (void)configTableView
{
    self.mesgaeArr = [NSMutableArray array];
    if (!self.tableView) {
        CGRect frame = self.view.bounds;
        frame.origin.y = 64;
        frame.size.height -= (64 + [MessageToolBar defaultHeight]);
        self.tableView                 = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate        = self;
        self.tableView.dataSource      = self;
        [self.view addSubview:self.tableView];
        
        [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)]];
        
        [self.tableView addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)]];
    }
}


- (void)swipeGesture:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self backNav:nil];
    }
}

#pragma -mark MessageToolBar
- (void)configMessageToolBar
{
    if (!self.chatToolBar) {
        CGRect frame = CGRectMake(0, self.view.frame.size.height - [MessageToolBar defaultHeight], self.view.frame.size.width, [MessageToolBar defaultHeight]);
        self.chatToolBar = [[MessageToolBar alloc] initWithFrame:frame isPulicChat:NO];
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

#pragma -mark 允许 Menu菜单
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    chatViewCell *cell = (chatViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.indexPath = indexPath;
    return NO;
}

// chatcell delegate
- (void)tapHeadImgSendActionWithMessage:(ChatModel *)message
{
    //点击头像 查看个人信息
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (IsEmpty(message.msg_userID)) {
        [self showHudWith:RequestFailText];
        return;
    }

    [HttpTool sendRequestProfileWithUserID:message.msg_userID success:^(id json) {
        ResponseChatUserInforModel *res = [[ResponseChatUserInforModel alloc] initWithString:json error:nil];
        if (res.RETURN_CODE == 200) {
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            //跳转
            [self pushUserInforVC:res.RETURN_OBJ];
        }else
            [self showHudWith:ErrorRequestText];
        
    } faliure:^(NSError *error) {
        [self showHudWith:ErrorText];
    }];
}

// 重发
- (void)resendMessage:(ChatModel *)message
{
    /*
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Are you sour Resend"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Resend", nil];
    [alertView handlerClickedButton:^(NSInteger btnIndex) {
        
    }];
    [alertView show];
    */
    UIActionSheet *resendSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Resend"
                                                    otherButtonTitles: nil];
    [resendSheet handlerClickedButton:^(NSInteger btnIndex) {
        if (btnIndex == 0) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageID ＝ %@",message.messageID];
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                [ChatModel MR_deleteAllMatchingPredicate:predicate inContext:localContext];
            } completion:^(BOOL success, NSError *error) {
                
                [self.mesgaeArr removeObject:message];
                
                if ([message.msg_type isEqualToNumber:@(SendChatMessageChatIMGType)]) {
                    [self sendImageMessage:message.msg_message];
                }else
                    [self sendTextMessage:message.msg_message];
            }];            
        }
    }];
    [resendSheet showInView:self.view];
}

- (void)deleteMessage:(ChatModel *)message IndexPath:(NSIndexPath *)indexpath
{
    [self.mesgaeArr removeObject:message];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexpath.row inSection:indexpath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
    if ([message MR_deleteEntity]) {
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}

- (void)showHudWith:(NSString *)text
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showTextHUDAddedTo:self.view withText:text animated:YES];
}

- (void)pushUserInforVC:(NearByModel *)model
{
    UserInformationController *userInformationVC = [[UserInformationController alloc] init];
    userInformationVC.pushType = PushNextNoneVC;
    userInformationVC.model = model;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:userInformationVC animated:YES completion:nil];
    });
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
    rect.origin.y = 64;
    rect.size.height = UIHEIGHT - toHeight - [MessageToolBar defaultHeight] - 20 - 49 + 44;

    self.tableView.frame = rect;
    
    [self scrollViewToBottom:NO];
}
// 发送文本
- (void)didSendText:(NSString *)text
{
    if (![[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
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
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *messageID = [NSString stringWithFormat:@"%@_%@",self.userID,timeSp];
    
    [ChatManager insertChatMessageWith:self.userID
                              UserName:self.userName
                             MessageID:messageID
                        MessageContent:textMessage
                           MessageTime:currentTime isShow:YES];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        ChatModel *model = [ChatModel MR_createInContext:localContext];
        model.id = [NSNumber numberWithInteger:(self.mesgaeArr.count + 1)];
        model.user_ID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
        model.msg_userID = self.userID;
        model.userName = self.userName;
        model.msg_message = textMessage;
        model.msg_time = currentTime;
        model.msg_flag = @"ME";
        model.msg_longitude = [[NSTimeUtil sharedInstance] getCoordinateLongitude];
        model.msg_latitude = [[NSTimeUtil sharedInstance] getCoordinateLatitude];
        model.messageID = messageID;
        model.msg_hasTime = [XMPPManager getChatTime:currentTime ToUserID:self.userID];
        model.msg_send_type = @(SendCHatMessageNomal);
        model.msg_type = @(SendChatMessageChatType);
        
    } completion:^(BOOL success, NSError *error) {
        
        [self refreshDataWithMessageID:messageID];
        [self sendTextMessage:textMessage SendMessageTime:currentTime MessageID:messageID];
        
    }];
}




- (void)sendImageMessage:(NSString *)imagePath
{
    NSString *currentTime = [UtilDate getCurrentTime];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *messageID = [NSString stringWithFormat:@"%@_%@",self.userID,timeSp];
    
    [ChatManager insertChatMessageWith:self.userID
                              UserName:self.userName
                             MessageID:messageID
                        MessageContent:imagePath
                           MessageTime:currentTime isShow:YES];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        ChatModel *model = [ChatModel MR_createInContext:localContext];
        model.id = [NSNumber numberWithInteger:(self.mesgaeArr.count + 1)];
        model.user_ID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
        model.msg_userID = self.userID;
        model.userName = self.userName;
        model.msg_message = imagePath;
        model.msg_time = currentTime;
        model.msg_flag = @"ME";
        model.msg_longitude = [[NSTimeUtil sharedInstance] getCoordinateLongitude];
        model.msg_latitude = [[NSTimeUtil sharedInstance] getCoordinateLatitude];
        model.messageID = messageID;
        model.msg_hasTime = [XMPPManager getChatTime:currentTime ToUserID:self.userID];
        model.msg_send_type = @(SendCHatMessageNomal);
        model.msg_type = @(SendChatMessageChatIMGType);
        
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
                                      ToUserID:self.userID
                                     IsChatIMG:YES
                                      CallBack:^(SendChatMessageStateType sendState, NSString *msg_ID) {
                                          
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
                                      ToUserID:self.userID
                                     IsChatIMG:NO
                                      CallBack:^(SendChatMessageStateType sendState, NSString *msg_ID) {
                                          [self updateSendMessageState:sendState MessageID:msg_ID];
                                      }];
}
// 加载记录
- (void)reloadData
{
    __weak ChatController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_ID = %@ and msg_userID = %@",[[UserInfoManager sharedInstance] getCurrentUserInfo].userID,self.userID];
        
        NSArray *array = [ChatModel MR_findAllSortedBy:@"msg_time" ascending:YES withPredicate:predicate];
        //NSArray * array = [ChatModel MR_findByAttribute:@"msg_userID" withValue:self.userID];
        
        weakSelf.mesgaeArr = [NSMutableArray arrayWithArray:array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (weakSelf.mesgaeArr.count > 0) {
                [weakSelf.tableView reloadData];
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.mesgaeArr count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        });
    });
    
}
// 添加一条消息
/*
- (void)refreshDataWithMessageID:(NSString *)msgID
{
    __weak ChatController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        ChatModel *model = [ChatModel MR_findFirstByAttribute:@"messageID" withValue:msgID];
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
    ChatModel *model = [ChatModel MR_findFirstByAttribute:@"messageID" withValue:msgID];
    [self.mesgaeArr addObject:model];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesgaeArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

// 修改发送状态
- (void)updateSendMessageState:(NSInteger)state MessageID:(NSString *)msgID
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        ChatModel *chatModel = [ChatModel MR_findFirstByAttribute:@"messageID" withValue:msgID inContext:localContext];
        chatModel.msg_send_type = @(state);
        
    } completion:^(BOOL success, NSError *error) {
        debugLog(@"发送状态->修改成功");
        //[self refreshDataWithMessageID:msgID];
        for (int i = 0 ;i< self.mesgaeArr.count ; i++) {
            ChatModel *model = self.mesgaeArr[i];
            if ([model.messageID isEqualToString:msgID]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
                
                return;
            }
        }
    }];
}

#pragma -mark xmpp 代理回调
- (void)didReceiveMessageId:(NSString *)msg_ID Msg_userID:(NSString *)msg_userid
{
    if ([msg_userid isEqualToString:self.userID]) {
        [self refreshDataWithMessageID:msg_ID];
        // 发送已读操作
        [ChatSendMessage ReplyToChatMessageWithMessageID:msg_ID ToUserID:self.userID CallBack:^(SendChatMessageStateType sendState, NSString *msg_ID) {
            
        }];
    }
}

- (void)didReceiveHasReadResponse:(NSString *)msg_ID
{
    dispatch_async(_messageReadQueue, ^{
        for (int i = 0 ;i< self.mesgaeArr.count ; i++) {
            ChatModel *model = self.mesgaeArr[i];
            if ([model.messageID isEqualToString:msg_ID]) {
                model.msg_send_type = @(SendChatMessageReadState);
                [self.mesgaeArr replaceObjectAtIndex:i withObject:model];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            }
        }
    });
    
    
    
    /*
    for (int i = 0 ;i< self.mesgaeArr.count ; i++) {
        
        ChatModel *model = self.mesgaeArr[i];
        
        if ([model.messageID isEqualToString:msg_ID]) {
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                
                ChatModel *chatModel = [ChatModel MR_findFirstByAttribute:@"messageID" withValue:msg_ID inContext:localContext];
                chatModel.msg_send_type = @(SendChatMessageReadState);
                
            } completion:^(BOOL success, NSError *error) {
                debugLog(@"已读->修改成功");
                dispatch_async(dispatch_get_main_queue(), ^{

                    model.msg_send_type = @(SendChatMessageReadState);
                    [self.mesgaeArr replaceObjectAtIndex:i withObject:model];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    return ;
                });
            }];
        }
    }
     */
}

#pragma -mark 发送已读操作
- (void)sendRead
{
    NSString *curuserID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_ID = %@ and msg_userID = %@ and msg_send_type = %@",curuserID,self.userID,@(SendChatMessageNoReadState)];
    NSArray *chatModelArr = [ChatModel MR_findAllWithPredicate:predicate];
    
    debugLog(@"%@",chatModelArr);
    
    if (chatModelArr.count>0) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            for (ChatModel *model in chatModelArr) {
                [ChatSendMessage ReplyToChatMessageWithMessageID:model.messageID ToUserID:self.userID CallBack:^(SendChatMessageStateType sendState, NSString *msg_ID) {
                    debugLog(@"已回复");
                }];
            }
        });
        
    }
}

#pragma mark 删除会话
- (void)deleteCurrentChatMessage
{
    [DataShareInstance deleteCurrentChatMessage:self.userID];

    NSString *currentUserID = [[UserInfoManager sharedInstance] getCurrentUserInfo].userID;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"toUserID = %@ and cur_userID = %@",self.userID,currentUserID];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [MessageModel MR_deleteAllMatchingPredicate:predicate inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
        debugLog(@"删除当前会话成功");
        [self backNav:nil];
    }];
}

- (void)dealloc
{
    self.chatToolBar = nil;
    self.tableView = nil;
    self.mesgaeArr = nil;
}
@end
