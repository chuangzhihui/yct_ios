//
//  YCTApiGetHotTopTag.m
//  YCT
//
//  Created by hua-cloud on 2022/1/14.
//

#import "YCTApiGetHotTopTag.h"

@implementation YCTApiGetHotTopTag

- (NSString *)requestUrl {
    return @"/index/home/getHotTopTag";
}

- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}

@end
