//
//  YCTApiZaloLogin.h
//  YCT
//
//  Created by 木木木 on 2022/1/20.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiZaloLoginBinding : YCTBaseRequest
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, copy) NSString *zlId;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString * type;//1zalo  2fb 3gg 4apple
@property (nonatomic, copy) NSString *nickName;
@end

@interface YCTApiZaloLogin : YCTBaseRequest
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString * type;//1zalo  2fb 3gg 4apple
@end

NS_ASSUME_NONNULL_END
