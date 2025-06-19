//
//  UIImageView+YCTImageLoad.m
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import "UIImageView+YCTImageLoad.h"

@implementation UIImageView (YCTImageLoad)

+ (void)initialize {
    [SDImageCodersManager.sharedManager addCoder:SDImageGIFCoder.sharedCoder];
}

- (void)cancelLoadImage {
    [self sd_cancelCurrentImageLoad];
}

- (void)loadImageGraduallyWithURL:(NSURL *)url {
    [self loadImageGraduallyWithURL:url placeholderImageName:nil complete:NULL];
}

- (void)loadImageGraduallyWithURL:(NSURL *)url placeholderImageName:(NSString *)placeholderImageName {
    [self loadImageGraduallyWithURL:url placeholderImageName:placeholderImageName complete:NULL];
}

- (void)loadImageGraduallyWithURL:(NSURL *)url placeholderImageName:(NSString *)placeholderImageName complete:(void(^)(UIImage *image))complete {
    @weakify(self);
    UIImage *placeholderImage = placeholderImageName ? [UIImage imageNamed:placeholderImageName] : nil;
    [self sd_setImageWithURL:url placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (SDImageCacheTypeNone == cacheType) {
            @strongify(self);
            if (image) {
                self.alpha = 0.0;
                [UIView transitionWithView:self
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    self.image = image;
                                    self.alpha = 1.0;
                                } completion:NULL];
            }
        }
        if (complete) {
            complete(image);
        }
    }];
}

@end
