//
//  YCTApiWeChatUserinfo.m
//  YCT
//
//  Created by 木木木 on 2022/1/24.
//

#import "YCTApiWeChatUserinfo.h"

@implementation YCTWeChatUserinfoModel
@end

@implementation YCTApiWeChatUserinfo {
    NSString *_accessToken;
    NSString *_openId;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken
                             openId:(NSString *)openId
{
    self = [super init];
    if (self) {
        _accessToken = accessToken;
        _openId = openId;
    }
    return self;
}

- (id)requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:_accessToken forKey:@"access_token"];
    [argument setValue:_openId forKey:@"openid"];
    return argument.copy;
}

- (NSString *)requestUrl {
    return @"/sns/userinfo";
}

- (Class)dataModelClass {
    return YCTWeChatUserinfoModel.class;
}

@end
