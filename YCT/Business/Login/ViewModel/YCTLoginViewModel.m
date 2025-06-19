//
//  YCTLoginViewModel.m
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTLoginViewModel.h"
#import "YCTApiSendSmsCode.h"
#import "YCTApiLoginBySms.h"
#import "YCTApiLoginByPassword.h"
#import "YCTUserManager.h"

@interface YCTLoginViewModel ()

@property (nonatomic, strong, readwrite) RACCommand * loginCommad;

@property (nonatomic, strong, readwrite) RACCommand * codeCommad;

@property (nonatomic, strong, readwrite) RACSubject * loginCompletionSubject;
@end

@implementation YCTLoginViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self bindModel];
    }
    return self;
}

- (void)bindModel{
    @weakify(self);
//    bindCommand状态订阅
    [self.loginCommad.executing subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (x.integerValue == 1) {
                [self.loadingSubject sendNext:@(YES)];
            }
        });
    }];
    
    //bindCommad完成信号，switchToLast表示获取最新信号只能用于信号中的信号
    [self.loginCommad.executionSignals.switchToLatest subscribeNext:^(YCTLoginModel *  _Nullable x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingSubject sendNext:@(NO)];
            [[YCTUserManager sharedInstance] loginWithModel:x];
            [self.loginCompletionSubject sendNext:@""];
        });
    }];
    
    //bindCommad错误信号订阅，用于请求错误的回调
    [self.loginCommad.errors subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingSubject sendNext:@(NO)];
            if (x.localizedDescription.length) {
                [self.toastSubject sendNext:x.localizedDescription];
            }
        });
    }];
    
    [self.codeCommad.executing subscribeNext:^(NSNumber * _Nullable x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
    
    //bindCommad完成信号，switchToLast表示获取最新信号只能用于信号中的信号
    [self.codeCommad.executionSignals.switchToLatest subscribeNext:^(NSString *  _Nullable x) {
//        @strongify(self);
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//        });
    }];
    
    //bindCommad错误信号订阅，用于请求错误的回调
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

#pragma mark - request

#pragma mark - getter
- (RACCommand *)loginCommad{
    if (!_loginCommad) {
        @weakify(self);
        _loginCommad = [[RACCommand alloc] initWithEnabled:[[RACSignal merge:@[RACObserve(self, phoneNum),RACObserve(self, passWord),RACObserve(self, verificationCode),RACObserve(self, isAgree),RACObserve(self, isPassLogin)]] map:^id(id value) {
            if (self.isPassLogin) {
                return @(self.phoneNum.length && self.passWord.length && self.isAgree);
            }else{
                return @(self.phoneNum.length && self.verificationCode.length && self.isAgree);;
            }
        }] signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                if (self.isPassLogin) {
                    NSDictionary *payload = @{
                        @"mobile": self.phoneNum ?: @"",
                        @"password": self.passWord ?: @""
                    };
                    NSLog(@"Password Login Payload: %@", payload);
                    YCTApiLoginByPassword * api = [[YCTApiLoginByPassword alloc] initWithMobile:self.phoneNum password:self.passWord];
                    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        NSLog(@"Success Response: %@", api.responseDataModel);
                        [subscriber sendNext:api.responseDataModel];
                        [subscriber sendCompleted];
                    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
                        NSError *error = [NSError errorWithDomain:YCTRequestErrorDomain code:YCTRequestErrorCode userInfo:@{
                            NSLocalizedDescriptionKey: request.getError ?: YCTLocalizedString(@"request.error")
                        }];
                        [subscriber sendError:error];
                    }];
                }else{
                    YCTApiLoginBySms * api = [[YCTApiLoginBySms alloc] initWithMobile:self.phoneNum smsCode:self.verificationCode phoneAreaNo:self.phoneAreaNo];
                    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [subscriber sendNext:api.responseDataModel];
                        [subscriber sendCompleted];
                    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
                        NSError *error = [NSError errorWithDomain:YCTRequestErrorDomain code:YCTRequestErrorCode userInfo:@{
                            NSLocalizedDescriptionKey: request.getError ?: YCTLocalizedString(@"request.error")
                        }];
                        [subscriber sendError:error];
                    }];
                }
                return nil;
            }];
        }];
    }
    return _loginCommad;
}

- (RACCommand *)codeCommad{
    if (!_codeCommad) {
        _codeCommad = [[RACCommand alloc] initWithEnabled:[RACObserve(self, phoneNum) map:^id(id value) {
            return @(self.phoneNum.length > 0);
        }] signalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                YCTApiSendSmsCode * api = [[YCTApiSendSmsCode alloc] initWithMobile:self.phoneNum key:k_smscodelogin phoneAeaNo:self.phoneAreaNo];
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


- (RACSubject *)loginCompletionSubject{
    if (!_loginCompletionSubject) {
        _loginCompletionSubject = [RACSubject subject];
    }
    return _loginCompletionSubject;
}
@end
