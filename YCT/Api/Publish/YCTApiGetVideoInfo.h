//
//  YCTApiGetVideoInfo.h
//  YCT
//
//  Created by hua-cloud on 2022/1/21.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiGetVideoInfo : YCTBaseRequest

- (instancetype)initWithVideoId:(NSInteger)videoId;
@end

NS_ASSUME_NONNULL_END
