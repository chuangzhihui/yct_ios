//
//  YCTLoginViewController.h
//  YCT
//
//  Created by hua-cloud on 2021/12/23.
//

#import "YCTBaseViewController.h"
#import "YCTRegisterViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YCTOpenIDBindingViewModelProtocol <NSObject>

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *smsCode;

@property (nonatomic, copy) NSString *phoneAreaNo;

@property (nonatomic, strong, readonly) RACCommand *bindCommad;

@property (nonatomic, strong, readonly) RACCommand *codeCommad;

@property (nonatomic, strong, readonly) RACSubject *bindCompletionSubject;

@property (nonatomic, strong, readonly) RACSubject *needRegisterSubject;

@property (nonatomic, strong, readonly) RACSubject *loadingSubject;

@property (nonatomic, strong, readonly) RACSubject *toastSubject;

@property (nonatomic, copy, readonly) void (^configResigerInfoBlock)(YCTRegisterViewController *vc);

@end

@interface YCTOpenIDBindingViewController : YCTBaseViewController

- (instancetype)initWithViewModel:(id<YCTOpenIDBindingViewModelProtocol>)viewModel;

@end

NS_ASSUME_NONNULL_END
