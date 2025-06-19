//
//  YCTCommonUserModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/10.
//

#import "YCTBaseModel.h"
#import "YCTUserFollowHelper.h"
#import "YCTSharedDataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTCommonUserModel : YCTBaseModel<YCTUserFollowProtocol, YCTSharedDataProtocol>
/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// 用户ID
@property (nonatomic, copy) NSString *userTag;
/// 昵称
@property (nonatomic, copy) NSString *nickName;
/// 头像
@property (nonatomic, copy) NSString *avatar;
/// 用户类型
@property (nonatomic, assign) YCTMineUserType userType;
/// 是否互相关注
@property (nonatomic, assign) BOOL isMutual;
/// 是否关注了对方
@property (nonatomic, assign) BOOL isFollow;
/// 简介
@property (nonatomic, copy) NSString *intro;
/// 是否认证
@property (nonatomic, assign) BOOL isauthentication;
@end

NS_ASSUME_NONNULL_END
