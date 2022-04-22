//
//  LoginController.h
//  Elevator
//
//  Created by Tcy on 2017/10/31.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginController : UIViewController
@property (copy,nonatomic) void (^actionLoginSuccess)(NSMutableDictionary *useInf);

@end
