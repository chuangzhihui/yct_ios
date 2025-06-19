//
//  YCTApiDelVideo.h
//  YCT
//
//  Created by hua-cloud on 2022/1/18.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiDelVideo : YCTBaseRequest
- (instancetype)initWithVideoId:(NSString *)videoId;
@end

NS_ASSUME_NONNULL_END
