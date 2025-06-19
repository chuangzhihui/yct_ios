//
//  YCTApiChangePassword.m
//  YCT
//
//  Created by 木木木 on 2022/1/7.
//

#import "YCTApiChangePassword.h"

@implementation YCTApiChangePasswordSendSms

- (NSString *)requestUrl {
    return @"/index/user/sendSmsCodeForSetPwd";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

@end

@implementation YCTApiChangePassword {
    NSString *_password;
    NSString *_smsCode;
}

- (instancetype)initWithPassword:(NSString *)password smsCode:(NSString *)smsCode {
    self = [super init];
    if (self) {
        _password = password;
        _smsCode = smsCode;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/index/user/password";
}

- (NSDictionary *)yct_requestArgument {
    return @{@"password": _password?: @"",
             @"smsCode": _smsCode ?: @""};
}

@end
