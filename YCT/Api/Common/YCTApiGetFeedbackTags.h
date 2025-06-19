//
//  YCTApiGetFeedbackTags.h
//  YCT
//
//  Created by hua-cloud on 2022/1/21.
//

#import "YCTBaseRequest.h"
#import "YCTFeedBackTagsModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, YCTApiGetFeedbackTagsType) {
    YCTApiGetFeedbackTagsTypeInform,
    YCTApiGetFeedbackTagsTypeFeedBack
};
@interface YCTApiGetFeedbackTags : YCTBaseRequest

- (instancetype)initWithType:(YCTApiGetFeedbackTagsType)type;
@end

NS_ASSUME_NONNULL_END
