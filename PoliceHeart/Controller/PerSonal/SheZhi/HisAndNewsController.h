//
//  HisAndNewsController.h
//  PoliceHeart
//
//  Created by tcy on 2018/11/6.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HisAndNewsController : UIViewController

@property (nonatomic ) NSString *kinStr;

@property (nonatomic ) NSMutableDictionary *userDic;
@property (copy,nonatomic) void (^loginOut)(NSMutableDictionary *useInf);

@end
