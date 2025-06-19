//
//  YCTApiWeChatUserinfo.h
//  YCT
//
//  Created by 木木木 on 2022/1/24.
//

#import "YCTWeChatBaseRequest.h"
#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTWeChatUserinfoModel : YCTBaseModel
@property (nonatomic, copy) NSString * openid;
/// 普通用户的标识，对当前开发者帐号唯一
@property (nonatomic, copy) NSString * nickname;
/// 普通用户昵称
@property (nonatomic, assign) int sex;
/// 普通用户性别，1 为男性，2 为女性
@property (nonatomic, copy) NSString * province;
/// 普通用户个人资料填写的省份
@property (nonatomic, copy) NSString * city;
/// 普通用户个人资料填写的城市
@property (nonatomic, copy) NSString * country;
/// 国家，如中国为 CN
@property (nonatomic, copy) NSString * headimgurl;
/// 用户头像，最后一个数值代表正方形头像大小（有 0、46、64、96、132 数值可选，0 代表 640*640 正方形头像），用户没有头像时该项为空
@property (nonatomic, copy) NSString * unionid;
/// 用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的 unionid 是唯一的。
@end

@interface YCTApiWeChatUserinfo : YCTWeChatBaseRequest

- (instancetype)initWithAccessToken:(NSString *)accessToken
                             openId:(NSString *)openId;

@end

NS_ASSUME_NONNULL_END
