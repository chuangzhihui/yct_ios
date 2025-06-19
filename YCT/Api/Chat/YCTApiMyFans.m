//
//  YCTApiMyFans.m
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import "YCTApiMyFans.h"

@implementation YCTApiMyFans

- (Class)dataModelClass {
    return YCTCommonUserModel.class;
}

- (NSString *)requestUrl {
    return @"/index/msg/myFansList";
}

@end
