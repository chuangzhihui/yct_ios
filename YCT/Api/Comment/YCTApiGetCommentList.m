//
//  YCTApiGetCommentList.m
//  YCT
//
//  Created by hua-cloud on 2022/1/8.
//

#import "YCTApiGetCommentList.h"

typedef NS_ENUM(NSInteger, YCTApiGetCommentListType) {
    YCTApiGetCommentListTypeFirst,
    YCTApiGetCommentListTypeSecond,
};

@implementation YCTApiGetCommentList{
    ///一级
    NSInteger _page;
    NSInteger _size;
    NSString * _videoId;
    
    ///二级
    NSString * _pid;
    
    YCTApiGetCommentListType _type;
 }

- (instancetype)initWithPage:(NSInteger)page videoId:(NSString *)videoId{
    self = [super init];
    if (self) {
        _page = page;
        _size = 99999;
        _videoId = videoId;
        _type = YCTApiGetCommentListTypeFirst;
    }
    return self;
    
}

- (instancetype)initSecondWithPid:(NSString *)pid{
    self = [super init];
    if (self) {
        _pid = pid;
        _type = YCTApiGetCommentListTypeSecond;
    }
    return self;
}

- (NSString *)requestUrl {
    if (_type == YCTApiGetCommentListTypeFirst) {
        return @"/index/home/getFirstCommentList";
    }else{
        return @"/index/home/getCommentList";
    }
   
}

- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}

- (Class)dataModelClass {
   return YCTCommentModel.class;
}

- (NSDictionary *)yct_requestArgument {
    if (_type == YCTApiGetCommentListTypeFirst) {
        return @{
            @"page": @(_page),
            @"size": @(_size),
            @"videoId":_videoId,
        };
    }else{
        return @{
            @"pid":_pid
        };
    }
}

@end
