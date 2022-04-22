//
//  UITabBarController+Extension.m
//  GGJOA
//
//  Created by tcy on 2018/7/13.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import "UITabBarController+Extension.h"

@implementation UITabBarController (Extension)
-(id)addViewControlerWithClass:(Class )cls
                         title:(NSString *)title
                         image:(NSString *)image
                   selectImage:(NSString *)selectImage
{
    //创建一个界面(包含导航)
    UIViewController *vc = [[cls alloc] init];
    vc.title = title;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    nc.tabBarItem.image = [UIImage imageNamed:image];
    //注意: iOS8需要加
    nc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //添加到tabBar中
    NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:self.viewControllers];
    [marr addObject:nc];
    self.viewControllers = marr;
    
    return vc;
}
@end
