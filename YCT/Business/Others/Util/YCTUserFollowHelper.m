//
//  YCTUserFollowHelper.m
//  YCT
//
//  Created by 木木木 on 2022/1/13.
//

#import "YCTUserFollowHelper.h"
#import "YCTApiFollowUser.h"
#import "YCTSharedDataManager.h"

@implementation YCTUserFollowHelper

YCT_SINGLETON_IMP

- (void)handleFollowStateWithUser:(id<YCTUserFollowProtocol>)user {
    [[YCTHud sharedInstance] showLoadingHud];
    YCTApiFollowUser *apiFollowUser = [[YCTApiFollowUser alloc] initWithType:(user.isFollow ? YCTApiFollowUserTypeCancel : YCTApiFollowUserTypeFollow) userId:user.userId];
    [apiFollowUser startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        if ([user conformsToProtocol:@protocol(YCTSharedDataProtocol)]) {
            id<YCTSharedDataProtocol> cuser = (id<YCTSharedDataProtocol>)user;
            [[YCTSharedDataManager sharedInstance] sendValue:@(!user.isFollow) keyPath:NSStringFromSelector(@selector(isFollow)) type:cuser.dataType id:cuser.id];
        } else {
            user.isFollow = !user.isFollow;
        }
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (void)handleMutualStateWithUser:(id<YCTUserMutualProtocol>)user {
    [[YCTHud sharedInstance] showLoadingHud];
    YCTApiFollowUser *apiFollowUser = [[YCTApiFollowUser alloc] initWithType:(user.isMutual ? YCTApiFollowUserTypeCancel : YCTApiFollowUserTypeFollow) userId:user.userId];
    [apiFollowUser startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        if ([user conformsToProtocol:@protocol(YCTSharedDataProtocol)]) {
            id<YCTSharedDataProtocol> cuser = (id<YCTSharedDataProtocol>)user;
            [[YCTSharedDataManager sharedInstance] sendValue:@(!user.isMutual) keyPath:NSStringFromSelector(@selector(isMutual)) type:cuser.dataType id:cuser.id];
        } else {
            user.isMutual = !user.isMutual;
        }
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

@end
