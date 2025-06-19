//
//  YCTApiSearchAllCate.m
//  YCT
//
//  Created by 张大爷的 on 2022/10/10.
//

#import "YCTApiSearchAllCate.h"
#import "YCTSearchCateModel.h"
@implementation YCTApiSearchAllCate
- (NSString *)requestUrl {
    return @"/index/home/getAllGoodsType";
}

- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}

@end
