//
//  IHPhotoDetailController.m
//  iheart
//
//  Created by Wang Shou on 15/8/29.
//  Copyright (c) 2015年 WangShou. All rights reserved.
//

#import "IHPhotoDetailController.h"

@interface IHPhotoDetailController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation IHPhotoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setup {
    // nav
    [self setTitle:@"图片"];
    UIBarButtonItem *dismissItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-close"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction)];
    [self.navigationItem setLeftBarButtonItem:dismissItem];
    
    
    //
    [_imageView setImage:_image];
}

- (void) dismissAction {
    [self dismissViewControllerAnimated:YES completion:^(void) {
    }];
}
- (IBAction)deleteThisImage:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoDetail:didFinishSelect:)]) {
        
        [self.delegate photoDetail:self didFinishSelect:nil];
        [self dismissAction];
    }
}

@end
