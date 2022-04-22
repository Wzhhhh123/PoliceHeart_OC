//
//  DataDefault.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/15.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataDefault : NSObject


/**
 * Singleton
 */
+ (instancetype) shareInstance;


/**
 * User
 */


@property(nonatomic) NSString *registerId;

@property(nonatomic) NSString *timeInter;
@property(nonatomic) NSString *userPhone;
@property(nonatomic) NSString *appVersion;
@property(nonatomic) NSData *bgImage;
@property(nonatomic) NSMutableDictionary *userInfor;
@property(nonatomic) NSMutableDictionary *phoneAndPass;
@property(nonatomic) NSMutableArray *pointArray;
@property(nonatomic) NSMutableArray *rainInformArray;
@property(nonatomic) NSMutableArray *tempInformArray;


@end
