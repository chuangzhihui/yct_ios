//
//  YCTApiWatchVideo.h
//  YCT
//
//  Created by hua-cloud on 2022/2/14.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiWatchVideo : YCTBaseRequest
- (instancetype)initWithVideoId:(NSString *)videoId;
@end

NS_ASSUME_NONNULL_END
