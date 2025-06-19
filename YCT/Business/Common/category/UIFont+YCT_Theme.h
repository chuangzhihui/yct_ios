//
//  UIFont+YCT_Theme.h
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (YCT_Theme)

+ (UIFont *)PingFangSCRegular:(CGFloat)size;
+ (UIFont *)PingFangSCMedium:(CGFloat)size;
+ (UIFont *)PingFangSCBold:(CGFloat)size;

+ (UIFont *)segmentFont;
+ (UIFont *)segmentSelectedFont;

@end

NS_ASSUME_NONNULL_END
