//
//  UIViewController+Utils.m
//  YCT
//
//  Created by 木木木 on 2021/12/14.
//

#import "UIViewController+Utils.h"
#import "NSObject+Utils.h"

@implementation UIViewController (Utils)

#if DEBUG
+ (void)load {
    [NSObject methodSwizzleWithClass:[self class] origSEL:NSSelectorFromString(@"dealloc") overrideSEL:@selector(override_dealloc)];
}
#endif

- (void)override_dealloc {
    NSLog(@"☀️☀️☀️☀️☀️ %@ dealloc", NSStringFromClass([self class]));
    [self override_dealloc];
}

+ (id<UIApplicationDelegate>)applicationDelegate {
    return [UIApplication sharedApplication].delegate;
}

+ (UINavigationController*)currentNavigationViewController {
    UIViewController* currentViewController = [self currentViewController];
    return currentViewController.navigationController;
}

+ (UIViewController *)currentViewController {
    UIViewController* rootViewController = self.applicationDelegate.window.rootViewController;
    return [self currentViewControllerFrom:rootViewController];
}

+ (UIViewController*)currentViewControllerFrom:(UIViewController*)viewController {
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController* navigationController = (UINavigationController *)viewController;
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
        
    } else if([viewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController* tabBarController = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
        
    } else if(viewController.presentedViewController != nil) {
        
        return [self currentViewControllerFrom:viewController.presentedViewController];
        
    } else {
        
        return viewController;
        
    }
}
@end
