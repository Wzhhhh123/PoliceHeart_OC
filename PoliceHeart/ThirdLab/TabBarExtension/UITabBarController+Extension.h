//
//  UITabBarController+Extension.h
//  GGJOA
//
//  Created by tcy on 2018/7/13.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (Extension)
-(id)addViewControlerWithClass:(Class )cls
                         title:(NSString *)title
                         image:(NSString *)image
                   selectImage:(NSString *)selectImage;
@end
