//
//  YCTApiPublishComment.m
//  YCT
//
//  Created by hua-cloud on 2022/1/8.
//

#import "YCTApiPublishComment.h"

@implementation YCTApiPublishComment{
    NSString * _videoId;
    NSString * _pid;
    NSString * _content;
}

- (instancetype)initWithVideoId:(NSString *)videoId pid:(NSString *)pid content:(NSString *)content{
    self = [super init];
    if (self) {
        _videoId = videoId;
        _content = content;
        _pid = pid;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/index/video/comment";
}

- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}

- (NSDictionary *)yct_requestArgument {
    return @{
        @"videoId": _videoId,
        @"content": _content,
        @"pid":_pid,
    };
}

@end
