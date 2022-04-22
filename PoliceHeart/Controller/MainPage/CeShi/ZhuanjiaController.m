//
//  ZhuanjiaController.m
//  PoliceHeart
//
//  Created by tcy on 2018/11/27.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "ZhuanjiaController.h"

@interface ZhuanjiaController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property ( nonatomic)  CGFloat NavHig;
@property (strong, nonatomic) IBOutlet UIView *mutHead;
@property (strong, nonatomic) IBOutlet UIView *scrView;

@end

@implementation ZhuanjiaController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    _NavHig=SCREEN_HEIGHT>800?83:64;

    _mutHead.frame=CGRectMake(0, 0, SCREEN_WIDTH, _NavHig);
    [self.view addSubview:_mutHead];
    
    _scrView.frame=CGRectMake(0, _NavHig, SCREEN_WIDTH,SCREEN_HEIGHT-_NavHig );
    [self.view addSubview:_scrView];
    
    
    
    
    
    UIImageView *ima=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/750*3342)];
    [ima setContentMode:UIViewContentModeScaleToFill];
    [ima setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zhuanjia_det"ofType:@"png"]]];
    [_scroller addSubview:ima];
    [_scroller setContentSize:CGSizeMake(0, SCREEN_WIDTH/750*3342)];
    
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
