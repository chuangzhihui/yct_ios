//
//  YCTApiWeChatAccessToken.h
//  YCT
//
//  Created by 木木木 on 2022/1/24.
//

#import "YCTWeChatBaseRequest.h"
#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTWeChatAccessTokenModel : YCTBaseModel
@property (nonatomic, copy) NSString * access_token;
@property (nonatomic, assign) int expires_in;
@property (nonatomic, copy) NSString * refresh_token;
@property (nonatomic, copy) NSString * openid;
@property (nonatomic, copy) NSString * scope;
@property (nonatomic, copy) NSString * unionid;
@end

@interface YCTApiWeChatAccessToken : YCTWeChatBaseRequest

- (instancetype)initWithAppId:(NSString *)appId
                       secret:(NSString *)secret
                         code:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
