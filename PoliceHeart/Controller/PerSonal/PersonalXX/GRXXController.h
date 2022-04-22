//
//  GRXXController.h
//  PoliceHeart
//
//  Created by tcy on 2018/11/26.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRXXController : UIViewController

@property (nonatomic ) NSMutableDictionary *userDic;
@property (copy,nonatomic) void (^changeInfSuccess)(NSMutableDictionary *useInf);

@end
