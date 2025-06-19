//
//  YCTApiGetUploadToken.m
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTApiGetUploadToken.h"

@implementation YCTApiGetUploadToken

- (NSString *)requestUrl{
    return @"/index/login/getUploadToken";
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

@end
