//
//  YCTApiGetVideoUploadToken.m
//  YCT
//
//  Created by hua-cloud on 2022/1/7.
//

#import "YCTApiGetVideoUploadToken.h"

@implementation YCTApiGetVideoUploadToken

- (NSString *)requestUrl {
   return @"/index/video/getVideoUploadToken";
}

- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}

@end
