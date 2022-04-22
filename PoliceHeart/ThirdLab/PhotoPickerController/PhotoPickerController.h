//
//  PhotoPickerController.h
//  iheart
//
//  Created by Wang Shou on 15/8/20.
//  Copyright (c) 2015年 WangShou. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PhotoPickerController;

@protocol PhotoPickerControllerDelegate <NSObject>

@optional


// This method is called when an image has been chosen from the library or taken from the camera.
- (void)photoPickerController:(PhotoPickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

- (void)photoPickerControllerDidCancel:(PhotoPickerController *)picker;

@end


@interface PhotoPickerController : UIViewController

@property (assign, nonatomic) id<PhotoPickerControllerDelegate> delegate;

-(instancetype) initAsModalController;

@end
