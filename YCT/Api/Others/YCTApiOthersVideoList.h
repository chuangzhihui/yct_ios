//
//  YCTApiOthersVideoList.h
//  YCT
//
//  Created by 木木木 on 2022/1/5.
//

#import "YCTPagedRequest.h"
#import "YCTVideoModel.h"

typedef NS_ENUM(NSUInteger, YCTOthersVideoListType) {
    YCTOthersVideoListTypeWorks = 0,
    YCTOthersVideoListTypeLikes,
};

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiOthersVideoList : YCTPagedRequest

- (instancetype)initWithType:(YCTOthersVideoListType)type userId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
