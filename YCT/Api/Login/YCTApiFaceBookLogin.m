//
//  YCTApiFaceBookLogin.m
//  YCT
//
//  Created by 张大爷的 on 2023/4/7.
//

#import "YCTApiFaceBookLogin.h"
@implementation YCTApiFaceBookLoginBinding

- (NSString *)requestUrl {
    return @"/index/login/bindFaceBook";
}

- (Class)dataModelClass {
    return YCTOpenAuthLoginModel.class;
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:self.mobile forKey:@"mobile"];
    [argument setValue:self.smsCode forKey:@"smsCode"];
    [argument setValue:self.fbId forKey:@"fbId"];
    return argument.copy;
}

@end
@implementation YCTApiFaceBookLogin
- (NSString *)requestUrl {
    return @"/index/login/faceBookLogin";
}

- (Class)dataModelClass {
    return YCTFaceBookLoginModel.class;
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:self.code forKey:@"code"];
    return argument.copy;
}
@end
