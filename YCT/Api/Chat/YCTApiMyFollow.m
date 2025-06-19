//
//  YCTApiMyFollow.m
//  YCT
//
//  Created by 木木木 on 2022/1/16.
//

#import "YCTApiMyFollow.h"

@implementation YCTApiMyFollow

- (Class)dataModelClass {
    return YCTCommonUserModel.class;
}

- (NSString *)requestUrl {
    return @"/index/user/getMyFllowList";
}

@end
