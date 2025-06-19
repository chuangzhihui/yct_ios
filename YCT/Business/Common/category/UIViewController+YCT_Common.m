//
//  UIViewController+YCT_Common.m
//  YCT
//
//  Created by 木木木 on 2021/12/20.
//

#import "UIViewController+YCT_Common.h"

@implementation UIViewController (YCT_Common)

- (void)changeNavigationBarColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor {
    void (^animations)(void) = ^{
        if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance *navigationBarAppearance = self.navigationController.navigationBar.standardAppearance;
            navigationBarAppearance.titleTextAttributes = @{
                NSForegroundColorAttributeName: titleColor
            };
            navigationBarAppearance.backgroundColor = backgroundColor;
            self.navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance;
            self.navigationController.navigationBar.standardAppearance = navigationBarAppearance;
        } else {
            if (CGColorEqualToColor(UIColor.clearColor.CGColor, backgroundColor.CGColor)) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:(UIBarMetricsDefault)];
            } else {
                [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:(UIBarMetricsDefault)];
            }
            [self.navigationController.navigationBar setBarTintColor:backgroundColor];
            [self.navigationController.navigationBar setTitleTextAttributes:
             @{NSForegroundColorAttributeName: titleColor}];
        }
        self.navigationController.navigationBar.tintColor = titleColor;
        [self.navigationController.navigationBar layoutIfNeeded];
    };
    
    UIViewAnimationOptions option = UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut;
    [UIView transitionWithView:self.navigationController.navigationBar duration:0.2 options:option animations:animations completion:NULL];
}

@end
