//
//  YCTApiLoginBySms.h
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTBaseRequest.h"
#import "YCTUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCTApiLoginBySms : YCTBaseRequest

- (instancetype)initWithMobile:(NSString *)mobile smsCode:(NSString *)smsCode phoneAreaNo:(NSString *)phoneAreaNo;

@end

NS_ASSUME_NONNULL_END
