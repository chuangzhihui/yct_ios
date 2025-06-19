//
//  UIView+Common.h
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Common)

- (CGFloat)safeBottom;
- (CGFloat)safeTop;

+ (UINib *)nib;
+ (NSString *)cellReuseIdentifier;

- (UIViewController *)superVC;
- (UIViewController *)parentVC;

- (void)setDismissOnClick;

@end

NS_ASSUME_NONNULL_END
