//
//  YCTApiFeedBack.m
//  YCT
//
//  Created by hua-cloud on 2022/1/22.
//

#import "YCTApiFeedBack.h"

@implementation YCTApiFeedBack{
    NSString * _typeIds;
    NSString * _content;
    NSString * _imgs;
}

- (instancetype)initWithTypeIds:(NSString *)typeIds
                       content:(NSString *)content
                           imgs:(NSString *)imgs{
    if (self = [super init]){
        _typeIds = typeIds;
        _content = content;
        _imgs = imgs;
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/index/user/feedBack";
}


- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSDictionary *)yct_requestArgument {
    return @{
        @"typeIds": _typeIds,
        @"content": _content,
        @"imgs" : _imgs
    };
}

@end
