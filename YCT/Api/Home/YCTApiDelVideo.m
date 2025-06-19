//
//  YCTApiDelVideo.m
//  YCT
//
//  Created by hua-cloud on 2022/1/18.
//

#import "YCTApiDelVideo.h"

@implementation YCTApiDelVideo{
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
    return @"/index/user/delVideo";
}

- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}

- (NSDictionary *)yct_requestArgument {
    return @{
        @"id": YCTString(_videoId, @""),
    };
}

@end
