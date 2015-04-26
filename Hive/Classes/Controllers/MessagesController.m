//
//  MessagesController.m
//  Hive
//
//  Created by BaoJun on 15/3/22.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "MessagesController.h"
#import "MessageCell.h"
#import "Utils.h"


@interface MessagesController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *messageTable;
@end

@implementation MessagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark 初始化 Message TableView
- (void)configTableView
{
    if (!self.messageTable) {
        CGRect frame = self.view.bounds;
        frame.size.height -= 64;
        self.messageTable                 = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.messageTable.backgroundColor = [UIColor clearColor];
        self.messageTable.separatorStyle  = UITableViewCellSeparatorStyleNone;
        self.messageTable.delegate        = self;
        self.messageTable.dataSource      = self;
        [self.view addSubview:self.messageTable];
    }
}

#pragma -mark TableView 回调
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MessageCell getMessageCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    [cell set_MessageCellData];
    /*
    __weak MessagesController *weadSelf = self;
    cell.block = ^(NSIndexPath *indexpath){
        weadSelf.mainViewBlock(@"888");// 传递用户ID
    };
     */
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //self.clickCellBlock(indexPath);
    
    debugMethod();
    

}
- (void)dealloc
{
    self.messageTable.delegate = nil;
    self.messageTable = nil;
}
@end
