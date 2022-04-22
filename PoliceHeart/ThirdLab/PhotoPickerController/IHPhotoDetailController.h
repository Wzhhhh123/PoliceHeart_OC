//
//  IHPhotoDetailController.h
//  iheart
//
//  Created by Wang Shou on 15/8/29.
//  Copyright (c) 2015年 WangShou. All rights reserved.
//

#import <UIKit/UIKit.h>


@class IHPhotoDetailController;

@protocol IHPhotoDetailDelegate <NSObject>

@optional

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)photoDetail:(IHPhotoDetailController *)detail didFinishSelect:(NSDictionary *)info;

- (void)photoDetailDidCancel:(IHPhotoDetailController *)detail;

@end

@interface IHPhotoDetailController : UIViewController

@property(nonatomic) UIImage *image;
@property(nonatomic,assign) id<IHPhotoDetailDelegate> delegate;

@end
