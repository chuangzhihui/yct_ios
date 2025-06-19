//
//  UITabBar+Badge.h
//  YCT
//
//  Created by 木木木 on 2022/5/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index;

- (void)hideBadgeOnItemIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
