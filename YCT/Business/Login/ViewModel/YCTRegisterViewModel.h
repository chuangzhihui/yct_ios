//
//  YCTRegisterViewModel.h
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTRegisterViewModel : YCTBaseViewModel
@property (nonatomic, copy) NSString * phoneNum;
@property (nonatomic, copy) NSString * verificationCode;
@property (nonatomic, copy) NSString * coName;
@property (nonatomic, copy) NSString * area;
@property (nonatomic, copy) NSString * adress;
@property (nonatomic, copy) NSString * web;
@property (nonatomic, copy) NSString * mail;
@property (nonatomic, copy) NSString * saleManager;
@property (nonatomic, copy) NSString * coNumber;
@property (nonatomic, copy) NSString * mainDirection;
@property (nonatomic, strong) UIImage * licenseImage;
@property (nonatomic, strong) UIImage * headImage;
@property (nonatomic, copy) NSString * locationId;
@property (nonatomic, copy) NSString * phoneAreaNo;
@property (nonatomic, strong) UIImage * userAvatar;

@property (nonatomic, assign) BOOL isFirm;
@property (nonatomic, assign) BOOL isAgree;

@property (nonatomic, strong, readonly) RACCommand * registerCommad;
@property (nonatomic, strong, readonly) RACCommand * codeCommad;
@property (nonatomic, strong, readonly) RACSubject * registerSuccessSubject;

@property (nonatomic, copy) NSString * _Nullable unionid;
@property (nonatomic, copy) NSString * _Nullable zlId;
@property (nonatomic, copy) NSString * _Nullable nickName;
@property (nonatomic, copy) NSString * _Nullable avatarUrl;
@end

NS_ASSUME_NONNULL_END
