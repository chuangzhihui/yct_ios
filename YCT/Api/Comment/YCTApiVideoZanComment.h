//
//  YCTApiVideoZanComment.h
//  YCT
//
//  Created by hua-cloud on 2022/1/9.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiVideoZanComment : YCTBaseRequest
- (instancetype)initWithCommentId:(NSString *)commentId;
@end

NS_ASSUME_NONNULL_END
