//
//  ViewCommon.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/15.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#ifndef ViewCommon_h
#define ViewCommon_h
/**
 * Color Macro
 */
#define RGBCOLOR(r,g,b)          [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HEXCOLOR(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HEXACOLOR(rgbValue,al)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]

/**
 * Device Size
 */
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT    ([UIScreen mainScreen].bounds.size.height)
#define APP_STATUSBAR_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height)

/**
 * Customize UI Color
 */
//#define IH_NAV_Color RGBCOLOR(245,245,245)
//#define IH_NAV_Color_FLU RGBACOLOR(245,245,245, 0.5)
//#define IH_DRAWER_Color RGBCOLOR(222,222,222)
//#define IH_LiTableViewSepColor RGBACOLOR(188,188,188,0.5)
//#define IH_LiTableViewBackColor RGBCOLOR(246,246,246)
//#define IH_WarningRed   RGBCOLOR(234,82,85)


#define Rat ([UIScreen mainScreen].bounds.size.width)/414

#endif
