//
//  UITabBar+Badge.m
//  YCT
//
//  Created by 木木木 on 2022/5/5.
//

#import "UITabBar+Badge.h"

@implementation UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index {
    
    if (index >= self.items.count) return;

    [self removeBadgeOnItemIndex:index];

    UIView *badgeView = [[UIView alloc] init];

    badgeView.tag = 888 + index;

    badgeView.layer.cornerRadius = 5;

    badgeView.backgroundColor = [UIColor redColor];

    CGRect tabFrame = self.frame;


    CGFloat percentX = (index + 0.63) / self.items.count;

    badgeView.frame = (CGRect){
        ceilf(percentX * tabFrame.size.width),
        ceilf(0.115 * tabFrame.size.height),
        10,
        10};

    [self addSubview:badgeView];
}

- (void)hideBadgeOnItemIndex:(int)index {
    [self removeBadgeOnItemIndex:index];
}

- (void)removeBadgeOnItemIndex:(int)index {
    [[self viewWithTag:888 + index] removeFromSuperview];
}

@end
