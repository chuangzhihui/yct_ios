//
//  YCTApiBlacklist.h
//  YCT
//
//  Created by 木木木 on 2022/1/9.
//

#import "YCTPagedRequest.h"
#import "YCTBlacklistItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YCTHandleBlacklistType) {
    YCTHandleBlacklistTypeAdd,
    YCTHandleBlacklistTypeRemove,
};

@interface YCTApiHandleBlacklist : YCTBaseRequest

- (instancetype)initWithType:(YCTHandleBlacklistType)type
                      userId:(NSString *)userId;

@end

@interface YCTApiBlacklist : YCTPagedRequest

@end

NS_ASSUME_NONNULL_END
