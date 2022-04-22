//
//  NSString+SignStr.m
//  ZhenBanWeather
//
//  Created by Tcy on 2017/9/15.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "NSString+SignStr.h"

@implementation NSString (SignStr)

+(CGFloat)stringHight:(NSString *)str font:(CGFloat)font width:(CGFloat)width{
    CGFloat h;
    CGSize titleSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    h=titleSize.height;
    return h;
}

+(CGFloat)stringPhsHight:(NSString *)str font:(CGFloat)font width:(CGFloat)width{
    CGFloat h;
    CGSize titleSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:font]} context:nil].size;
    h=titleSize.height;
    return h;
}

+(CGFloat)stringWidth:(NSString *)str font:(CGFloat)font{
    CGFloat w;
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:font]};
    CGSize size=[str sizeWithAttributes:attrs];
    w=size.width;
    return w;
}

+(NSString *)nowTimeStyle1{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"HH:mm:ss"];
    NSString *timeString = [formate stringFromDate:dat];
    return timeString;
}
+(NSString *)nowTimeStyle2{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"HH mm"];
    NSString *timeString = [formate stringFromDate:dat];
    return timeString;
}

+(NSString *)nowTimeStyle3{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy年MM月dd日"];
    NSString *timeString = [formate stringFromDate:dat];
    return timeString;
}


+(NSString *)nowTimeStyle4{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeString = [formate stringFromDate:dat];
    return timeString;
}


+(NSString *)timeWithSec:(NSString *)sec{
    if (sec.length==13) {
        sec=[NSString stringWithFormat:@"%f",[sec floatValue]/1000];
    }
    NSDate* dat = [NSDate dateWithTimeIntervalSince1970:[sec floatValue]];
    NSDateFormatter *formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeString = [formate stringFromDate:dat];
    return timeString;
}


+(NSString *)timeStr{

    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    return timeString;
}
+(NSString *)signStrWithToken:(NSString *)str tim:(NSString *)tim{
    NSString *signStr=[NSString stringWithFormat:@"time=%@&token=%@",tim,str];
   NSString *resultStr= [signStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return resultStr;
}


+(NSString *)checkStr:(NSString *)str{
    if (str.length==0||[str isEqualToString:@"<null>"]) {
        return @"0";

    }else{
        return str;
    }
}

+ (NSString *)ChineseDate{
    NSArray *chineseYear = @[@"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"猴", @"鸡", @"狗", @"猪"];
    NSArray *HeavenlyStems= @[@"甲", @"乙", @"丙",@"丁", @"戊", @"己", @"庚", @"辛", @"壬", @"癸"];
    NSArray *EarthlyBranches= @[@"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", @"亥"];
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *day = [dateFormatter stringFromDate:date];
    
    NSDateFormatter *wekFormate=[[NSDateFormatter alloc]init];
    [wekFormate setDateFormat:@"EEEE"];
    NSString *week = [wekFormate stringFromDate:date];
    
    NSCalendar *calendarChinese = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSCalendarUnit calenderUnitChinese = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *componentsChinese = [calendarChinese components:calenderUnitChinese fromDate:date];
    //    NSLog(@"Year: %ld", componentsChinese.year);
    //    NSLog(@"Month: %ld", componentsChinese.month);
    //    NSLog(@"Day: %ld", componentsChinese.day);
    //    NSLog(@"Day: %@", date);
    
    NSString *mon=[NSString stringWithFormat:@"%@",[NSString monToString:componentsChinese.month]];
    NSString *days=[NSString stringWithFormat:@"%@",[NSString dayToString:componentsChinese.day]];
    NSInteger x=(componentsChinese.year -1)%chineseYear.count;
    NSInteger y=(componentsChinese.year -1)%HeavenlyStems.count;
    NSInteger z=(componentsChinese.year -1)%EarthlyBranches.count;
    
    NSString *str=[NSString stringWithFormat:@"阳历%@ %@\n农历%@月%@ (%@年 %@%@)",day,week,mon,days,chineseYear[x],HeavenlyStems[y],EarthlyBranches[z]];
    return str;
    
}
+ (NSString *)ChineseDateMandD{
    NSDate *date = [NSDate date];
    NSCalendar *calendarChinese = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSCalendarUnit calenderUnitChinese = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *componentsChinese = [calendarChinese components:calenderUnitChinese fromDate:date];
    NSString *mon=[NSString stringWithFormat:@"%@",[NSString monToString:componentsChinese.month]];
    NSString *days=[NSString stringWithFormat:@"%@",[NSString dayToString:componentsChinese.day]];
    NSString *str=[NSString stringWithFormat:@"%@月%@",mon,days];
    return str;
    
}

+ (NSString *)monToString:(NSInteger )num{
    NSString *str;
    switch (num) {
        case 1:
            str=@"一";
            break;
        case 2:
            str=@"二";
            break;
        case 3:
            str=@"三";
            break;
        case 4:
            str=@"四";
            break;
        case 5:
            str=@"五";
            break;
        case 6:
            str=@"六";
            break;
        case 7:
            str=@"七";
            break;
        case 8:
            str=@"八";
            break;
        case 9:
            str=@"九";
            break;
        case 10:
            str=@"十";
            break;
        case 11:
            str=@"十一";
            break;
        case 12:
            str=@"十二";
            break;
        default:
            NSLog(@"错误");
            break;
    }
    return str;
}
+ (NSString *)dayToString:(NSInteger )num{
    NSString *str;
    switch (num) {
        case 1:
            str=@"初一";
            break;
        case 2:
            str=@"初二";
            break;
        case 3:
            str=@"初三";
            break;
        case 4:
            str=@"初四";
            break;
        case 5:
            str=@"初五";
            break;
        case 6:
            str=@"初六";
            break;
        case 7:
            str=@"初七";
            break;
        case 8:
            str=@"初八";
            break;
        case 9:
            str=@"初九";
            break;
        case 10:
            str=@"初十";
            break;
        case 11:
            str=@"十一";
            break;
        case 12:
            str=@"十二";
            break;
        case 13:
            str=@"十三";
            break;
        case 14:
            str=@"十四";
            break;
        case 15:
            str=@"十五";
            break;
        case 16:
            str=@"十六";
            break;
        case 17:
            str=@"十七";
            break;
        case 18:
            str=@"十八";
            break;
        case 19:
            str=@"十九";
            break;
        case 20:
            str=@"二十";
            break;
        case 21:
            str=@"廿一";
            break;
        case 22:
            str=@"廿二";
            break;
        case 23:
            str=@"廿三";
            break;
        case 24:
            str=@"廿四";
            break;
        case 25:
            str=@"廿五";
            break;
        case 26:
            str=@"廿六";
            break;
        case 27:
            str=@"廿七";
            break;
        case 28:
            str=@"廿八";
            break;
        case 29:
            str=@"廿九";
            break;
        case 30:
            str=@"三十";
            break;
        case 31:
            str=@"三十一";
            break;
        default:
            NSLog(@"错误");
            break;
    }
    return str;
}
@end
