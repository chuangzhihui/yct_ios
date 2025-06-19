//
//  YCTPhotoBrowser.m
//  YCT
//
//  Created by 木木木 on 2022/1/13.
//

#import "YCTPhotoBrowser.h"
#import <GKPhotoBrowser.h>

@implementation YCTPhotoBrowser

+ (void)showPhotoBrowerInVC:(UIViewController *)viewController
                 photoCount:(NSUInteger)photoCount
               currentIndex:(NSUInteger)currentIdx
                photoConfig:(void (^)(NSUInteger idx, NSURL **photoUrl, UIImageView **sourceImageView))photoConfig {
//    GKPhotoBrowserShowStyle showStyle = GKPhotoBrowserShowStyleZoom;
//    GKPhotoBrowserHideStyle hideStyle = GKPhotoBrowserHideStyleZoomScale;
    
    GKPhotoBrowserShowStyle showStyle = GKPhotoBrowserShowStyleNone;
    GKPhotoBrowserHideStyle hideStyle = GKPhotoBrowserHideStyleZoomSlide;
    
    NSMutableArray *photos = [NSMutableArray new];
    for (NSUInteger i = 0; i < photoCount; i ++) {
        GKPhoto *photo = [GKPhoto new];
        NSURL *photoUrl;
        UIImageView *sourceImageView;
        !photoConfig ?: photoConfig(i, &photoUrl, &sourceImageView);
        photo.url = photoUrl;
        photo.sourceImageView = sourceImageView;
//        if (!sourceImageView && showStyle == GKPhotoBrowserShowStyleZoom) {
//            showStyle = GKPhotoBrowserShowStyleNone;
//            hideStyle = GKPhotoBrowserHideStyleZoomSlide;
//        }
        [photos addObject:photo];
    }
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:currentIdx];
    browser.showStyle = showStyle;
    browser.hideStyle = hideStyle;
    browser.loadStyle = GKPhotoBrowserLoadStyleIndeterminateMask;
    browser.maxZoomScale = 20.0f;
    browser.doubleZoomScale = 2.0f;
    browser.isAdaptiveSafeArea = YES;
    browser.hidesCountLabel = YES;
    browser.pageControl.hidden = NO;
    [browser showFromVC:viewController];
}

@end
