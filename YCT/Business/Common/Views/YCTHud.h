//
//  YCTHud.h
//  YCT
//
//  Created by 木木木 on 2021/12/26.
//

#import <Foundation/Foundation.h>

static NSTimeInterval kDefaultDelayTimeInterval = 2;

NS_ASSUME_NONNULL_BEGIN

@protocol YCTHudDelegate <NSObject>

- (void)showLoadingHud;
- (void)showLoadingHud:(NSString *)text;

- (void)showSuccessHud:(NSString * _Nullable)text;

- (void)showFailedHud:(NSString * _Nullable)text;

- (void)showToastHud:(NSString * _Nullable)text;

- (void)showDetailToastHud:(NSString * _Nullable)text;

- (void)showProgress:(float)progess text:(NSString * _Nullable)text;

- (void)showProgress:(float)progess;

- (void)hideHud;

- (void)hideHudAfterDelay:(NSTimeInterval)delay completion:(void (^ _Nullable)(void))completion;

@end

@interface YCTHud : NSObject<YCTHudDelegate>

+ (instancetype)sharedInstance;

@end

@interface UIView (YCTHud)<YCTHudDelegate>

@end

NS_ASSUME_NONNULL_END
