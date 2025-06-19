//
//  YCTPhotoBrowser.h
//  YCT
//
//  Created by 木木木 on 2022/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTPhotoBrowser : NSObject

+ (void)showPhotoBrowerInVC:(UIViewController *)viewController
                 photoCount:(NSUInteger)photoCount
               currentIndex:(NSUInteger)currentIdx
                photoConfig:(void (^)(NSUInteger idx, NSURL * _Nonnull * _Nullable photoUrl, UIImageView * _Nonnull * _Nullable sourceImageView))photoConfig;
    
@end

NS_ASSUME_NONNULL_END
