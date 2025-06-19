//
//  YCTMoreBottomView.h
//  YCT
//
//  Created by hua-cloud on 2022/1/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTMoreBottomView : UIView

@property (copy, nonatomic) void (^clickBlock)(int buttonIndex);

- (instancetype)initWithIsColletion:(BOOL)isColletion;
@end

NS_ASSUME_NONNULL_END
