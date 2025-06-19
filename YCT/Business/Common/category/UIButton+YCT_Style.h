//
//  UIButton+YCT_Style.h
//  YCT
//
//  Created by 木木木 on 2021/12/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (YCT_Style)

- (void)setMainThemeStyleWithTitle:(NSString *)title
                          fontSize:(CGFloat)fontSize
                      cornerRadius:(CGFloat)cornerRadius
                         imageName:(NSString * __nullable)imageName;

- (void)setDarkStyleWithTitle:(NSString *)title
                     fontSize:(CGFloat)fontSize
                 cornerRadius:(CGFloat)cornerRadius
                    imageName:(NSString * __nullable)imageName;

- (void)setGrayStyleWithTitle:(NSString *)title
                     fontSize:(CGFloat)fontSize
                 cornerRadius:(CGFloat)cornerRadius
                    imageName:(NSString * __nullable)imageName;

@end

NS_ASSUME_NONNULL_END
