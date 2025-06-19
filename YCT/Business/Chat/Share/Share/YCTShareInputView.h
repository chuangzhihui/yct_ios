//
//  YCTShareInputView.h
//  YCT
//
//  Created by 木木木 on 2022/1/7.
//

#import <UIKit/UIKit.h>
#import "YCTTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTShareInputView : UIView

@property (nonatomic, strong, readonly) UIButton *sendButton;

@property (nonatomic, copy, readonly) NSString *text;

@end

NS_ASSUME_NONNULL_END
