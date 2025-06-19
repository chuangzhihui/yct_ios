//
//  UIImageView+YCTImageLoad.h
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (YCTImageLoad)

- (void)cancelLoadImage;

- (void)loadImageGraduallyWithURL:(NSURL *)url;

- (void)loadImageGraduallyWithURL:(NSURL *)url
             placeholderImageName:(NSString * _Nullable)placeholderImageName;

- (void)loadImageGraduallyWithURL:(NSURL *)url
             placeholderImageName:(NSString * _Nullable)placeholderImageName
                         complete:(void(^_Nullable)(UIImage *image))complete;

@end

NS_ASSUME_NONNULL_END
