//
//  YCTNavigationCoordinator.m
//  YCT
//
//  Created by 木木木 on 2021/12/28.
//

#import "YCTNavigationCoordinator.h"
#import "YCTUserManager.h"
#import "YCTLoginViewController.h"
#import "UIWindow+Common.h"
#import "YCTUpgradeToVendorViewController.h"

#import "YCTBecomeCompanyViewController.h"
@implementation YCTNavigationCoordinator

+ (void)loginIfNeededWithAction:(void(^)(void))action {
    if ([YCTUserDataManager sharedInstance].isLogin) {
        !action ? : action();
    } else if (![[UIWindow yct_currentViewController] isKindOfClass:YCTLoginViewController.class]) {
        YCTLoginViewController *vc = [YCTLoginViewController new];
        [vc setLoginCompletiom:action];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [[UIWindow yct_currentViewController] presentViewController:nav animated:YES completion:nil];
    }
}

+ (void)login {
    YCTLoginViewController *vc = [YCTLoginViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [[UIWindow yct_currentViewController] presentViewController:nav animated:YES completion:nil];
}

+ (void)checkIfNeededCompleteVendorInfoWithNav:(UINavigationController *)nav
                                         index:(int) index
                                     user_type:(int) user_type
                                  alertContent:(NSString *)alertContent
                                        action:(void(^ _Nullable)(void))action 
                                        profileAction:(void(^ _Nullable)(void))moveToProfileAdd {
    if (!action) return;
    
    if (![YCTUserDataManager sharedInstance].isLogin) {
        [self login];
        return;
    }
   
    if(user_type==1)
    {
//        普通用户需去完善资料
        if ([YCTUserDataManager sharedInstance].userInfoModel.userType == YCTMineUserTypeNormal) {
    //        YCTUpgradeToVendorViewController *vc = [[YCTUpgradeToVendorViewController alloc] init];
            YCTBecomeCompanyViewController *vc = [[YCTBecomeCompanyViewController alloc] init];
            [nav pushViewController:vc animated:YES];
            if (moveToProfileAdd) {
                moveToProfileAdd();
            }
            return;
        }
    }
    /// 未审核成功
    if ([YCTUserDataManager sharedInstance].userInfoModel.status != 1) {
        [[YCTHud sharedInstance] showDetailToastHud:alertContent];
        return;
    }
    [YCTUserDataManager sharedInstance].user_type=user_type;
    action();
}


+ (BOOL)checkIfMoveToUserProfileWithNav:(UINavigationController *)nav
                                  alertContent:(NSString *)alertContent {
   
    /// 普通用户需去完善资料
    if ([YCTUserDataManager sharedInstance].userInfoModel.userType == YCTMineUserTypeNormal) {
//        YCTUpgradeToVendorViewController *vc = [[YCTUpgradeToVendorViewController alloc] init];
        YCTBecomeCompanyViewController *vc = [[YCTBecomeCompanyViewController alloc] init];
        [nav pushViewController:vc animated:YES];
        return NO;
    }
    
    /// 未审核成功
    if ([YCTUserDataManager sharedInstance].userInfoModel.status != 1) {
        [[YCTHud sharedInstance] showDetailToastHud:alertContent];
        return NO;
    }
    return YES;
}

@end
