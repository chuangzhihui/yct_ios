//
//  YCTApiApplyVideo.m
//  YCT
//
//  Created by hua-cloud on 2022/1/21.
//

#import "YCTApiApplyVideo.h"

@implementation YCTApiApplyVideo{
    NSInteger _id;
 }

 - (instancetype)initWithVideoId:(NSInteger)videoId {
    self = [super init];
    if (self) {
        _id = videoId;
    }
    return self;
 }

 - (NSString *)requestUrl {
    return @"/index/video/applyVideo";
 }

 - (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
 }


 - (NSDictionary *)yct_requestArgument {
    return @{
        @"id": @(_id),
    };
 }


@end
