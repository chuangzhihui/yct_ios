//
//  YCTApiPrivacy.h
//  YCT
//
//  Created by 木木木 on 2022/1/10.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YCTPrivacyStatus) {
    YCTPrivacyStatusAll = 1,/// 全部人
    YCTPrivacyStatusCorrelation = 2,/// 互关
    YCTPrivacyStatusNone = 3,/// 仅自己或者都不可以
};

typedef NS_ENUM(NSUInteger, YCTPrivacyOperation) {
    YCTPrivacyOperationHomepageLikes,/// 设置主页喜欢列表
    YCTPrivacyOperationPrivateMsg,/// 设置谁可以私信我
    YCTPrivacyOperationFollowFans,/// 设置关注和粉丝列表
};

@interface YCTPrivacyModel : YCTBaseModel

/// 我的点赞列表 1所有人可见 2互关可见 3自己可见
@property (nonatomic, assign) YCTPrivacyStatus myZanList;
/// 私信设置 1所有人 2互关好友 3都不可以私信
@property (nonatomic, assign) YCTPrivacyStatus chatType;
/// 我的粉丝和关注列表 1所有人可见 2互关可见 3尽自己可见
@property (nonatomic, assign) YCTPrivacyStatus myFansList;

- (NSString *)myZanListStatus;

- (NSString *)chatTypeStatus;

- (NSString *)myFansListStatus;

@end

@interface YCTApiPrivacy : YCTBaseRequest

- (instancetype)initWithOperation:(YCTPrivacyOperation)operation status:(YCTPrivacyStatus)status;

@end

NS_ASSUME_NONNULL_END
