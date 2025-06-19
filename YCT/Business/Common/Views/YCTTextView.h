//
//  YCTTextView.h
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import <UIKit/UIKit.h>
#import <IQKeyboardManager/IQTextView.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTTextView : UIView

@property (nonatomic, strong, readonly) IQTextView *textView;
@property (nonatomic, strong) UILabel *countLimitLabel;

@property (nonatomic, assign) NSUInteger limitLength;

@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat marginTop;

@end

NS_ASSUME_NONNULL_END
