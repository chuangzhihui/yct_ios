//
//  YCTLoginViewModel.h
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTLoginViewModel : YCTBaseViewModel

@property (nonatomic, copy) NSString * phoneNum;
@property (nonatomic, copy) NSString * phoneAreaNo;
@property (nonatomic, copy) NSString * passWord;
@property (nonatomic, copy) NSString * verificationCode;
@property (nonatomic, assign) bool isAgree;
/// 是否密码登录
@property (nonatomic, assign) BOOL isPassLogin;

@property (nonatomic, strong, readonly) RACCommand * loginCommad;

@property (nonatomic, strong, readonly) RACCommand * codeCommad;

@property (nonatomic, strong, readonly) RACSubject * loginCompletionSubject;
@end

NS_ASSUME_NONNULL_END
