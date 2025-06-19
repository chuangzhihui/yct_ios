//
//  YCTPostCreationView.h
//  YCT
//
//  Created by 木木木 on 2021/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTPostCreationView : UIView

@property (copy, nonatomic) void (^clickBlock)(int buttonIndex);

@end

NS_ASSUME_NONNULL_END
