//
//  YCTApiWeChatLogin.m
//  YCT
//
//  Created by 木木木 on 2022/1/20.
//

#import "YCTApiWeChatLogin.h"

@implementation YCTApiWeChatLoginBinding

- (NSString *)requestUrl {
    return @"/index/login/bindWX";
}

- (Class)dataModelClass {
    return YCTOpenAuthLoginModel.class;
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:self.mobile forKey:@"mobile"];
    [argument setValue:self.smsCode forKey:@"smsCode"];
    [argument setValue:self.unionId forKey:@"unionId"];
    [argument setValue:self.avatar forKey:@"avatar"];
    [argument setValue:self.nickName forKey:@"nickName"];
    [argument setValue:self.loginType forKey:@"loginType"];
    return argument.copy;
}

@end

@implementation YCTApiWeChatLogin

- (NSString *)requestUrl {
    return @"/index/login/wxAuthLogin";
}

- (Class)dataModelClass {
    return YCTWeChatLoginModel.class;
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:self.code forKey:@"code"];
    return argument.copy;
}

@end
