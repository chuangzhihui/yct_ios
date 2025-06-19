//
//  YCTImageModelUtil.m
//  YCT
//
//  Created by 木木木 on 2022/1/11.
//

#import "YCTImageModelUtil.h"
#import "YCTImageUploader.h"
#import "UIImage+Common.h"

@interface YCTImageModelUtil ()
@property (nonatomic, copy, readwrite) NSArray<YCTImageModel *> *imageModels;
@property (nonatomic, copy, readwrite) NSArray<NSString *> *imageUrls;
@property (nonatomic, strong) NSMutableArray<YCTImageModel *> *imageModelsM;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, YCTImageModel *> *imageModelsDic;
@property (nonatomic, strong) YCTImageUploader *imageUploader;
@end

@implementation YCTImageModelUtil

- (void)addImage:(UIImage *)image {
    YCTImageModel *model = [[YCTImageModel alloc] init];
    model.image = image;
    [self.imageModelsM addObject:model];
}

- (void)addImages:(NSArray<UIImage *> *)images {
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YCTImageModel *model = [[YCTImageModel alloc] init];
        model.image = obj;
        [self.imageModelsM addObject:model];
    }];
    [self _resetImageUrls];
}

- (void)addImageUrl:(NSString *)imageUrl {
    YCTImageModel *model = [[YCTImageModel alloc] init];
    model.imageUrl = imageUrl;
    [self.imageModelsM addObject:model];
    [self _resetImageUrls];
}

- (void)addImageUrls:(NSArray<NSString *> *)imageUrls {
    [imageUrls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YCTImageModel *model = [[YCTImageModel alloc] init];
        model.imageUrl = obj;
        [self.imageModelsM addObject:model];
    }];
    [self _resetImageUrls];
}

- (void)removeImage:(UIImage *)image {
    YCTImageModel *model = [self _imageModelWithImage:image];
    if (model) {
        [self.imageModelsM removeObject:model];
        [self _resetImageUrls];
    }
}

- (void)removeAtIndex:(NSUInteger)index {
    if (index < self.imageModelsM.count) {
        [self.imageModelsM removeObjectAtIndex:index];
        [self _resetImageUrls];
    }
}

- (void)fetchImageUrlWithCompletion:(void (^)(NSArray *))completion {
    if (self.imageUrls.count == self.imageModelsM.count) {
        !completion ?: completion(self.imageUrls);
        return;
    }
    
    NSMutableArray<UIImage *> *withouUrlImages = @[].mutableCopy;
    [self.imageModelsM enumerateObjectsUsingBlock:^(YCTImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.imageUrl ?: [withouUrlImages addObject:obj.image];
    }];
    
    [self.imageUploader uploadImages:withouUrlImages optionsMaker:NULL completion:^(NSDictionary * _Nonnull imageUrlDic) {
        [self.imageModelsM enumerateObjectsUsingBlock:^(YCTImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *imgHash = obj.imageHash;
            if (imgHash && imageUrlDic[imgHash]) {
                obj.imageUrl = imageUrlDic[imgHash];
            }
        }];
        !completion ?: completion(self.imageUrls);
    }];
}

- (YCTImageModel *)_imageModelWithImage:(UIImage *)image {
    NSString *imageHash = [image imageHash];
    __block YCTImageModel *model;
    [self.imageModelsM enumerateObjectsUsingBlock:^(YCTImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.image == image
            || (obj.imageHash && [obj.imageHash isEqualToString:imageHash])) {
            model = obj;
            *stop =  YES;
        }
    }];
    return model;
}

#pragma mark - Private

- (void)_resetImageUrls {
    self.imageModels = self.imageModelsM.copy;
}

#pragma mark - Getter

- (NSMutableArray<YCTImageModel *> *)imageModelsM {
    if (!_imageModelsM) {
        _imageModelsM = @[].mutableCopy;
    }
    return _imageModelsM;
}

- (NSUInteger)count {
    return self.imageModelsM.count;
}

- (NSArray<NSString *> *)imageUrls {
    NSMutableArray *urls = @[].mutableCopy;
    [self.imageModelsM enumerateObjectsUsingBlock:^(YCTImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        !obj.imageUrl ?: [urls addObject:obj.imageUrl];
    }];
    return urls.copy;
}

//- (NSMutableDictionary<NSString *,YCTImageModel *> *)imageModelsDic {
//    if (!_imageModelsDic) {
//        _imageModelsDic = @{}.mutableCopy;
//    }
//    return _imageModelsDic;
//}

- (YCTImageUploader *)imageUploader {
    if (!_imageUploader) {
        _imageUploader = [[YCTImageUploader alloc] init];
    }
    return _imageUploader;
}

@end
