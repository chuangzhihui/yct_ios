//
//  YCTApiPublishComment.h
//  YCT
//
//  Created by hua-cloud on 2022/1/8.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiPublishComment : YCTBaseRequest

- (instancetype)initWithVideoId:(NSString *)videoId pid:(NSString *)pid content:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
