//
//  UIAlertView+Block.m
//  Hive
//
//  Created by 那宝军 on 15/5/29.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>


#define UIAlertView_key_clicked	"UIAlertView.clicked"


@implementation UIAlertView (Block)

-(void) handlerClickedButton:(void (^)(NSInteger btnIndex))aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_clicked, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^block)(NSInteger btnIndex) = objc_getAssociatedObject(self, UIAlertView_key_clicked);
    
    if (block) block(buttonIndex);
}
@end
