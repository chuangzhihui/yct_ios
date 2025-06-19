//
//  YCTImageModelUtil.h
//  YCT
//
//  Created by 木木木 on 2022/1/11.
//

#import <Foundation/Foundation.h>
#import "YCTImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTImageModelUtil : NSObject

@property (nonatomic, copy, readonly) NSArray<YCTImageModel *> *imageModels;
@property (nonatomic, copy, readonly) NSArray<NSString *> *imageUrls;
@property (nonatomic, assign, readonly) NSUInteger count;

- (void)addImage:(UIImage *)image;
- (void)addImages:(NSArray<UIImage *> *)images;
- (void)addImageUrl:(NSString *)imageUrl;
- (void)addImageUrls:(NSArray<NSString *> *)imageUrls;

- (void)removeImage:(UIImage *)image;
- (void)removeAtIndex:(NSUInteger)index;

- (void)fetchImageUrlWithCompletion:(void (^ _Nullable)(NSArray * _Nullable imageUrls))completion;

@end

NS_ASSUME_NONNULL_END
