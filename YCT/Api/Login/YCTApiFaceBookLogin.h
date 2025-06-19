//
//  YCTApiFaceBookLogin.h
//  YCT
//
//  Created by 张大爷的 on 2023/4/7.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiFaceBookLoginBinding : YCTBaseRequest
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, copy) NSString *fbId;
@property int type;
@end

@interface YCTApiFaceBookLogin : YCTBaseRequest
@property (nonatomic, copy) NSString *code;
@property int type;
@end

NS_ASSUME_NONNULL_END
