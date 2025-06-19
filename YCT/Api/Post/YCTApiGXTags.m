//
//  YCTApiGXTags.m
//  YCT
//
//  Created by 木木木 on 2021/12/27.
//

#import "YCTApiGXTags.h"

@implementation YCTApiGXTags {
    YCTPostType _type;
}

- (instancetype)initWithType:(YCTPostType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/index/report/getGXTags";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (Class)dataModelClass {
    return YCTGXTag.class;
}

- (NSDictionary *)yct_requestArgument {
    return @{
        @"type": @(_type)
    };
}

@end
