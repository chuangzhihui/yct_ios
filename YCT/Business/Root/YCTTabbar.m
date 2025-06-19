//
//  YCTTabbar.m
//  YCT
//
//  Created by 木木木 on 2021/12/8.
//

#import "YCTTabbar.h"

#define kMiddleButtonSize 38

@implementation YCTTabbar

- (instancetype)init {
    self = [super init];
    if (self) {
        self.middleButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        [self.middleButton setImage:[UIImage imageNamed:@"tabbar_+2"] forState:(UIControlStateNormal)];
        [self.middleButton setBackgroundImage:[UIImage imageNamed:@"tabbar_+2"] forState:(UIControlStateNormal)];
        [self.middleButton setTitle:@"＋" forState:(UIControlStateNormal)];
        [self.middleButton setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        self.middleButton.titleLabel.font = [UIFont systemFontOfSize:30 weight:(UIFontWeightRegular)];
        [self addSubview:self.middleButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = CGRectGetHeight(self.frame);
    if (@available(iOS 11.0, *)) {
        height -= self.safeAreaInsets.bottom;
    }
    
    self.middleButton.frame = CGRectMake((CGRectGetWidth(self.frame) - kMiddleButtonSize) / 2, (height - kMiddleButtonSize) / 2, kMiddleButtonSize, kMiddleButtonSize);
    [self bringSubviewToFront:self.middleButton];
}

@end
