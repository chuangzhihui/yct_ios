//
//  YCTApiGetVideoTags.m
//  YCT
//
//  Created by hua-cloud on 2022/1/7.
//

#import "YCTApiGetVideoTags.h"

@implementation YCTApiGetVideoTags{
    NSString * _tagText;
 }

 - (instancetype)initWithTagText:(NSString *)tagText {
    self = [super init];
    if (self) {
        _tagText = tagText;
    }
    return self;
 }

 - (NSString *)requestUrl {
    return @"/index/video/getVideoTags";
 }

 - (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
 }


 - (NSDictionary *)yct_requestArgument {
    return @{
        @"tagText": _tagText,
    };
 }


@end
