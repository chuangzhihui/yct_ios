//
//  UITextView+YCT_RAC.h
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (YCT_RAC)

- (RACSignal *)rac_inputTextSignal RAC_WARN_UNUSED_RESULT;

@end

NS_ASSUME_NONNULL_END
