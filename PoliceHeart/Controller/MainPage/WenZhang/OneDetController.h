//
//  OneDetController.h
//  PoliceHeart
//
//  Created by tcy on 2018/10/17.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneDetController : UIViewController
@property (nonatomic) NSMutableDictionary *inf;
@property (nonatomic) NSInteger intage;
@property (nonatomic) NSInteger kinStr;


@property (nonatomic) NSString *lm_ObjId;

@property (nonatomic ) NSMutableDictionary *userDic;
@property (copy,nonatomic) void (^actionDianZan)(NSMutableDictionary *infDic,NSInteger indx);

@end
