//
//  YCTApiWeChatAccessToken.m
//  YCT
//
//  Created by 木木木 on 2022/1/24.
//

#import "YCTApiWeChatAccessToken.h"

@implementation YCTWeChatAccessTokenModel
@end

@implementation YCTApiWeChatAccessToken {
    NSString *_appid;
    NSString *_secret;
    NSString *_code;
    NSString *_grantType;
}

- (instancetype)initWithAppId:(NSString *)appId
                       secret:(NSString *)secret
                         code:(NSString *)code
{
    self = [super init];
    if (self) {
        _appid = appId;
        _secret = secret;
        _code = code;
        _grantType = @"authorization_code";
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/sns/oauth2/access_token";
}

- (id)requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:_appid forKey:@"appid"];
    [argument setValue:_secret forKey:@"secret"];
    [argument setValue:_code forKey:@"code"];
    [argument setValue:_grantType forKey:@"grant_type"];
    return argument.copy;
}

- (Class)dataModelClass {
    return YCTWeChatAccessTokenModel.class;
}

@end
