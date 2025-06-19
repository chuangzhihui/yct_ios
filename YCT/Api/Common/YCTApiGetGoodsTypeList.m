//
//  YCTApiGetGoodsTypeList.m
//  YCT
//
//  Created by 木木木 on 2022/5/9.
//

#import "YCTApiGetGoodsTypeList.h"
#import "YCTMintGetLocationModel.h"

@implementation YCTApiGetGoodsTypeList {
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
    return @"/index/home/getGoodsTypeList";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (Class)dataModelClass {
    return YCTMintGetLocationModel.class;
}

- (NSDictionary *)yct_requestArgument {
    return @{
        @"id": (_pid ?: @"0")
    };
}

@end
