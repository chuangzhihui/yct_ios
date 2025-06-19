//
//  YCTApiCollectionVideo.m
//  YCT
//
//  Created by hua-cloud on 2022/1/10.
//

#import "YCTApiCollectionVideo.h"

@implementation YCTApiCollectionVideo{
    NSString * _videoId;
}

- (instancetype)initWithVideoId:(NSString *)videoId{
    self = [super init];
    if (self) {
        _videoId = videoId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"index/video/collectionVideo";
}

- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}

- (NSDictionary *)yct_requestArgument {
    return @{
        @"id": _videoId,
    };
}
@end
