//
//  YCTApiVideoDetailById.m
//  YCT
//
//  Created by 木木木 on 2022/7/22.
//

#import "YCTApiVideoDetailById.h"

@implementation YCTApiVideoDetailById {
    NSString * _videoId;
}

- (instancetype)initWithVideoId:(NSString *)videoId {
    self = [super init];
    if (self) {
        _videoId = videoId;
    }
    return self;
}

- (NSDictionary *)yct_requestArgument {
    return @{@"id": _videoId?:@""};
}

- (NSString *)requestUrl {
    return @"index/home/getVideoDetailById";
}

- (Class)dataModelClass {
    return YCTVideoModel.class;
}

@end
