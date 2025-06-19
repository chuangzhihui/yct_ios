//
//  YCTVerticalButton.m
//  YCT
//
//  Created by 木木木 on 2021/12/18.
//

#import "YCTVerticalButton.h"

@implementation YCTVerticalButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width / 2;
    center.y = self.imageView.frame.size.height /  2;
    self.imageView.center = center;
    // fixed
    CGRect imageFrame = [self imageView].frame;
    imageFrame.origin.y = (self.frame.size.height - imageFrame.size.height - self.titleLabel.frame.size.height - _spacing) / 2;
    self.imageView.frame = imageFrame;
    
    // fixed
    CGRect titleFrame = [self titleLabel].frame;
    titleFrame.origin.x = 0;
    titleFrame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + _spacing;
    titleFrame.size.width = self.frame.size.width;
    self.titleLabel.frame = titleFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)configTitle:(NSString *)title imageName:(NSString *)imageName {
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}

- (void)setSpacing:(CGFloat)spacing {
    _spacing = spacing;
    
    [self setNeedsLayout];
}

@end
