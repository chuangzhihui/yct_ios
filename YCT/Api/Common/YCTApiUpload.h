//
//  YCTApiUpload.h
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTCOSUploaderTaskConfig : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *filePath;

@end

@interface YCTCOSUploaderResult : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *cosKey;

@end

@interface YCTApiUpload : YCTBaseRequest

/// 上传自定义文件
/// @param config 文件配置类
- (instancetype)initWithConfig:(YCTCOSUploaderTaskConfig *)config;

/// 上传图片
/// @param image 图片对象
- (instancetype)initWithImage:(UIImage *)image;

- (void)doStartWithSuccess:(void(^)(YCTCOSUploaderResult * _Nullable result))success failure:(void(^)(NSString * errorString))failure;
@end

NS_ASSUME_NONNULL_END
