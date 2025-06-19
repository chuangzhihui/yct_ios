//
//  YCTUserManager.h
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import <Foundation/Foundation.h>
#import "YCTUserModel.h"
#import "YCTMineUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTUserDataManager : NSObject

YCT_SINGLETON_DEF

@property (nonatomic, strong, readonly) YCTMineUserInfoModel *userInfoModel;
@property (nonatomic, strong, readonly) YCTLoginModel *loginModel;
@property (nonatomic, readonly) BOOL isLogin;
@property (nonatomic, copy) NSString * locationId;
@property (nonatomic, copy) NSString * locationCity;
@property int user_type;
@end

@interface YCTUserManager : NSObject

YCT_SINGLETON_DEF

/// 如果当前用户已经登录，启动app时自动获取用户信息
- (void)autoLoginFetchUserInfo;

/// 存储loginModel
/// @param loginModel 用户登录信息
- (void)loginWithModel:(YCTLoginModel *)loginModel;

/// 退出登录
- (void)logout;

/// 更新用户信息
- (void)updateUserInfo; 
@end

NS_ASSUME_NONNULL_END
