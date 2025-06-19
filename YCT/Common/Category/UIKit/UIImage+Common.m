//
//  UIImage+Common.m
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import "UIImage+Common.h"
#import "YCTBezierPathTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation UIImage (Common)

+ (UIImage *)imageWithColor:(UIColor *)color
                       Size:(CGSize)targetSize
               CornerRadius:(CGFloat)cornerRadius {
    return [self imageWithColor:color
                           Size:targetSize
                   CornerRadius:cornerRadius
                BackgroundColor:[UIColor whiteColor]
                RoundingCorners:UIRectCornerAllCorners
                    BorderColor:color
                    BorderWidth:0];
}

+ (UIImage *)imageWithColor:(UIColor *)color
                       Size:(CGSize)targetSize
               CornerRadius:(CGFloat)cornerRadius
            BackgroundColor:(UIColor *)backgroundColor
            RoundingCorners:(UIRectCorner)corners
                BorderColor:(UIColor *)borderColor
                BorderWidth:(CGFloat)borderWidth {
    UIGraphicsBeginImageContextWithOptions(targetSize, cornerRadius == 0, [UIScreen mainScreen].scale);
    
    CGRect targetRect = (CGRect){0, 0, targetSize.width, targetSize.height};
    UIImage *finalImage = nil;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    if (cornerRadius == 0) {
        if (borderWidth > 0) {
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
            CGContextSetLineWidth(context, borderWidth);
            CGContextFillRect(context, targetRect);
            
            targetRect = CGRectMake(borderWidth / 2, borderWidth / 2, targetSize.width - borderWidth, targetSize.height - borderWidth);
            CGContextStrokeRect(context, targetRect);
        } else {
            CGContextFillRect(context, targetRect);
        }
    } else {
        targetRect = CGRectMake(borderWidth / 2, borderWidth / 2, targetSize.width - borderWidth, targetSize.height - borderWidth);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:targetRect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        CGContextAddPath(UIGraphicsGetCurrentContext(), path.CGPath);
        
        if (borderWidth > 0) {
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
            CGContextSetLineWidth(context, borderWidth);
            CGContextDrawPath(context, kCGPathFillStroke);
        } else {
            CGContextDrawPath(context, kCGPathFill);
        }
    }
    
    finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

+ (void)configPathWithBezierPath:(UIBezierPath **)bezier
                       radius_TL:(float)radius_TL
                       radius_TR:(float)radius_TR
                       radius_BL:(float)radius_BL
                       radius_BR:(float)radius_BR
                        rectSize:(CGSize)rectSize
                       fillColor:(UIColor *)fillColor {
    UIBezierPath *bezierPath = *bezier;
    YCTBezierPathTool *tool = [[YCTBezierPathTool alloc] initWithRadius_TopLeft:radius_TL radius_TopRight:radius_TR radius_BottomLeft:radius_BL radius_BottomRight:radius_BR rectSize:rectSize fillColor:fillColor];
    [tool configCornerBezierPath:bezierPath];
}

+ (UIImage *)RoundedCornerImageWithRadius_TL:(float)radius_TL
                                   radius_TR:(float)radius_TR
                                   radius_BL:(float)radius_BL
                                   radius_BR:(float)radius_BR
                                    rectSize:(CGSize)rectSize
                                   fillColor:(UIColor *)fillColor {
    UIGraphicsBeginImageContextWithOptions(rectSize, false, [UIScreen mainScreen].scale);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [self configPathWithBezierPath:&bezierPath radius_TL:radius_TL radius_TR:radius_TR radius_BL:radius_BL radius_BR:radius_BR rectSize:rectSize fillColor:fillColor];
    CGContextDrawPath(contextRef, kCGPathFillStroke);
    UIImage *antiRoundedCornerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return antiRoundedCornerImage;
}

+ (UIImage *)createQRCodeWithText:(NSString *)text qrCodeSize:(CGSize)qrCodeSize {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *qrImage = [filter outputImage];
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:qrImage size:qrCodeSize];
    return qrcode;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image size:(CGSize)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width / CGRectGetWidth(extent), size.height / CGRectGetHeight(extent));

    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef contextRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationNone);
    CGContextScaleCTM(contextRef, scale, scale);
    CGContextDrawImage(contextRef, extent, bitmapImage);

    CGImageRef scaledImage = CGBitmapContextCreateImage(contextRef);
    CGImageRelease(bitmapImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (void)generateSnapshotWithView:(UIView *)view completion:(void(^)(UIImage * _Nullable image))completion {
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, UIColor.whiteColor.CGColor);
    [view drawViewHierarchyInRect:(CGRect){0, 0, size} afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (completion) {
        completion(image);
    }
}

- (NSString *)imageHash {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(self)];
    CC_MD5([imageData bytes], (CC_LONG)[imageData length], result);
    NSString *imageHash = [NSString stringWithFormat:
                           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return imageHash;
}

@end
