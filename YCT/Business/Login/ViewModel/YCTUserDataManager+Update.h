//
//  YCTUserDataManager+Update.h
//  YCT
//
//  Created by 木木木 on 2021/12/30.
//

#import "YCTUserManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTUserDataManager (Update)

- (void)updateAvatar:(NSString *)avatar;

- (void)updateUserBgImage:(NSString *)userBgImage;

- (void)updateUserId:(NSString *)userId;

- (void)updateNickName:(NSString *)nickName;

- (void)updateBriefIntro:(NSString *)briefIntro;

- (void)updateUserTags:(NSArray<NSString *> *)userTags;

- (void)updateBanners:(NSArray<YCTUserBannerItemModel *> *)banners;

- (void)updateSex:(YCTMineUserSex)sex;

- (void)updateBirthday:(NSString *)birthday;

- (void)updateLocationStr:(NSString *)locationStr;

- (void)updateMainProduct:(NSString *)mainProduct;

- (void)updateCompanyContact:(NSString *)companyContact;

- (void)updateCompanyPhone:(NSString *)companyPhone;

- (void)updateCompanyEmail:(NSString *)companyEmail;


@end

NS_ASSUME_NONNULL_END
