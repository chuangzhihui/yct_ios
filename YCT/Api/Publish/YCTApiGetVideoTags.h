//
//  YCTApiGetVideoTags.h
//  YCT
//
//  Created by hua-cloud on 2022/1/7.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiGetVideoTags : YCTBaseRequest
- (instancetype)initWithTagText:(NSString *)tagText;
@end

NS_ASSUME_NONNULL_END
