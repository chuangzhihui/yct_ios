//
//  YCTApiGetHotList.m
//  YCT
//
//  Created by hua-cloud on 2022/1/13.
//

#import "YCTApiGetHotList.h"

@implementation YCTApiGetHotList

- (NSString *)requestUrl {
    return @"/index/home/getHotList";
}

- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}

- (Class)dataModelClass{
    return [YCTTagsModel class];
}
@end
