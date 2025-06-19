//
//  YCTApiGetLocation.m
//  YCT
//
//  Created by 木木木 on 2021/12/26.
//

#import "YCTApiGetLocation.h"
#import "YCTMintGetLocationModel.h"

@implementation YCTApiGetLocation {
    NSString * _pid;
}

- (instancetype)initWithPid:(NSString *)pid {
    self = [super init];
    if (self) {
        _pid = pid;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/index/login/getLocation";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (Class)dataModelClass {
    return YCTMintGetLocationModel.class;
}

- (NSDictionary *)yct_requestArgument {
    return @{
        @"pid": (_pid ?: @"0")
    };
}

@end
