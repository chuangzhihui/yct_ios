//
//  UIFont+YCT_Theme.m
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import "UIFont+YCT_Theme.h"

@implementation UIFont (YCT_Theme)

+ (UIFont *)PingFangSCRegular:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PingFang-SC" size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

+ (UIFont *)PingFangSCMedium:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PingFang-SC-Medium" size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size weight:(UIFontWeightMedium)];
    }
    return font;
}

+ (UIFont *)PingFangSCBold:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PingFang-SC-Semibold" size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size weight:(UIFontWeightBold)];
    }
    return font;
}

+ (UIFont *)segmentFont {
    return [self PingFangSCMedium:16];
}

+ (UIFont *)segmentSelectedFont {
    return [self PingFangSCBold:16];
}

@end
