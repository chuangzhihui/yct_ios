//
//  YCTApiGetVideoInfo.m
//  YCT
//
//  Created by hua-cloud on 2022/1/21.
//

#import "YCTApiGetVideoInfo.h"
#import "YCTPublishVideoModel.h"

@implementation YCTApiGetVideoInfo{
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
    return @"/index/video/getVideoInfo";
 }

 - (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
 }

- (Class)dataModelClass{
    return [YCTPublishVideoModel class];
}

 - (NSDictionary *)yct_requestArgument {
    return @{
        @"id": @(_id),
    };
 }

@end
