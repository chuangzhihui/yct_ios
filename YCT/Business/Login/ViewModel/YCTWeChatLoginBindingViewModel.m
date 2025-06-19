//
//  YCTWeChatLoginBindingViewModel.m
//  YCT
//
//  Created by 木木木 on 2022/1/20.
//

#import "YCTWeChatLoginBindingViewModel.h"
#import "YCTApiSendSmsCode.h"
#import "YCTApiWeChatLogin.h"

@interface YCTWeChatLoginBindingViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *bindCommad;
@property (nonatomic, strong, readwrite) RACCommand *codeCommad;
@property (nonatomic, strong, readwrite) RACSubject *needRegisterSubject;
@property (nonatomic, strong, readwrite) RACSubject *bindCompletionSubject;
@property (nonatomic, copy, readwrite) void (^configResigerInfoBlock)(YCTRegisterViewController *vc);
@end

@implementation YCTWeChatLoginBindingViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self bindModel];
    }
    return self;
}

- (void)bindModel{
    @weakify(self);

    [self.bindCommad.executing subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (x.boolValue) {
                [self.loadingSubject sendNext:@(YES)];
            }
        });
    }];
    
    [self.bindCommad.executionSignals.switchToLatest subscribeNext:^(YCTOpenAuthLoginModel * x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingSubject sendNext:@(NO)];
            
            if (x.isReg) {
                [[YCTUserManager sharedInstance] loginWithModel:x];
                [self.bindCompletionSubject sendNext:@""];
            } else {
                [self.needRegisterSubject sendNext:@""];
            }
        });
    }];
    
    [self.bindCommad.errors subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingSubject sendNext:@(NO)];
            if (x.localizedDescription.length) {
                [self.toastSubject sendNext:x.localizedDescription];
            }
        });
    }];
    
    [self.codeCommad.errors subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingSubject sendNext:@(NO)];
            if (x.localizedDescription.length) {
                [self.toastSubject sendNext:x.localizedDescription];
            }
        });
    }];
}

#pragma mark - Getter

- (RACCommand *)bindCommad {
    if (!_bindCommad) {
        @weakify(self);
        _bindCommad = [[RACCommand alloc] initWithEnabled:[[RACSignal merge:@[RACObserve(self, mobile),RACObserve(self, smsCode)]] map:^id(id value) {
            @strongify(self);
            return @(self.mobile.length && self.smsCode.length);
        }] signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                YCTApiWeChatLoginBinding *api = [[YCTApiWeChatLoginBinding alloc] init];
                api.mobile = self.mobile;
                api.smsCode = self.smsCode;
                api.unionId = self.unionId;
                api.avatar = self.avatar;
                api.nickName = self.nickName;
                api.loginType = self.loginType;
                [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:api.responseDataModel];
                    [subscriber sendCompleted];
                } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
                    NSError *error = [NSError errorWithDomain:YCTRequestErrorDomain code:YCTRequestErrorCode userInfo:@{
                        NSLocalizedDescriptionKey: request.getError ?: YCTLocalizedString(@"request.error")
                    }];
                    [subscriber sendError:error];
                }];
                return nil;
            }];
        }];
    }
    return _bindCommad;
}

- (RACCommand *)codeCommad {
    if (!_codeCommad) {
        @weakify(self);
        _codeCommad = [[RACCommand alloc] initWithEnabled:[RACObserve(self, mobile) map:^id(id value) {
            @strongify(self);
            return @(self.mobile.length > 0);
        }] signalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                YCTApiSendSmsCode *api = [[YCTApiSendSmsCode alloc] initWithMobile:self.mobile key:k_smscodeBindWx phoneAeaNo:self.phoneAreaNo];
                [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@""];
                    [subscriber sendCompleted];
                } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
                    NSError *error = [NSError errorWithDomain:YCTRequestErrorDomain code:YCTRequestErrorCode userInfo:@{
                        NSLocalizedDescriptionKey: request.getError ?: YCTLocalizedString(@"request.error")
                    }];
                    [subscriber sendError:error];
                }];
                return nil;
            }];
        }];
    }
    return _codeCommad;
}

- (RACSubject *)needRegisterSubject {
    if (!_needRegisterSubject) {
        _needRegisterSubject = [RACSubject subject];
    }
    return _needRegisterSubject;
}

- (RACSubject *)bindCompletionSubject {
    if (!_bindCompletionSubject) {
        _bindCompletionSubject = [RACSubject subject];
    }
    return _bindCompletionSubject;
}

- (void (^)(YCTRegisterViewController *))configResigerInfoBlock {
    if (!_configResigerInfoBlock) {
        @weakify(self);
        _configResigerInfoBlock = ^ (YCTRegisterViewController *vc) {
            @strongify(self);
            vc.unionid = self.unionId;
            vc.avatarUrl = self.avatar;
            vc.nickName = self.nickName;
        };
    }
    return _configResigerInfoBlock;
}

@end
