//
//  YCTApiSetAvatar.h
//  YCT
//
//  Created by 木木木 on 2021/12/30.
//

#import "YCTBaseRequest.h"

typedef NS_ENUM(NSUInteger, YCTApiUpdateUserInfoType) {
    YCTApiUpdateUserInfoAvatar,
    YCTApiUpdateUserInfoSex,
    YCTApiUpdateUserInfoNickName,
    YCTApiUpdateUserInfoBirthday,
    YCTApiUpdateUserInfoID,
    YCTApiUpdateUserInfoBriefIntro,
    YCTApiUpdateUserInfoLocation,
    YCTApiUpdateUserInfoBackgroundImage,
    YCTApiUpdateUserInfoTags,
    YCTApiUpdateUserInfoMainProduct,
};

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiUpdateUserInfo : YCTBaseRequest

- (instancetype)initWithType:(YCTApiUpdateUserInfoType)type
                       value:(id)value;

@end

@interface YCTApiUpdateVendorInfo : YCTBaseRequest

/*
 userBg    是    string    背景图
 introduce    是    string    公司简介
 companyContact    是    string    联系人
 companyPhone    是    string    联系电话
 companyEmail    是    string    联系邮箱
 */
- (instancetype)initWithUserBg:(NSString *)userBg
                     introduce:(NSString *)introduce
                companyContact:(NSString *)companyContact
                  companyPhone:(NSString *)companyPhone
                  companyEmail:(NSString *)companyEmail;

@end

NS_ASSUME_NONNULL_END
