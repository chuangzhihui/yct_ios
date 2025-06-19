//
//  YCTUserDataManager+Update.m
//  YCT
//
//  Created by 木木木 on 2021/12/30.
//

#import "YCTUserDataManager+Update.h"
#import "TUIDefine.h"

@interface YCTUserDataManager ()
@property (nonatomic, strong, readwrite) YCTMineUserInfoModel *userInfoModel;
- (void)updateInfoModel;
@end

@implementation YCTUserDataManager (Update)

- (void)updateAvatar:(NSString *)avatar {
    self.userInfoModel.avatar = avatar;
    [self updateInfoModel];
    
    V2TIMUserFullInfo *info = [[V2TIMUserFullInfo alloc] init];
    info.faceURL = avatar;
    [[V2TIMManager sharedInstance] setSelfInfo:info succ:^{
        NSLog(@"?");
    } fail:^(int code, NSString *desc) {
        NSLog(@"?");
    }];
}

- (void)updateUserBgImage:(NSString *)userBgImage {
    self.userInfoModel.userBg = userBgImage;
    [self updateInfoModel];
}

- (void)updateUserId:(NSString *)userId {
    self.userInfoModel.userTag = userId;
    [self updateInfoModel];
}

- (void)updateNickName:(NSString *)nickName {
    self.userInfoModel.nickName = nickName;
    [self updateInfoModel];
    
    V2TIMUserFullInfo *info = [[V2TIMUserFullInfo alloc] init];
    info.nickName = nickName;
    [[V2TIMManager sharedInstance] setSelfInfo:info succ:^{
        NSLog(@"?");
    } fail:^(int code, NSString *desc) {
        NSLog(@"?");
    }];
}

- (void)updateBriefIntro:(NSString *)briefIntro {
    self.userInfoModel.introduce = briefIntro;
    [self updateInfoModel];
}

- (void)updateUserTags:(NSArray<NSString *> *)userTags {
    self.userInfoModel.userTags = [userTags componentsJoinedByString:@","];
    [self updateInfoModel];
}

- (void)updateBanners:(NSArray<YCTUserBannerItemModel *> *)banners {
    self.userInfoModel.banners = [banners sortedArrayUsingComparator:^NSComparisonResult(YCTUserBannerItemModel * _Nonnull obj1, YCTUserBannerItemModel * _Nonnull obj2) {
        return obj1.sort < obj2.sort ? NSOrderedAscending : NSOrderedDescending;
    }];
    [self updateInfoModel];
}

- (void)updateSex:(YCTMineUserSex)sex {
    self.userInfoModel.sex = sex;
    [self updateInfoModel];
}

- (void)updateBirthday:(NSString *)birthday {
    self.userInfoModel.birthday = birthday;
    [self updateInfoModel];
}

- (void)updateLocationStr:(NSString *)locationStr {
    self.userInfoModel.locationStr = locationStr;
    [self updateInfoModel];
}

- (void)updateMainProduct:(NSString *)mainProduct {
    self.userInfoModel.direction = mainProduct;
    [self updateInfoModel];
}

- (void)updateCompanyContact:(NSString *)companyContact {
    self.userInfoModel.companyContact = companyContact;
    [self updateInfoModel];
}

- (void)updateCompanyPhone:(NSString *)companyPhone {
    self.userInfoModel.companyPhone = companyPhone;
    [self updateInfoModel];
}

- (void)updateCompanyEmail:(NSString *)companyEmail {
    self.userInfoModel.companyEmail = companyEmail;
    [self updateInfoModel];
}

@end
