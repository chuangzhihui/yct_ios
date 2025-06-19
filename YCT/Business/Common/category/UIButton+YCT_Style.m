//
//  UIButton+YCT_Style.m
//  YCT
//
//  Created by 木木木 on 2021/12/11.
//

#import "UIButton+YCT_Style.h"

@implementation UIButton (YCT_Style)

- (void)setMainThemeStyleWithTitle:(NSString *)title
                          fontSize:(CGFloat)fontSize
                      cornerRadius:(CGFloat)cornerRadius
                         imageName:(NSString *)imageName {
    if (imageName) {
        [self setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:UIControlStateNormal];
    } else {
        [self setImage:nil forState:UIControlStateNormal];
    }
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.backgroundColor = UIColor.mainThemeColor;
    if (fontSize < 15) {
        self.titleLabel.font = [UIFont PingFangSCMedium:fontSize];
    } else {
        self.titleLabel.font = [UIFont PingFangSCBold:fontSize];
    }
    self.layer.cornerRadius = cornerRadius;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -4);
    self.tintColor = UIColor.whiteColor;
}

- (void)setDarkStyleWithTitle:(NSString *)title
                     fontSize:(CGFloat)fontSize
                 cornerRadius:(CGFloat)cornerRadius
                    imageName:(NSString *)imageName {
    if (imageName) {
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    } else {
        [self setImage:nil forState:UIControlStateNormal];
    }
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.backgroundColor = UIColor.blackButtonBgColor;
    if (fontSize < 15) {
        self.titleLabel.font = [UIFont PingFangSCMedium:fontSize];
    } else {
        self.titleLabel.font = [UIFont PingFangSCBold:fontSize];
    }
    self.layer.cornerRadius = cornerRadius;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -4);
    self.tintColor = UIColor.whiteColor;
}

- (void)setGrayStyleWithTitle:(NSString *)title
                     fontSize:(CGFloat)fontSize
                 cornerRadius:(CGFloat)cornerRadius
                    imageName:(NSString *)imageName {
    if (imageName) {
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    } else {
        [self setImage:nil forState:UIControlStateNormal];
    }
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:UIColor.mainTextColor forState:UIControlStateNormal];
    self.backgroundColor = UIColor.grayButtonBgColor;
    if (fontSize < 15) {
        self.titleLabel.font = [UIFont PingFangSCMedium:fontSize];
    } else {
        self.titleLabel.font = [UIFont PingFangSCBold:fontSize];
    }
    self.layer.cornerRadius = cornerRadius;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -4);
    self.tintColor = UIColor.mainTextColor;
}

@end
