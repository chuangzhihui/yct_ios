//
//  YCT_Helper.h
//  YCT
//
//  Created by 张大爷的 on 2022/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCT_Helper : NSObject
+(void)showWebView:(NSString *)url title:(NSString *)title;
/**
 *设置单侧边框
 */
+(void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
