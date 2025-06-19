//
//  YCTApiChangePhoneNumber.h
//  YCT
//
//  Created by 木木木 on 2022/3/17.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiChangePhoneNumber : YCTBaseRequest
/// 原手机获取的验证码
@property (nonatomic, copy) NSString *originalSmsCode;
/// 新手机号码
@property (nonatomic, copy) NSString *mobile;
/// 新手机号码接收到的验证码
@property (nonatomic, copy) NSString *smsCode;
@end

NS_ASSUME_NONNULL_END
