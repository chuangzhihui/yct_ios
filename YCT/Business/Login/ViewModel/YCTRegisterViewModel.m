//
//  YCTRegisterViewModel.m
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTRegisterViewModel.h"
#import "YCTApiSendSmsCode.h"
#import "YCTApiUserReg.h"
#import "YCTApiUpload.h"
#import "YCTImageUploader.h"
#import "UIImage+Common.h"
@interface YCTRegisterViewModel()

@property (nonatomic, strong, readwrite) RACCommand * registerCommad;

@property (nonatomic, strong, readwrite) RACCommand * codeCommad;

@property (nonatomic, strong, readwrite) RACSubject * registerSuccessSubject;

@property (nonatomic, copy, readwrite) NSString * licenseResult;

@property (nonatomic, copy, readwrite) NSString * headReusult;
@end

@implementation YCTRegisterViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self bindView];
    }
    return self;
}

- (void)bindView{
    @weakify(self);
    
    RAC(self, licenseResult) = [RACObserve(self, licenseImage) map:^id _Nullable(id  _Nullable value) {
        return nil;
    }];
    
    RAC(self, headReusult) = [RACObserve(self, headImage) map:^id _Nullable(id  _Nullable value) {
        return nil;
    }];
    
    [self.registerCommad.executing subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (x.integerValue == 1) {
                [self.loadingSubject sendNext:@(YES)];
            }
        });
    }];
    
    //bindCommad完成信号，switchToLast表示获取最新信号只能用于信号中的信号
    [self.registerCommad.executionSignals.switchToLatest subscribeNext:^(YCTLoginModel *  _Nullable x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"注册成功回调");
            [self.loadingSubject sendNext:@(NO)];
            [[YCTUserManager sharedInstance] loginWithModel:x];
            [self.registerSuccessSubject sendNext:@""];
        });
    }];
    
    //bindCommad错误信号订阅，用于请求错误的回调
    [self.registerCommad.errors subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingSubject sendNext:@(NO)];
            if (x.domain.length) {
                [self.toastSubject sendNext:x.domain];
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
            if (x.domain.length) {
                [self.toastSubject sendNext:x.domain];
            }
        });
    }];
}


- (void)requestForUploadPhotoWithCompletion:(void(^)(BOOL success))completion{
    ///厂家注册上传头像方法注释
//    if (self.licenseResult && self.headReusult) {
//        completion(YES);
//        return;
//    }
//
//    NSMutableArray * images = @[].mutableCopy;
//    if (!self.headReusult) {
//        [images addObject:self.headImage];
//    }
//    if (!self.licenseResult) {
//        [images addObject:self.licenseImage];
//    }
//    YCTImageUploader * uploader = [[YCTImageUploader alloc] init];
//    [uploader uploadImages:images optionsMaker:^(YCTImageUploaderOptionsMaker * _Nonnull option) {
//        option.maxConcurrentTaskNumber = 1;
//    } completion:^(NSDictionary * _Nonnull imageUrlDic) {
//        self.headReusult = imageUrlDic[self.headImage.imageHash] ? imageUrlDic[self.headImage.imageHash] : self.headReusult;
//        self.licenseResult = imageUrlDic[self.licenseImage.imageHash] ? imageUrlDic[self.licenseImage.imageHash] : self.licenseResult;
//        if (self.licenseResult && self.headReusult) {
//            completion(YES);
//        }else{
//            completion(NO);
//        }
//    }];
    if (self.avatarUrl) {
        completion(YES);
        return;
    }

    NSArray * images = @[self.userAvatar];
    YCTImageUploader * uploader = [[YCTImageUploader alloc] init];
    [uploader uploadImages:images optionsMaker:^(YCTImageUploaderOptionsMaker * _Nonnull option) {
        option.maxConcurrentTaskNumber = 1;
    } completion:^(NSDictionary * _Nonnull imageUrlDic) {
        self.avatarUrl = imageUrlDic[self.userAvatar.imageHash] ? imageUrlDic[self.userAvatar.imageHash] : self.avatarUrl;
        if (self.avatarUrl) {
            completion(YES);
        }else{
            completion(NO);
        }
    }];
}

