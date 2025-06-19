//
//  YCTApiLoginBySms.m
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTApiLoginBySms.h"

@implementation YCTApiLoginBySms {
    NSString * _mobile;
    NSString * _smsCode;
    NSString * _phoneAreaNo;
}

- (instancetype)initWithMobile:(NSString *)mobile smsCode:(NSString *)smsCode phoneAreaNo:(NSString *)phoneAreaNo {
    self = [super init];
    if (self) {
        _mobile = mobile;
        _smsCode = smsCode;
        _phoneAreaNo = phoneAreaNo;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/index/login/loginBySms";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (Class)dataModelClass {
    return [YCTLoginModel class];
}

- (NSDictionary *)yct_requestArgument{
    return @{
        @"mobile": _mobile ?: @"",
        @"smsCode": _smsCode ?: @"",
        @"phoneAreaNo": _phoneAreaNo ?: @"",
    };
}

@end
