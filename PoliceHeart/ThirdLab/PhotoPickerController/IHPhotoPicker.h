//
//  IHPhotoPicker.h
//  iheart
//
//  Created by Wang Shou on 15/8/27.
//  Copyright (c) 2015年 WangShou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IHPhotoPicker;

@protocol IHPhotoPickerDelegate <NSObject>

@optional

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)photoPicker:(IHPhotoPicker *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

- (void)photoPickerDidCancel:(IHPhotoPicker *)picker;

@end

@interface IHPhotoPicker : NSObject

- (instancetype) initWithRootView:(UIView*)view controller:(UIViewController*)controller;

- (void) show;


@property (assign, nonatomic) id<IHPhotoPickerDelegate> delegate;

@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic) BOOL isFrontCameraFirst;
@property (nonatomic) BOOL isAllowEditing;

@property (nonatomic) CGFloat compressedMaxRadius; // 0 none, > 0 , max...

@end
