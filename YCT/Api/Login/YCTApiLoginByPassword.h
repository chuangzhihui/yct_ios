//
//  YCTApiLoginByPassword.h
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiLoginByPassword : YCTBaseRequest
/// 密码登录
/// @param mobile 手机号
/// @param password 密码登录
- (instancetype)initWithMobile:(NSString *)mobile password:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
