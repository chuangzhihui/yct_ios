//
//  YCTOpenMessageObject.h
//  YCT
//
//  Created by 木木木 on 2022/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTShareObject : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
/// 缩略图 UIImage或者NSData类型或者NSString类型（图片url）
@property (nonatomic, strong) id thumbImage;
@end

@interface YCTOpenMessageObject : NSObject
@property (nonatomic, strong) YCTShareObject *shareObject;
@end

@interface YCTShareVideoItem : YCTShareObject
@property (nonatomic, copy) NSString *videoUrl;
@end

@interface YCTShareWebpageItem : YCTShareObject
@property (nonatomic, copy) NSString *webpageUrl;
@end

NS_ASSUME_NONNULL_END
