//
//  UIViewController+Utils.h
//  YCT
//
//  Created by 木木木 on 2021/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Utils)

+ (UINavigationController*)currentNavigationViewController;

+ (UIViewController *)currentViewController;
@end

NS_ASSUME_NONNULL_END
