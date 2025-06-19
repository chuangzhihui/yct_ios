//
//  YCTDatePickerView.h
//  YCT
//
//  Created by 木木木 on 2021/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTDatePickerView : UIView

@property (copy, nonatomic) void (^confirmClickBlock)(NSDate *date);

@end

NS_ASSUME_NONNULL_END
