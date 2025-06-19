//
//  UIView+Presentation.h
//  YCT
//
//  Created by 木木木 on 2021/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Presentation)

- (void)yct_show;
- (void)yct_showWithTitle:(NSString * _Nullable)title;
- (void)yct_showWithTitle:(NSString * _Nullable)title
              cancelTitle:(NSString * _Nullable)cancelTitle;

- (void)yct_showAlertStyle;
- (void)yct_showAlertStyleWithTitle:(NSString *)title;

- (void)yct_closeWithCompletion:(void (^ _Nullable)(void))completion;

#pragma mark - Dragable Present

- (void)dismissForDragPresent;
- (void)dismissForDragPresentWithCompletion:(void (^ _Nullable)(void))completion;

#pragma mark - AlertSheet

+ (void)showAlertSheetWith:(NSString *)title
               clickAction:(void (^ _Nullable)(void))clickAction;

@end

NS_ASSUME_NONNULL_END
