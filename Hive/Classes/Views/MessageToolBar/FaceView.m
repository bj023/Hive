//
//  FaceView.m
//  Hive
//
//  Created by mac on 15/4/6.
//  Copyright (c) 2015年 wee. All rights reserved.
//

#import "FaceView.h"
#import "Utils.h"

@interface FaceView ()<UIScrollViewDelegate>
{
    UIScrollView *_faceScr;
    UIPageControl *_facePageCtr;
}
@end

@implementation FaceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initFaceView];
        [self initPageControl];
    }
    
    
    return self;
}

- (void)initFaceView
{
    if (!_faceScr) {
        _faceScr = [[UIScrollView alloc] initWithFrame:self.bounds];
        _faceScr.pagingEnabled = YES;
        _faceScr.userInteractionEnabled = YES;
        _faceScr.showsHorizontalScrollIndicator = NO;
        _faceScr.delegate = self;
        [self addSubview:_faceScr];
    }
    
    CGFloat pading = 10;
    CGFloat width = 80;
    CGFloat height = 80;

    CGFloat x = (UIWIDTH - width*4 - pading * 3)/2;
    NSInteger star = 1;
    for (int i=0; i<3; i++) {
        for (int j=0; j< (i==2?3:8); j++) {
            CGRect frame = CGRectMake(x + pading*(j%4) + UIWIDTH*i + width*(j%4), 8 + pading*(j/4)  + height*(j/4) , width, height);
            /*
            UIButton *faceImg = [UIButton buttonWithType:UIButtonTypeCustom];
            faceImg.frame = frame;
            faceImg.tag = star++;
            faceImg.backgroundColor = [UIColor clearColor];
            [_faceScr addSubview:faceImg];
            //[faceImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"0%d%d",i,j]] forState:UIControlStateNormal];
            [faceImg setImage:[UIImage imageNamed:FACEARRAY[i*8+j]] forState:UIControlStateNormal];
            //debugLog(@"%d",i*8+j);
            [faceImg addTarget:self action:@selector(clickFaceImg:) forControlEvents:UIControlEventTouchUpInside];
             */
            UIImageView *faceImg = [[UIImageView alloc] initWithFrame:frame];
            faceImg.userInteractionEnabled = YES;
            faceImg.tag = star++;
            faceImg.backgroundColor = [UIColor clearColor];
            [_faceScr addSubview:faceImg];
            faceImg.image = [UIImage imageNamed:FACEARRAY[i*8+j]];
            [faceImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFaceImg:)]];
        }
    }
    
    _faceScr.contentSize = CGSizeMake(UIWIDTH * (FACEARRAY.count/8+1), self.frame.size.height);
}

- (void)initPageControl
{
    _facePageCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 26, UIWIDTH, 20)];
    _facePageCtr.numberOfPages =FACEARRAY.count/8+1;
    _facePageCtr.currentPage = 0;
    _facePageCtr.userInteractionEnabled = YES;
    // 设置非选中页的圆点颜色
    _facePageCtr.pageIndicatorTintColor = [UIColor lightGrayColor];
    // 设置选中页的圆点颜色
    _facePageCtr.currentPageIndicatorTintColor = [UIColor orangeColor];
    [self addSubview:_facePageCtr];
    
    [_facePageCtr addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
}

- (void)changePage:(id)sender {
    NSInteger page = _facePageCtr.currentPage;//获取当前pagecontroll的值
    [_faceScr setContentOffset:CGPointMake(self.frame.size.width * page, 0)];
    //根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    int page = scrollView.contentOffset.x / scrollView.frame.size.width;

    _facePageCtr.currentPage = page;
}

- (void)clickFaceImg:(UITapGestureRecognizer *)sender
{
    NSInteger index = sender.view.tag - 1;
    NSString *faceString = FACEARRAY[index];

    /*
    if (index<10) {
        faceString = [NSString stringWithFormat:@"00%ld",index];
    }else{
        faceString = [NSString stringWithFormat:@"0%ld",index];
    }
    */
    if ([self.delegate respondsToSelector:@selector(selectedFacialView:)]) {
        [self.delegate selectedFacialView:faceString];
    }
}

@end
