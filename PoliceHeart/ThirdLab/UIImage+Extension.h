//
//  UIImage+Extension.h
//  XZ_WeChat
//
//  Created by tcy on 16/9/27.
//  Copyright © 2016年 tcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>

@interface UIImage (Extension)

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到下
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};

//渐变色图片生成
+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;


//颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;

// 视频第一帧图片
+ (UIImage *)videoFramerateWithPath:(NSString *)videoPath;

// 压缩图片
+ (UIImage *)simpleImage:(UIImage *)originImg;

+ (UIImage *)makeArrowImageWithSize:(CGSize)imageSize
                              image:(UIImage *)image
                           isSender:(BOOL)isSender;

//合成图片
+ (UIImage *)addImage2:(UIImage *)firstImg
               toImage:(UIImage *)secondImg;

+ (UIImage *)addImage:(UIImage *)firstImg
              toImage:(UIImage *)secondImg;


//模糊图片
+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
/**
 *  vImage模糊图片
 *
 *  @param image 原始图片
 *  @param blur  模糊数值(0-1)
 *
 *  @return 重新绘制的新图片
 */
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;


@end
