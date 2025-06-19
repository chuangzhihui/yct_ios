//
//  YCTMultiLineTextField.m
//  YCT
//
//  Created by 木木木 on 2022/4/11.
//

#import "YCTMultiLineTextField.h"

@implementation YCTMultiLineTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self yct_initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self yct_initialize];
    }
    return self;
}

- (void)yct_initialize {
    self.scrollEnabled = NO;
    self.textContainerInset = UIEdgeInsetsZero;
    self.textContainer.lineFragmentPadding = 0;
    if (@available(iOS 13.0, *)) {
        self.placeholderTextColor = UIColor.placeholderTextColor;
    } else {
        self.placeholderTextColor = UIColor.yct_systemplaceholderColor;
    }
}

@end
