//
//  YCTApiApplyVideo.h
//  YCT
//
//  Created by hua-cloud on 2022/1/21.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiApplyVideo : YCTBaseRequest
- (instancetype)initWithVideoId:(NSInteger)videoId;
@end

NS_ASSUME_NONNULL_END
