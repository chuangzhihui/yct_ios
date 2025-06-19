//
//  YCTApiMyVideoList.h
//  YCT
//
//  Created by 木木木 on 2022/1/1.
//

#import "YCTPagedRequest.h"
#import "YCTVideoModel.h"

typedef NS_ENUM(NSUInteger, YCTMyVideoListType) {
    YCTMyVideoListTypeWorks = 0,
    YCTMyVideoListTypeLikes,
    YCTMyVideoListTypeCollection,
    YCTMyVideoListTypeAudit,
    YCTMyVideoListTypeDraft,
};

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiMyVideoList : YCTPagedRequest

- (instancetype)initWithType:(YCTMyVideoListType)type;

@end

NS_ASSUME_NONNULL_END
