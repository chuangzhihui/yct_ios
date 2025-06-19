//
//  ApiAiGetAiTags.m
//  YCT
//
//  Created by 林涛 on 2025/3/25.
//

#import "ApiAiGetAiTags.h"

@implementation ApiAiGetAiTags

//- (NSString *)baseUrl {
//    return @"https://ylhz.honghukeji.net:10443/";
//}

- (NSString *)requestUrl {
    return @"index/home/getAiTags";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (Class)dataModelClass {
    return AiTagsModel.class;
}

@end
