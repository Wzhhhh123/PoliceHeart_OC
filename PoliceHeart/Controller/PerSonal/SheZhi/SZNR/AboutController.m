//
//  AboutController.m
//  PoliceHeart
//
//  Created by tcy on 2018/12/5.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "AboutController.h"
#import "PersonController.h"

@interface AboutController ()
@property ( nonatomic)  CGFloat NavHig;
@property (strong, nonatomic) IBOutlet UIView *mutHead;
@property (strong, nonatomic) IBOutlet UIView *detView;

@end

@implementation AboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _NavHig=SCREEN_HEIGHT>800?83:64;
    _mutHead.frame=CGRectMake(0, 0, SCREEN_WIDTH, _NavHig);
    [self.view addSubview:_mutHead];
    
    _detView.frame=CGRectMake(0, _NavHig, SCREEN_WIDTH, SCREEN_HEIGHT-_NavHig);
    [self.view addSubview:_detView];}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)touchLogo:(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[PersonController class]]) {
            PersonController *revise =(PersonController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
