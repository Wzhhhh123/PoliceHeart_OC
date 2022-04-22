//
//  NSString+SignStr.h
//  ZhenBanWeather
//
//  Created by Tcy on 2017/9/15.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SignStr)
+ (NSString *)ChineseDateMandD;
+ (NSString *)ChineseDate;
+(NSString *)nowTimeStyle1;
+(NSString *)nowTimeStyle2;
+(NSString *)nowTimeStyle3;
+(NSString *)nowTimeStyle4;
+(NSString *)timeStr;

+(NSString *)checkStr:(NSString *)str;

+(NSString *)timeWithSec:(NSString *)sec;
+(NSString *)signStrWithToken:(NSString *)str tim:(NSString *)tim;
+(CGFloat)stringWidth:(NSString *)str font:(CGFloat)font;
+(CGFloat)stringHight:(NSString *)str font:(CGFloat)font width:(CGFloat)width;
+(CGFloat)stringPhsHight:(NSString *)str font:(CGFloat)font width:(CGFloat)width;
@end
