//
//  YCTApiUserReg.m
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTApiUserReg.h"

@implementation YCTApiUserReg{
    NSString * _mobile;
    NSString * _phoneAreaNo;
    NSString * _code;
    NSString * _userType;
    NSString * _companyName;
    NSString * _companyAddress;
    NSString * _companyWebSite;
    NSString * _companyEmail;
    NSString * _companyContact;
    NSString * _companyPhone;
    NSString * _businessLicense;
    NSString * _direction;
    NSString * _doorHeadPic;
    NSString * _locationId;
    NSString * _avatar;
    NSString * _nickName;
}

- (instancetype)initWithMobile:(NSString *)mobile
                   phoneAreaNo:(NSString *)phoneAreaNo
                          code:(NSString *)code
                        avatar:(NSString *)avatar
                      nickName:(NSString *)nickName{
    self = [super init];
    if (self) {
        _mobile = mobile;
        _phoneAreaNo = phoneAreaNo;
        _code = code;
        _userType = @"1";
        _avatar = avatar;
        _nickName = nickName;
    }
    return self;
}

- (instancetype)initWithMobile:(NSString *)mobile
                   phoneAreaNo:(NSString *)phoneAreaNo
                          code:(NSString *)code
                   companyName:(NSString *)companyName
                companyAddress:(NSString *)companyAddress
                companyWebSite:(NSString *)companyWebSite
                  companyEmail:(NSString *)companyEmail
                companyContact:(NSString *)companyContact
                  companyPhone:(NSString *)companyPhone
                     direction:(NSString *)direction
               businessLicense:(NSString *)businessLicense
                   doorHeadPic:(NSString *)doorHeadPic
                    locationId:(NSString *)locationId {
    self = [super init];
    if (self) {
        _mobile = mobile;
        _phoneAreaNo = phoneAreaNo;
        _code = code;
        _userType = @"2";
        _companyName = companyName;
        _companyAddress = companyAddress;
        _businessLicense = businessLicense;
        _companyWebSite = companyWebSite;
        _companyEmail = companyEmail;
        _companyContact = companyContact;
        _companyPhone = companyPhone;
        _direction = direction;
        _doorHeadPic = doorHeadPic;
        _locationId = locationId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/index/login/userReg";
}
- (Class)dataModelClass {
    return [YCTLoginModel class];
}
- (NSDictionary *)yct_requestArgument {
    NSMutableDictionary *argument = @{}.mutableCopy;
    [argument setValue:_unionid forKey:@"unionid"];
    [argument setValue:_unionid forKey:@"unionId"];
    [argument setValue:_zlId forKey:@"zlId"];
    [argument setValue:_avatarUrl forKey:@"avatar"];
    
    [argument setValue:_mobile forKey:@"mobile"];
    [argument setValue:_code forKey:@"smsCode"];
    [argument setValue:_phoneAreaNo forKey:@"phoneAreaNo"];
    [argument setValue:_userType forKey:@"userType"];
    [argument setValue:_avatar forKey:@"avatar"];
    [argument setValue:_nickName forKey:@"nickName"];
    
    if (![_userType isEqualToString:@"1"]) {
        [argument setValue:_companyName forKey:@"companyName"];
        [argument setValue:_companyAddress forKey:@"companyAddress"];
        [argument setValue:_businessLicense forKey:@"businessLicense"];
        [argument setValue:_companyWebSite forKey:@"companyWebSite"];
        [argument setValue:_companyEmail forKey:@"companyEmail"];
        [argument setValue:_companyContact forKey:@"companyContact"];
        [argument setValue:_companyPhone forKey:@"companyPhone"];
        [argument setValue:_direction forKey:@"direction"];
        [argument setValue:_doorHeadPic forKey:@"doorHeadPic"];
        [argument setValue:_locationId forKey:@"locationId"];
    }
    
    return argument.copy;
}

@end
