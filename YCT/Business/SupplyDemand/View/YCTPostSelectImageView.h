//
//  YCTPostSelectImageView.h
//  YCT
//
//  Created by 木木木 on 2021/12/23.
//

#import <UIKit/UIKit.h>
#import "YCTImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTPostSelectImageView : UIView

@property (nonatomic, assign, readonly) NSUInteger currentCount;
@property (nonatomic, copy) NSArray<YCTImageModel *> *imageModels;
@property (nonatomic, copy) void (^selectImageBlock)(void);
@property (nonatomic, copy) void (^deleteImageBlock)(NSUInteger index);

+ (CGFloat)standardHeight;

@end

NS_ASSUME_NONNULL_END
