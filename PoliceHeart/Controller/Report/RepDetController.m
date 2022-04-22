//
//  RepDetController.m
//  PoliceHeart
//
//  Created by tcy on 2018/12/6.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "RepDetController.h"

@interface RepDetController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *detVeb;
@property ( nonatomic)  CGFloat NavHig;
@property (strong, nonatomic) IBOutlet UIView *mutHead;

@property (strong, nonatomic) IBOutlet UIView *detView;

@end

@implementation RepDetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;

    _NavHig=SCREEN_HEIGHT>800?83:64;

    _mutHead.frame=CGRectMake(0, 0, SCREEN_WIDTH, _NavHig);
    [self.view addSubview:_mutHead];
    
    _detView.frame=CGRectMake(0, _NavHig, SCREEN_WIDTH,SCREEN_HEIGHT-_NavHig);
    [self.view addSubview:_detView];
    
    
    _detVeb.delegate=self;
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
    
    [_detVeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHOST,_infDic[@"rp_Url"]]]]];

}


- (void)webViewDidFinishLoad:(UIWebView *)webView{

    [SVProgressHUD showSuccessWithStatus:@"加载完成！"];


}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
