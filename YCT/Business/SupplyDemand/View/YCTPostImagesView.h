//
//  YCTPostImagesView.h
//  YCT
//
//  Created by 木木木 on 2021/12/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTPostImagesView : UIView

@property (nonatomic, copy) void (^imagViewClickBlock)(NSUInteger index);

- (void)updateWithUrls:(NSArray<NSString *> *)urls;

- (UIImageView *)imageViewAtIndex:(NSUInteger)index;

+ (CGFloat)heightWithTotal:(NSUInteger)total;

@end

NS_ASSUME_NONNULL_END
