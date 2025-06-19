//
//  YCTDragPresentView.h
//  YCT
//
//  Created by 木木木 on 2021/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTDragPresentConfig : NSObject
@property (nonatomic, assign) BOOL ignoreScrollGestureHandle;
@property (nonatomic, assign) BOOL ignoreViewHeight;
@property (nonatomic, assign) CGFloat viewHeight;
@end

@interface YCTDragPresentView : NSObject

+ (YCTDragPresentView *)sharePresentView;

- (void)showView:(UIView *)view;
- (void)showViewController:(UIViewController *)viewController;

- (void)showView:(UIView *)view configMaker:(void (^ _Nullable)(YCTDragPresentConfig *config))configMaker;
- (void)showViewController:(UIViewController *)viewController configMaker:(void (^ _Nullable)(YCTDragPresentConfig *config))configMaker;

- (void)dismiss;
- (void)dismissWithCompletion:(void (^ _Nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
