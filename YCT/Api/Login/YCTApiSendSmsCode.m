//
//  YCTApiSendSmsCode.m
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTApiSendSmsCode.h"

@implementation YCTApiSendSmsCode{
    NSString * _mobile;
    NSString * _key;
    NSString * _phoneAeaNo;
}

- (instancetype)initWithMobile:(NSString *)mobile key:(NSString *)key phoneAeaNo:(NSString *)phoneAeaNo
{
    self = [super init];
    if (self) {
        _mobile = mobile;
        _key = key;
        _phoneAeaNo = phoneAeaNo;
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/index/login/sendSmsCode";
}

- (NSDictionary *)yct_requestArgument{
    return @{
        @"mobile":_mobile ?: @"",
        @"key":_key ?: @"",
        @"no": _phoneAeaNo ?: @"",
    };
}

@end

@implementation YCTApiSendSmsCodeForChangePhone

- (NSString *)requestUrl{
    return @"/index/user/sendSmsCodeForChangePhone";
}

@end
