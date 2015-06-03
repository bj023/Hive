//
//  UIActionSheet+Block.m
//  Hive
//
//  Created by 那宝军 on 15/5/31.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "UIActionSheet+Block.h"
#import <objc/runtime.h>

#define UIActionSheet_key_clicked	"UIAlertView.clicked"
@implementation UIActionSheet (Block)

-(void) handlerClickedButton:(void (^)(NSInteger btnIndex))aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIActionSheet_key_clicked, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^block)(NSInteger btnIndex) = objc_getAssociatedObject(self, UIActionSheet_key_clicked);
    if (block) block(buttonIndex);
}
@end
