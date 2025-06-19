//
//  YCTApiLoginByPassword.m
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTApiLoginByPassword.h"

@implementation YCTApiLoginByPassword{
    NSString * _mobile;
    NSString * _password;
}

- (instancetype)initWithMobile:(NSString *)mobile password:(NSString *)password {
    self = [super init];
    if (self) {
        _mobile = mobile;
        _password = password;
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/index/login/loginByPassword";
}

- (Class)dataModelClass{
    return [YCTLoginModel class];
}

- (NSDictionary *)yct_requestArgument{
    return @{
        @"mobile":_mobile,
        @"password":_password
    };
}

@end
