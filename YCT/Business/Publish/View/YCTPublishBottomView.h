//
//  YCTPublishBottomView.h
//  YCT
//
//  Created by hua-cloud on 2021/12/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTPublishBottomView : UIView
@property (nonatomic, copy) void (^onButtonClick)(void);
@property (nonatomic, copy) void (^moveToProfileAdd)(void);
@property (nonatomic, copy) void (^userProfileCallBack)(void);
@property (copy, nonatomic) void (^clickBlock)(int buttonIndex);

@end

NS_ASSUME_NONNULL_END
