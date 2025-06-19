//
//  YCTApiGetCommentList.h
//  YCT
//
//  Created by hua-cloud on 2022/1/8.
//

#import "YCTBaseRequest.h"
#import "YCTCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCTApiGetCommentList : YCTBaseRequest

- (instancetype)initWithPage:(NSInteger)page videoId:(NSString *)videoId;

- (instancetype)initSecondWithPid:(NSString *)pid;
@end

NS_ASSUME_NONNULL_END
