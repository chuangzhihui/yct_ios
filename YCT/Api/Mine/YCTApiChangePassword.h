//
//  YCTApiChangePassword.h
//  YCT
//
//  Created by 木木木 on 2022/1/7.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiChangePasswordSendSms : YCTBaseRequest

@end

@interface YCTApiChangePassword : YCTBaseRequest

- (instancetype)initWithPassword:(NSString *)password smsCode:(NSString *)smsCode;

@end

NS_ASSUME_NONNULL_END