#pragma mark - getter
- (RACCommand *)registerCommad{
    if (!_registerCommad) {
        @weakify(self);
        _registerCommad = [[RACCommand alloc] initWithEnabled:[[RACSignal merge:@[RACObserve(self, phoneNum),RACObserve(self, coName),RACObserve(self, verificationCode),RACObserve(self, area),RACObserve(self, adress),RACObserve(self, web),RACObserve(self, mail),RACObserve(self, saleManager),RACObserve(self, coNumber),RACObserve(self, licenseImage),RACObserve(self, headImage),RACObserve(self, isFirm),RACObserve(self, userAvatar),RACObserve(self, nickName),RACObserve(self, isAgree)]] map:^id(id value) {
            if (self.isFirm) {
                return @(self.phoneNum.length && self.verificationCode.length && self.coName.length && self.area.length && self.adress.length && self.licenseImage != nil && self.headImage != nil && self.isAgree);
            }else{
                return @(self.phoneNum.length && self.verificationCode.length && (self.userAvatar || self.avatarUrl) && self.nickName.length && self.isAgree);
            }
        }] signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                if (self.isFirm) {
                    @weakify(self);
                    [self requestForUploadPhotoWithCompletion:^(BOOL success) {
                        @strongify(self);
                        if (success) {
                            YCTApiUserReg * api = [[YCTApiUserReg alloc] initWithMobile:self.phoneNum phoneAreaNo:self.phoneAreaNo code:self.verificationCode companyName:self.coName companyAddress:self.adress companyWebSite:self.web companyEmail:self.mail companyContact:self.saleManager companyPhone:self.coNumber direction:YCTString(self.mainDirection, @"") businessLicense:self.licenseResult doorHeadPic:self.headReusult locationId:self.locationId];
                            api.unionid = self.unionid;
                            api.zlId = self.zlId;
                            api.avatarUrl = self.avatarUrl;
                            api.nickName = self.nickName;
                            [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                                [subscriber sendNext:api.responseDataModel];
                                [subscriber sendCompleted];
                            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                                NSError * error = [NSError errorWithDomain:request.responseObject[@"msg"] code:request.error.code userInfo:request.error.userInfo];
                                [subscriber sendError:error];
                            }];
                        }else{
                            NSError * error = [NSError errorWithDomain:YCTLocalizedString(@"request.error") code:1 userInfo:@{}];
                            [subscriber sendError:error];
                        }
                    }];
                }else{
                    [self requestForUploadPhotoWithCompletion:^(BOOL success) {
                        @strongify(self);
                        YCTApiUserReg * api = [[YCTApiUserReg alloc] initWithMobile:self.phoneNum phoneAreaNo:self.phoneAreaNo code:self.verificationCode avatar:self.avatarUrl nickName:self.nickName];
                        api.unionid = self.unionid;
                        api.zlId = self.zlId;
                        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                            NSLog(@"response:%@",request.responseString);
//                            [[YCTUserManager sharedInstance] loginWithModel:loginModel];
//                            YCTLoginModel * loginModel= request.responseData;
//                            [[YCTUserManager sharedInstance] loginWithModel:loginModel];
                            [subscriber sendNext:api.responseDataModel];
                            [subscriber sendCompleted];
                        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                            NSString * msg = request.responseObject[@"msg"] ? : YCTLocalizedString(@"request.error");
                            NSError * error = [NSError errorWithDomain:msg code:request.error.code userInfo:request.error.userInfo];
                            [subscriber sendError:error];
                        }];
                    }];
                    
                }
                return nil;
            }];
        }];
    }
    return _registerCommad;
}

- (RACCommand *)codeCommad{
    if (!_codeCommad) {
        _codeCommad = [[RACCommand alloc] initWithEnabled:[RACObserve(self, phoneNum) map:^id(id value) {
            return @(self.phoneNum.length > 0);
        }] signalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                YCTApiSendSmsCode * api = [[YCTApiSendSmsCode alloc] initWithMobile:self.phoneNum key:k_smscodereg phoneAeaNo:self.phoneAreaNo];
                [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@""];
                    [subscriber sendCompleted];
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    NSString * msg = request.responseObject[@"msg"] ? : YCTLocalizedString(@"request.error");
                    NSError * error = [NSError errorWithDomain:msg code:request.error.code userInfo:request.error.userInfo];
                    [subscriber sendError:error];
                }];
                return nil;
            }];
        }];
    }
    return _codeCommad;
}

- (RACSubject *)registerSuccessSubject{
    if (!_registerSuccessSubject) {
        _registerSuccessSubject = [RACSubject subject];
    }
    return _registerSuccessSubject;
}
@end
