//
//  MQGuideView.m
//  MQGuideView
//
//  Created by irs on 16/9/22.
//  Copyright © 2016年 zmq. All rights reserved.
//

#import "MQGuideView.h"

@interface MQGuideView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation MQGuideView

static const NSInteger NumberOfGuide = 3; //引导页数

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH)];
        [self addSubview:scrollView];
        
//        UIButton *passBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenW-70.0f, 40.0f, 50.0f, 30.0f)];
//        [passBtn addTarget:self action:@selector(onFinishedIntroButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//        [passBtn setImage:[UIImage imageNamed:@"default_pass"] forState:UIControlStateNormal];
//        [self addSubview:passBtn];
        
        scrollView.delegate = self;
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(screenW*NumberOfGuide, screenH);
        scrollView.pagingEnabled = YES;
        for (int i=0; i<NumberOfGuide; i++) {
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*screenW, 0, screenW, screenH)];
            imgView.contentMode = UIViewContentModeScaleToFill;
            imgView.userInteractionEnabled = YES;
            //修改图片名称
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_guide%d",i+1]];
            [scrollView addSubview:imgView];
            
            if (i == (NumberOfGuide-1)) {
                UIButton *startBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.center.x, self.frame.size.height*.85, 120, 35)];
                startBtn.center = CGPointMake(self.center.x, self.frame.size.height*.85);
//                startBtn.layer.cornerRadius = 5.0f;
//                startBtn.layer.masksToBounds = YES;
//                startBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
//                startBtn.backgroundColor = [UIColor brownColor];
//                [startBtn setTitle:@"立即开启" forState:UIControlStateNormal];
//                [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                [startBtn setImage:[UIImage imageNamed:@"icon_bt_start.png"] forState:UIControlStateNormal];
                [startBtn addTarget:self action:@selector(onFinishedIntroButtonPressed) forControlEvents:UIControlEventTouchUpInside];
                [imgView addSubview:startBtn];
            }
        }
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(screenW/2-40.0f, screenH-40.0f, 80.0f, 10.0f)];
        [self addSubview:_pageControl];
        _pageControl.enabled = YES;
        _pageControl.numberOfPages = NumberOfGuide;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return  self;
}
#pragma mark - 跳过引导代理
- (void)onFinishedIntroButtonPressed{
    [self.delegate onPassButtonPressed];
}

#pragma mark - 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    _pageControl.currentPage = page;
}
@end
