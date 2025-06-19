//
//  YCTApiSendSmsCode.h
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

//验证的key 注册:smscodereg 登录:smscodelogin 找回密码:smscodeforget
static NSString * const k_smscodereg = @"smscode_reg_";
static NSString * const k_smscodelogin = @"smscode_login_";
static NSString * const k_smscodeBindWx = @"smscode_bindwx_";
static NSString * const k_smscodeBindZl = @"smscode_bindzl_";

static NSString * const k_changephoneReg = @"changephone_reg_";// 修改手机号
static NSString * const k_passwordreg = @"password_reg_";// 忘记密码

@interface YCTApiSendSmsCode : YCTBaseRequest

/// 发送验证码
/// @param mobile 手机号
/// @param key 验证的key 注册:smscodereg 登录:smscodelogin
/// @param phoneAeaNo 手机号国籍区域号
- (instancetype)initWithMobile:(NSString *)mobile
                           key:(NSString *)key
                    phoneAeaNo:(NSString * _Nullable)phoneAeaNo;

@end

@interface YCTApiSendSmsCodeForChangePhone : YCTBaseRequest

@end

NS_ASSUME_NONNULL_END
