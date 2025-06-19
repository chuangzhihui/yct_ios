//
//  UIColor+YCT_Theme.m
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import "UIColor+YCT_Theme.h"

@implementation UIColor (YCT_Theme)

+ (UIColor *)mainThemeColor {
    return UIColorFromRGB(0x00C6FF);
}

+ (UIColor *)mainThemeColorLight {
    return UIColorFromRGB(0xB8E9FF);
}

#pragma mark - NavigationBar

+ (UIColor *)navigationBarColor {
    return UIColor.whiteColor;
}

+ (UIColor *)navigationBarTitleColor {
    return self.mainTextColor;
}

#pragma mark - Tabbar

+ (UIColor *)tabbarTitleColorDark {
    return UIColorFromRGB(0x999999);
}

+ (UIColor *)tabbarTitleColorDarkSelected {
    return UIColorFromRGB(0xFFFFFF);
}

+ (UIColor *)tabbarTitleColorLight {
    return UIColorFromRGB(0x999999);
}

+ (UIColor *)tabbarTitleColorLightSelected {
    return self.mainTextColor;
}

+ (UIColor *)separatorColor {
    return UIColorFromRGB(0xEFEFEF);
}

+ (UIColor *)segmentTitleColor {
    return UIColorFromRGB(0x999999);
}

+ (UIColor *)segmentSelectedTitleColor {
    return self.mainTextColor;
}

#pragma mark - Other

+ (UIColor *)yct_redColor {
    return UIColorFromRGB(0xFE2B54);
}

+ (UIColor *)blackButtonBgColor {
    return UIColorFromRGB(0x1A1A1A);
}

+ (UIColor *)grayButtonBgColor {
    return UIColorFromRGB(0xEFEFEF);
}

+ (UIColor *)selectedButtonBgColor {
    return UIColorFromRGB(0xD3D3D3);
}

+ (UIColor *)tableBackgroundColor {
    return UIColorFromRGB(0xF8F8F8);
}

+ (UIColor *)subTextColor {
    return UIColorFromRGB(0xC1C1C1);
}

+ (UIColor *)placeholderColor {
    return UIColorFromRGB(0xC1C1C1);
}

+ (UIColor *)mainTextColor {
    return UIColorFromRGB(0x333333);
}

+ (UIColor *)mainGrayTextColor {
    return UIColorFromRGB(0x999999);
}

+ (UIColor *)yct_systemplaceholderColor {
    return UIColorFromRGB(0xC7C7CD);
}

@end
