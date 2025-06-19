//
//  YCTApiMineUserInfo.m
//  YCT
//
//  Created by 木木木 on 2021/12/30.
//

#import "YCTApiMineUserInfo.h"

@implementation YCTApiMineUserInfo

- (NSString *)requestUrl {
    return @"/index/user/userInfo";
}

- (Class)dataModelClass {
    return YCTMineUserInfoModel.class;
}

@end
