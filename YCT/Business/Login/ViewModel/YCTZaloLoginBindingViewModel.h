//
//  YCTZaloLoginBindingViewModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/20.
//

#import "YCTBaseViewModel.h"
#import "YCTOpenIDBindingViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTZaloLoginBindingViewModel : YCTBaseViewModel<YCTOpenIDBindingViewModelProtocol>

#pragma mark - YCTOpenIDBindingViewModelProtocol
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, copy) NSString *phoneAreaNo;
@property (nonatomic, strong, readonly) RACCommand *bindCommad;
@property (nonatomic, strong, readonly) RACCommand *codeCommad;
@property (nonatomic, strong, readonly) RACSubject *needRegisterSubject;
@property (nonatomic, strong, readonly) RACSubject *bindCompletionSubject;
@property (nonatomic, copy, readonly) void (^configResigerInfoBlock)(YCTRegisterViewController *vc);

@property (nonatomic, copy) NSString *zlId;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickName;

@end

NS_ASSUME_NONNULL_END
