//
//  PhotoPickerController.m
//  iheart
//
//  Created by Wang Shou on 15/8/20.
//  Copyright (c) 2015年 WangShou. All rights reserved.
//

#import "PhotoPickerController.h"

@interface PhotoPickerController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation PhotoPickerController

- (instancetype) initAsModalController {
    self = [super init];
    if (self) {
        // Do any additional setup after loading the view.
        UIBarButtonItem *dismissItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-close"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction)];
        [self.navigationItem setLeftBarButtonItem:dismissItem];
        
    }
    return self;
}

- (void) dismissAction {
    [self dismissViewControllerAnimated:YES completion:^(void) {
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"照片"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchCamera:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (IBAction)touchPhotoAlbum:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:NO completion:NULL];// A present B, A or B call this method the same effect occurs.
    if (_delegate) {
        NSDictionary *info = @{UIImagePickerControllerOriginalImage:image};
        [_delegate photoPickerController:self didFinishPickingMediaWithInfo:info];
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:NULL];
    if (_delegate) {
        [_delegate photoPickerControllerDidCancel:self];
    }
}


@end
