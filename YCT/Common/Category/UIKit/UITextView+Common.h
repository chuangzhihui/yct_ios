//
//  UITextView+Common.h
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Common)

- (void)executeValueChangedTransactionKeepingCursorPosition:(void (^)(void))transaction;

@end

NS_ASSUME_NONNULL_END
