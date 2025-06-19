//
//  YCTApiHomeVideoList.m
//  YCT
//
//  Created by hua-cloud on 2021/12/28.
//

#import "YCTApiHomeVideoList.h"
#import "YCTVideoModel.h"
@implementation YCTApiHomeVideoList {
    NSInteger _page;
    NSInteger _size;
    NSInteger  _user_type;
    NSString * _ids;
    YCTApiHomeVideoType _type;
}

- (instancetype)initWithPage:(NSInteger)page type:(YCTApiHomeVideoType)type ids:(NSString *)ids user_type:(NSInteger )user_type{
    self = [super init];
    if (self) {
        _page = page;
        if (page == 0) {
            _page = 1;
        }
//        if (type == YCTApiHomeVideoTypeRecommand) {
            _size = 10;
//        } else {
//            _size = 20;
//        }
        _type = type;
        _user_type=user_type;
        _ids = ids;
    }
    return self;
}

- (NSString *)requestUrl {
    return _type == YCTApiHomeVideoTypeRecommand ? @"/index/home/videoList" : @"/index/home/getFllowVideoList";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (Class)dataModelClass {
    if ([self.requestUrl isEqualToString:@"/index/home/videoList"]) {
        return YCTVideoDataModel.class;
    }
    return YCTVideoModel.class;
}

- (NSDictionary *)yct_requestArgument {
    return @{
        @"page": @(_page),
        @"size": @(_size),
        @"user_type":@(_user_type),
        @"ids":_ids,
    };
}

@end
