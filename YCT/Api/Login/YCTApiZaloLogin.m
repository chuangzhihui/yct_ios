//
//  YCTApiZaloLogin.m
//  YCT
//
//  Created by 木木木 on 2022/1/20.
//

#import "YCTApiZaloLogin.h"

@implementation YCTApiZaloLoginBinding

- (NSString *)requestUrl {
    return @"/index/login/bindZaLo";
}

- (Class)dataModelClass {
    return YCTOpenAuthLoginModel.class;
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:self.mobile forKey:@"mobile"];
    [argument setValue:self.smsCode forKey:@"smsCode"];
    [argument setValue:self.zlId forKey:@"zlId"];
    [argument setValue:self.type forKey:@"type"];
    
    [argument setValue:self.avatar forKey:@"avatar"];
    [argument setValue:self.nickName forKey:@"nickName"];
    return argument.copy;
}

@end

@implementation YCTApiZaloLogin

- (NSString *)requestUrl {
    return @"/index/login/zlLogin";
}

- (Class)dataModelClass {
    return YCTZaloLoginModel.class;
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:self.code forKey:@"code"];
    [argument setValue:self.type forKey:@"type"];
    return argument.copy;
}

@end
