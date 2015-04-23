//
//  UILabel+VerticalAlign.m
//  Hive
//
//  Created by BaoJun on 15/4/2.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "UILabel+VerticalAlign.h"
#import "UILabel+Size.h"

@implementation UILabel (VerticalAlign)

-(void)alignTop
{
    //CGSize fontSize =[self.text sizeWithFont:self.font];
    CGSize fontSize = [self.text sizeWithAttributes:@{NSFontAttributeName : self.font}];
    double finalHeight = fontSize.height *self.numberOfLines;
    double finalWidth =self.frame.size.width;//expected width of label
    
    //CGSize theStringSize =[self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];

    CGSize theStringSize = [UILabel sizeWithString:self.text font:self.font maxSize:CGSizeMake(finalWidth, finalHeight)];
    
    int newLinesToPad =(finalHeight - theStringSize.height)/ fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text =[self.text stringByAppendingString:@"\n "];
}

- (void)alignBottom
{
    CGSize fontSize = [self.text sizeWithAttributes:@{NSFontAttributeName : self.font}];
    double finalHeight = fontSize.height *self.numberOfLines;
    double finalWidth =self.frame.size.width;//expected width of label
    CGSize theStringSize = [UILabel sizeWithString:self.text font:self.font maxSize:CGSizeMake(finalWidth, finalHeight)];

    int newLinesToPad =(finalHeight - theStringSize.height)/ fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text =[NSString stringWithFormat:@" \n%@",self.text];
}


@end
