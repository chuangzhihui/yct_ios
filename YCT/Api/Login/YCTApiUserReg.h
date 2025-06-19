//
//  YCTApiUserReg.h
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiUserReg : YCTBaseRequest

@property (nonatomic, copy) NSString * _Nullable unionid;
@property (nonatomic, copy) NSString * _Nullable zlId;
@property (nonatomic, copy) NSString * _Nullable nickName;
@property (nonatomic, copy) NSString * _Nullable avatarUrl;

- (instancetype)initWithMobile:(NSString *)mobile
                   phoneAreaNo:(NSString *)phoneAreaNo
                          code:(NSString *)code
                        avatar:(NSString *)avatar
                      nickName:(NSString *)nickName;

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
                    locationId:(NSString *)locationId;
@end

NS_ASSUME_NONNULL_END
