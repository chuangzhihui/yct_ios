//
//  YCTApiForgetPassword.h
//  YCT
//
//  Created by hua-cloud on 2022/3/18.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiForgetPassword : YCTBaseRequest
- (instancetype)initWithMobile:(NSString *)mobile
                       smsCode:(NSString *)smsCode
                   phoneAreaNo:(NSString *)phoneAreaNo
                      password:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
