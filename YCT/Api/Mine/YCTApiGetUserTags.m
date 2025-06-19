//
//  YCTApiGetUserTags.m
//  YCT
//
//  Created by 木木木 on 2021/12/30.
//

#import "YCTApiGetUserTags.h"

@implementation YCTApiGetUserTags

- (NSString *)requestUrl {
    return @"/index/user/getUserTags";
}

- (Class)dataModelClass {
    return YCTUserTagModel.class;
}

@end
