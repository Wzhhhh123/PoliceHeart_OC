//
//  ResignController.h
//  PoliceHeart
//
//  Created by tcy on 2018/11/9.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResignController : UIViewController

@property (nonatomic ) NSString *kinStr;


@property (copy,nonatomic) void (^ResetSuccess)(NSString *phone);

@end
