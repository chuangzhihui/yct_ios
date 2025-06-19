//
//  YCTApiForgetPassword.m
//  YCT
//
//  Created by hua-cloud on 2022/3/18.
//

#import "YCTApiForgetPassword.h"

@implementation YCTApiForgetPassword{
    NSString * _mobile;
    NSString * _smsCode;
    NSString * _phoneAreaNo;
    NSString * _password;
}

- (instancetype)initWithMobile:(NSString *)mobile
                       smsCode:(NSString *)smsCode
                   phoneAreaNo:(NSString *)phoneAreaNo
                      password:(NSString *)password{
    self = [super init];
    if (self) {
        _mobile = mobile;
        _smsCode = smsCode;
        _phoneAreaNo = phoneAreaNo;
        _password = password;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"index/login/forgetPassword";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSDictionary *)yct_requestArgument{
    return @{
        @"mobile": _mobile ?: @"",
        @"smsCode": _smsCode ?: @"",
        @"phoneAreaNo": _phoneAreaNo ?: @"",
        @"password": _password ?:@""
    };
}

@end
