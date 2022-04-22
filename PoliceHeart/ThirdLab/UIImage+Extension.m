//
//  UIImage+Extension.m
//  XZ_WeChat
//
//  Created by tcy on 16/9/27.
//  Copyright © 2016年 tcy. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)


//渐变色生成图片
+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize {
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case GradientTypeTopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case GradientTypeLeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, 0.0);
            break;
        case GradientTypeUpleftToLowright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, imgSize.height);
            break;
        case GradientTypeUprightToLowleft:
            start = CGPointMake(imgSize.width, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

//颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


// 视频第一帧图片
+ (UIImage *)videoFramerateWithPath:(NSString *)videoPath
{
    NSString *mp4Path = [[videoPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"mp4"];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:mp4Path] options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = 0;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    if (!thumbnailImageRef) {
        return nil;
    }
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    CGImageRelease(thumbnailImageRef);
    return thumbnailImage;
}

// 压缩图片
+ (UIImage *)simpleImage:(UIImage *)originImg
{
    CGSize imageSize = [self handleImage:originImg.size];
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0.0);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    CGContextAddPath(contextRef, bezierPath.CGPath);
    CGContextClip(contextRef);
    [originImg drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *clipedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return clipedImage;
}

+ (CGSize)handleImage:(CGSize)retSize {
    CGFloat width = 0;
    CGFloat height = 0;
    if (retSize.width > retSize.height) {
        width = SCREEN_WIDTH;
        height = retSize.height / retSize.width * width;
    } else {
        height = SCREEN_HEIGHT;
        width = retSize.width / retSize.height * height;
    }
    return CGSizeMake(width, height);
}


+ (UIImage *)makeArrowImageWithSize:(CGSize)imageSize
                              image:(UIImage *)image
                           isSender:(BOOL)isSender
{
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [self getBezierPath:isSender imageSize:imageSize];
    CGContextAddPath(contextRef, path.CGPath);
    CGContextEOClip(contextRef);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *arrowImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return arrowImage;
}

+ (UIBezierPath *)getBezierPath:(BOOL)isSender
                      imageSize:(CGSize)imageSize
{
    CGFloat arrowWidth = 0;
    CGFloat marginTop = 13;
    CGFloat arrowHeight = 10;
    CGFloat imageW = imageSize.width;
    UIBezierPath *path;
    if (isSender) {
        path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, imageSize.width - arrowWidth, imageSize.height) cornerRadius:6];
        [path moveToPoint:CGPointMake(imageW - arrowWidth, 0)];
        [path addLineToPoint:CGPointMake(imageW - arrowWidth, marginTop)];
        [path addLineToPoint:CGPointMake(imageW, marginTop + 0.5 * arrowHeight)];
        [path addLineToPoint:CGPointMake(imageW - arrowWidth, marginTop + arrowHeight)];
        [path closePath];
        
    } else {
        path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(arrowWidth, 0, imageSize.width - arrowWidth, imageSize.height) cornerRadius:6];
        [path moveToPoint:CGPointMake(arrowWidth, 0)];
        [path addLineToPoint:CGPointMake(arrowWidth, marginTop)];
        [path addLineToPoint:CGPointMake(0, marginTop + 0.5 * arrowHeight)];
        [path addLineToPoint:CGPointMake(arrowWidth, marginTop + arrowHeight)];
        [path closePath];
    }
    return path;
}



+ (UIImage *)addImage:(UIImage *)firstImg
              toImage:(UIImage *)secondImg
{
    UIGraphicsBeginImageContext(secondImg.size);
    [secondImg drawInRect:CGRectMake(0, 0, secondImg.size.width, secondImg.size.height)];
    [firstImg drawInRect:CGRectMake((secondImg.size.width-firstImg.size.width)*0.5,(secondImg.size.height-firstImg.size.height)*0.5, firstImg.size.width, firstImg.size.height)];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}

+ (UIImage *)addImage2:(UIImage *)firstImg
               toImage:(UIImage *)secondImg
{
    UIGraphicsBeginImageContext(secondImg.size);
    [secondImg drawInRect:CGRectMake(0, 0,secondImg.size.width,secondImg.size.height)];
    CGFloat firstImgW = secondImg.size.width/4;
    CGFloat firstImgH = secondImg.size.width/4;
    [firstImg drawInRect:CGRectMake((secondImg.size.width-firstImgW)*0.5,(secondImg.size.height-firstImgH)*0.5, firstImgW,firstImgH)];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}


+(UIImage *)coreBlurImage:(UIImage *)image
           withBlurNumber:(CGFloat)blur {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage  *inputImage=[CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}


+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}



@end
