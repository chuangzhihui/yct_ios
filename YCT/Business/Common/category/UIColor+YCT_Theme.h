//
//  UIColor+YCT_Theme.h
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (YCT_Theme)

+ (UIColor *)mainThemeColor;
+ (UIColor *)mainThemeColorLight;

+ (UIColor *)navigationBarColor;
+ (UIColor *)navigationBarTitleColor;

+ (UIColor *)tabbarTitleColorDark;
+ (UIColor *)tabbarTitleColorDarkSelected;
+ (UIColor *)tabbarTitleColorLight;
+ (UIColor *)tabbarTitleColorLightSelected;

+ (UIColor *)separatorColor;
+ (UIColor *)segmentTitleColor;
+ (UIColor *)segmentSelectedTitleColor;

+ (UIColor *)yct_redColor;
+ (UIColor *)yct_systemplaceholderColor;

+ (UIColor *)blackButtonBgColor;
+ (UIColor *)grayButtonBgColor;
+ (UIColor *)selectedButtonBgColor;
+ (UIColor *)tableBackgroundColor;
+ (UIColor *)subTextColor;
+ (UIColor *)placeholderColor;
+ (UIColor *)mainTextColor;
+ (UIColor *)mainGrayTextColor;
@end

NS_ASSUME_NONNULL_END
