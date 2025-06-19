//
//  YCTApiWeChatLogin.h
//  YCT
//
//  Created by 木木木 on 2022/1/20.
//

#import "YCTBaseRequest.h"
#import "YCTUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiWeChatLoginBinding : YCTBaseRequest
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, copy) NSString *unionId;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *loginType;
@end

@interface YCTApiWeChatLogin : YCTBaseRequest
@property (nonatomic, copy) NSString *code;


@end

NS_ASSUME_NONNULL_END
