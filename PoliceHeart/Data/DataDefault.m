//
//  DataDefault.m
//  BaojiWeather
//
//  Created by Tcy on 2017/2/15.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "DataDefault.h"

static NSString* const kUserPhone      = @"userPhone";
static NSString* const kappVersion      = @"appVersion";

static NSString* const kpointArray      = @"pointArray";
static NSString* const krain      = @"rain";
static NSString* const ktemp      = @"temp";
static NSString* const kuserInfo      = @"userInfo";
static NSString* const kphoneAndPass      = @"phoneAndPass";

static NSString* const kTimeInter      = @"timeInter";
static NSString* const kRegisterId      = @"registerId";


@implementation DataDefault

+(NSUserDefaults*) defaults
{
    return [NSUserDefaults standardUserDefaults];
}


#pragma mark - User


- (NSString*) registerId {
    return [[DataDefault defaults] objectForKey:kRegisterId];
}

-(void) setRegisterId:(NSString *)registerId {
    [[DataDefault defaults] setObject:registerId forKey:kRegisterId];
    [[DataDefault defaults] synchronize];
}


- (NSMutableDictionary*) userInfor {
    return [[DataDefault defaults] objectForKey:kuserInfo];
}

-(void) setUserInfor:(NSMutableDictionary *)userInfor {
    [[DataDefault defaults] setObject:userInfor forKey:kuserInfo];
    [[DataDefault defaults] synchronize];
}

- (NSMutableDictionary*) phoneAndPass {
    return [[DataDefault defaults] objectForKey:kphoneAndPass];
}

-(void) setPhoneAndPass:(NSMutableDictionary *)phoneAndPass {
    [[DataDefault defaults] setObject:phoneAndPass forKey:kphoneAndPass];
    [[DataDefault defaults] synchronize];
}

- (NSString*) userPhone {
    return [[DataDefault defaults] objectForKey:kUserPhone];
}

-(void) setUserPhone:(NSString *)userPhone {
    [[DataDefault defaults] setObject:userPhone forKey:kUserPhone];
    [[DataDefault defaults] synchronize];
}

- (NSString*) appVersion {
    return [[DataDefault defaults] objectForKey:kappVersion];
}

-(void) setAppVersion:(NSString *)appVersion {
    [[DataDefault defaults] setObject:appVersion forKey:kappVersion];
    [[DataDefault defaults] synchronize];
}

- (NSString*) timeInter {
    return [[DataDefault defaults] objectForKey:kTimeInter];
}

-(void) setTimeInter:(NSString *)timeInter {
    [[DataDefault defaults] setObject:timeInter forKey:kTimeInter];
    [[DataDefault defaults] synchronize];
}

- (NSMutableArray*) pointArray {
    return [[DataDefault defaults] objectForKey:kpointArray];
}

-(void) setPointArray:(NSMutableArray *)pointArray{
    [[DataDefault defaults] setObject:pointArray forKey:kpointArray];
    [[DataDefault defaults] synchronize];
}

- (NSMutableArray*) rainInformArray {
    return [[DataDefault defaults] objectForKey:krain];
}



-(void) setRainInformArray:(NSMutableArray *)rainInformArray{
    [[DataDefault defaults] setObject:rainInformArray forKey:krain];
    [[DataDefault defaults] synchronize];
}


- (NSMutableArray*) tempInformArray {
    return [[DataDefault defaults] objectForKey:ktemp];
}

-(void) setTempInformArray:(NSMutableArray *)tempInformArray{
    [[DataDefault defaults] setObject:tempInformArray forKey:ktemp];
    [[DataDefault defaults] synchronize];
}



#pragma mark - Singleton
+ (instancetype) shareInstance {
    static dispatch_once_t onceToken;
    static DataDefault *sSharedInstance;
    dispatch_once(&onceToken, ^ {
        sSharedInstance = [[DataDefault alloc] init];
    });
    return sSharedInstance;
}

@end
