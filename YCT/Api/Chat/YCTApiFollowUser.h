//
//  YCTApiFollowUser.h
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import "YCTBaseRequest.h"

typedef NS_ENUM(NSUInteger, YCTApiFollowUserType) {
    YCTApiFollowUserTypeFollow,
    YCTApiFollowUserTypeCancel,
};

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiFollowUser : YCTBaseRequest

- (instancetype)initWithType:(YCTApiFollowUserType)type
                      userId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
