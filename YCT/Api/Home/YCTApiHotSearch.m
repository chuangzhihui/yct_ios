//
//  YCTApiHotSearch.m
//  YCT
//
//  Created by 张大爷的 on 2022/7/7.
//

#import "YCTApiHotSearch.h"

@implementation YCTApiHotSearch
- (NSString *)requestUrl {
    return @"/index/home/getHotList";
}

- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}

@end
