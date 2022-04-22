//
//  ResultController.h
//  PoliceHeart
//
//  Created by tcy on 2018/11/16.
//  Copyright © 2018年 tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultController : UIViewController
@property (nonatomic ) NSInteger enter;
@property (nonatomic ) NSString *kinStr;
@property (nonatomic ) NSString *AnsId;
@property (nonatomic ) NSMutableDictionary *testDic;
@property (nonatomic ) NSMutableDictionary *userDic;

@property (nonatomic ) NSString *testPapper_id;


@property (copy,nonatomic) void (^actionRetest)(NSString *kind);
@end
