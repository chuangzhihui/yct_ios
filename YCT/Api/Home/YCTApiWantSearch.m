//
//  YCTApiWantSearch.m
//  YCT
//
//  Created by hua-cloud on 2022/1/25.
//

#import "YCTApiWantSearch.h"

@implementation YCTApiWantSearch


- (NSString *)requestUrl {
    return @"/index/home/wantSearch";
}

- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}

@end
