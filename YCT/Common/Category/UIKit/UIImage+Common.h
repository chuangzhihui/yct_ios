//
//  UIImage+Common.h
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Common)

+ (UIImage *)imageWithColor:(UIColor *)color
                       Size:(CGSize)targetSize
               CornerRadius:(CGFloat)cornerRadius;

+ (UIImage *)RoundedCornerImageWithRadius_TL:(float)radius_TL
                                   radius_TR:(float)radius_TR
                                   radius_BL:(float)radius_BL
                                   radius_BR:(float)radius_BR
                                    rectSize:(CGSize)rectSize
                                   fillColor:(UIColor *)fillColor;

+ (UIImage *)createQRCodeWithText:(NSString *)text qrCodeSize:(CGSize)qrCodeSize;

+ (void)generateSnapshotWithView:(UIView *)view completion:(void(^)(UIImage * _Nullable image))completion;

- (NSString *)imageHash;

@end

NS_ASSUME_NONNULL_END
