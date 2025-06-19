//
//  UIWindow+Common.m
//  YCT
//
//  Created by 木木木 on 2021/12/28.
//

#import "UIWindow+Common.h"

@implementation UIWindow (Common)

+ (UIViewController *)yct_currentViewController {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIViewController *currentViewController = window.rootViewController;

    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            currentViewController = ((UITabBarController *)currentViewController).selectedViewController;
        } else {
            break;
        }
    }
    return currentViewController;
}

@end
