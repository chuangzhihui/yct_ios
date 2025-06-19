//
//  YCTApiSetAvatar.m
//  YCT
//
//  Created by 木木木 on 2021/12/30.
//

#import "YCTApiUpdateUserInfo.h"

@implementation YCTApiUpdateUserInfo {
    id _newValue;
    YCTApiUpdateUserInfoType _type;
}

- (instancetype)initWithType:(YCTApiUpdateUserInfoType)type
                       value:(id)value {
    self = [super init];
    if (self) {
        _type = type;
        _newValue = value;
    }
    return self;
}

- (NSString *)requestUrl {
    switch (_type) {
        case YCTApiUpdateUserInfoAvatar:
            return @"/index/user/setAvatar";
            break;
        case YCTApiUpdateUserInfoSex:
            return @"/index/user/setSex";
            break;
        case YCTApiUpdateUserInfoNickName:
            return @"/index/user/setNickName";
            break;
        case YCTApiUpdateUserInfoBirthday:
            return @"/index/user/setBirthday";
            break;
        case YCTApiUpdateUserInfoID:
            return @"/index/user/setUUID";
            break;
        case YCTApiUpdateUserInfoBriefIntro:
            return @"/index/user/setIntroduce";
            break;
        case YCTApiUpdateUserInfoLocation:
            return @"/index/user/setLocation";
            break;
        case YCTApiUpdateUserInfoBackgroundImage:
            return @"/index/user/setUserBg";
            break;
        case YCTApiUpdateUserInfoTags:
            return @"/index/user/setUsetTags";
        case YCTApiUpdateUserInfoMainProduct:
            return @"/index/user/setDirection";
            break;
    }
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:_newValue forKey:[self requestKey]];
    return argument.copy;
}

- (NSString *)requestKey {
    switch (_type) {
        case YCTApiUpdateUserInfoAvatar:
            return @"avatar";
            break;
        case YCTApiUpdateUserInfoSex:
            return @"sex";
            break;
        case YCTApiUpdateUserInfoNickName:
            return @"nickName";
            break;
        case YCTApiUpdateUserInfoBirthday:
            return @"birthday";
            break;
        case YCTApiUpdateUserInfoID:
            return @"userTag";
            break;
        case YCTApiUpdateUserInfoBriefIntro:
            return @"introduce";
            break;
        case YCTApiUpdateUserInfoLocation:
            return @"locationId";
            break;
        case YCTApiUpdateUserInfoBackgroundImage:
            return @"userBg";
            break;
        case YCTApiUpdateUserInfoTags:
            return @"tagsText";
        case YCTApiUpdateUserInfoMainProduct:
            return @"direction";
            break;
    }
}

@end

@implementation YCTApiUpdateVendorInfo {
    NSString *_userBg;
    NSString *_introduce;
    NSString *_companyContact;
    NSString *_companyPhone;
    NSString *_companyEmail;
}

- (instancetype)initWithUserBg:(NSString *)userBg
                     introduce:(NSString *)introduce
                companyContact:(NSString *)companyContact
                  companyPhone:(NSString *)companyPhone
                  companyEmail:(NSString *)companyEmail {
    self = [super init];
    if (self) {
        _userBg = userBg;
        _introduce = introduce;
        _companyContact = companyContact;
        _companyPhone = companyPhone;
        _companyEmail = companyEmail;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/index/user/changeFactoryInfo";
}

- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:_userBg forKey:@"userBg"];
    [argument setValue:_introduce forKey:@"introduce"];
    [argument setValue:_companyContact forKey:@"companyContact"];
    [argument setValue:_companyPhone forKey:@"companyPhone"];
    [argument setValue:_companyEmail forKey:@"companyEmail"];
    return argument.copy;
}

@end
