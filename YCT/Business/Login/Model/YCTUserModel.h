//
//  YCTUserModel.h
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTLoginModel : YCTBaseModel
@property (nonatomic, copy) NSString * userSign;
@property (nonatomic, copy) NSString * IMName;
@property (nonatomic, readonly) NSString *userIdFromIMName;
@property (nonatomic, copy) NSString * token;
@end

@interface YCTWeChatLoginModel : YCTLoginModel
/// 是否需要绑定手机
@property (nonatomic, assign) BOOL needBind;
/// 需要绑定时返回 用户的微信unionId 绑定手机时候用
@property (nonatomic, copy) NSString *unionId;
@end

@interface YCTZaloLoginModel : YCTLoginModel
/// 是否需要绑定手机
@property (nonatomic, assign) BOOL needBind;
@end
@interface YCTFaceBookLoginModel : YCTLoginModel
/// 是否需要绑定手机
@property (nonatomic, assign) BOOL needBind;
@end
@interface YCTOpenAuthLoginModel : YCTLoginModel
/// 是否是登录过的账号
@property (nonatomic, assign) BOOL isReg;
@end

@interface YCTZaloUserModel : YCTBaseModel
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *avatarUrl;
@end

NS_ASSUME_NONNULL_END
