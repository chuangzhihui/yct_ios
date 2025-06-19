//
//  YCTApiCateSearch.m
//  YCT
//
//  Created by 张大爷的 on 2022/10/10.
//

#import "YCTApiCateSearch.h"

@implementation YCTApiCateSearch
- (NSString *)requestUrl {
    return @"/index/home/getFirstGoodsType";
}

- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}

@end
