//
//  YCTApiGetLocation.h
//  YCT
//
//  Created by 木木木 on 2021/12/26.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiGetLocation : YCTBaseRequest

- (instancetype)initWithPid:(NSString *)pid;

@end

NS_ASSUME_NONNULL_END
