//
//  YCTFaceLoginBindingViewModel.h
//  YCT
//
//  Created by 张大爷的 on 2023/4/7.
//

#import <UIKit/UIKit.h>
#import "YCTOpenIDBindingViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCTFaceLoginBindingViewModel : YCTBaseViewModel<YCTOpenIDBindingViewModelProtocol>
#pragma mark - YCTOpenIDBindingViewModelProtocol
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, strong, readonly) RACCommand *bindCommad;
@property (nonatomic, strong, readonly) RACCommand *codeCommad;
@property (nonatomic, strong, readonly) RACSubject *needRegisterSubject;
@property (nonatomic, strong, readonly) RACSubject *bindCompletionSubject;
@property (nonatomic, copy, readonly) void (^configResigerInfoBlock)(YCTRegisterViewController *vc);

@property (nonatomic, copy) NSString *fbId;
@property int type;
@end

NS_ASSUME_NONNULL_END
