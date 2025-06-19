//
//  YCTApiGetFeedbackTags.m
//  YCT
//
//  Created by hua-cloud on 2022/1/21.
//

#import "YCTApiGetFeedbackTags.h"

@implementation YCTApiGetFeedbackTags{
    YCTApiGetFeedbackTagsType _type;
}

- (instancetype)initWithType:(YCTApiGetFeedbackTagsType)type{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (NSString *)requestUrl{
    return _type == YCTApiGetFeedbackTagsTypeInform ? @"/index/report/getReportTags" : @"/index/user/getFeedBackTags";
}

- (Class)dataModelClass{
    return [YCTFeedBackTagsModel class];
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
@end
