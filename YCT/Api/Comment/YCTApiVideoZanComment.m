//
//  YCTApiVideoZanComment.m
//  YCT
//
//  Created by hua-cloud on 2022/1/9.
//

#import "YCTApiVideoZanComment.h"

@implementation YCTApiVideoZanComment{
    NSString * _commentId;
}

- (instancetype)initWithCommentId:(NSString *)commentId{
    self = [super init];
    if (self) {
        _commentId = commentId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/index/video/zanComment";
}

- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}

- (NSDictionary *)yct_requestArgument {
    return @{
        @"commentId": _commentId,
    };
}

@end
