//
//  YCTApiFollowUser.m
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import "YCTApiFollowUser.h"

@implementation YCTApiFollowUser {
    YCTApiFollowUserType _type;
    NSString *_userId;
}

- (instancetype)initWithType:(YCTApiFollowUserType)type userId:(NSString *)userId {
    self = [super init];
    if (self) {
        _type = type;
        _userId = userId;
    }
    return self;
}

- (NSString *)requestUrl {
    if (_type == YCTApiFollowUserTypeFollow) {
        return @"/index/msg/fllow";
    } else {
        return @"/index/msg/cancleFllow";
    }
}

- (NSDictionary *)yct_requestArgument {
    return @{
        @"userId": _userId ?: @"",
    };
}

@end
