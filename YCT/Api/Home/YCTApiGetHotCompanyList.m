//
//  YCTApiGetHotCompanyList.m
//  YCT
//
//  Created by hua-cloud on 2022/1/14.
//

#import "YCTApiGetHotCompanyList.h"
#import "YCTSearchUserModel.h"
@implementation YCTApiGetHotCompanyList
- (NSString *)requestUrl {
    return @"/index/home/getHotCompanyList";
}

- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}

- (Class)dataModelClass{
    return [YCTSearchUserModel class];
}
@end
