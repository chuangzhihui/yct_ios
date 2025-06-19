//
//  YCTImageUploader.m
//  YCT
//
//  Created by 木木木 on 2022/1/5.
//

#import "YCTImageUploader.h"
#import "YCTApiUpload.h"
#import "UIImage+Common.h"

@implementation YCTImageUploaderOptionsMaker
- (instancetype)init {
    if (self = [super init]) {
        self.maxConcurrentTaskNumber = 1;//[[NSProcessInfo processInfo] activeProcessorCount];
    }
    return self;
}
@end

@interface YCTImageUploader ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *imageUrlDic;
@property (nonatomic, strong) dispatch_queue_t imageUploadQueue;
@end

@implementation YCTImageUploader

kDeallocDebugTest

- (void)uploadImage:(UIImage *)image completion:(void(^)(NSString *imageUrl))completion {
    YCTApiUpload *apiUpload = [[YCTApiUpload alloc] initWithImage:image];
    [apiUpload doStartWithSuccess:^(YCTCOSUploaderResult * _Nullable result) {
        NSString *imageHash = [image imageHash];
        [self.imageUrlDic setValue:result.url forKey:imageHash];
        !completion ?: completion(result.url);
    } failure:^(NSString * _Nonnull errorString) {
        !completion ?: completion(nil);
    }];
}

- (void)uploadImages:(NSArray *)images
        optionsMaker:(void (^)(YCTImageUploaderOptionsMaker *))optionsMaker
          completion:(YCTImageUploaderCompletion)completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.imageUrlDic removeAllObjects];
        YCTImageUploaderOptionsMaker *options = [[YCTImageUploaderOptionsMaker alloc] init];
        if (optionsMaker) optionsMaker(options);
        if (options.maxConcurrentTaskNumber < 1) {
            options.maxConcurrentTaskNumber = 1;
        }
        
        dispatch_semaphore_t semaphore;
        semaphore = dispatch_semaphore_create(options.maxConcurrentTaskNumber - 1);
        dispatch_group_t group = dispatch_group_create();
        for (UIImage *image in images) {
            dispatch_group_enter(group);
            [self uploadImage:image completion:^(NSString *imageUrl) {
                dispatch_group_leave(group);
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (completion) completion(self.imageUrlDic.copy);
        });
    });
}

- (NSMutableDictionary<NSString *,NSString *> *)imageUrlDic {
    if (!_imageUrlDic) {
        _imageUrlDic = @{}.mutableCopy;
    }
    return _imageUrlDic;
}

- (dispatch_queue_t)imageUploadQueue {
    if (!_imageUploadQueue) {
        _imageUploadQueue = dispatch_queue_create("cn.yct.imageupload", DISPATCH_QUEUE_CONCURRENT);
    }
    return _imageUploadQueue;
}

@end
