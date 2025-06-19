//
//  YCTUserManager.m
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTUserManager.h"
#import "YCTApiMineUserInfo.h"
#import "YCTRootViewController.h"
#import "YCT-Swift.h"
#import "YCTApiUploadUserRegId.h"
#import "JPUSHService.h"
static NSString * const k_login_model = @"k_login_model";

static NSString * const k_user_info_model = @"k_user_info_model";

static NSString * const k_user_locationId = @"k_user_locationId";

static NSString * const k_user_locationCity = @"k_user_locationCity";

@interface YCTUserDataManager ()

@property (nonatomic, strong, readwrite) YCTMineUserInfoModel *userInfoModel;

@property (nonatomic, strong, readwrite) YCTLoginModel * loginModel;

@end

@implementation YCTUserDataManager

YCT_SINGLETON_IMP

- (instancetype)init {
    if (self = [super init]) {
        self.loginModel = [self getLoginModel];
        self.userInfoModel = [self getUserInfo];
        self.locationId = [self getLocationid];
        self.locationCity = [self getLocationName];
        [self bindModel];
    }
    return self;
}

- (void)bindModel {
    RAC(self, isLogin) = [RACObserve(self, loginModel) map:^id _Nullable(id  _Nullable value) {
        return @(self.loginModel != nil);
    }];
}

- (YCTLoginModel *)getLoginModel {
    return [[YCTKeyValueStorage defaultStorage] objectForKey:k_login_model ofClass:[YCTLoginModel class]];;
}

- (YCTMineUserInfoModel *)getUserInfo {
    return [[YCTKeyValueStorage defaultStorage] objectForKey:k_user_info_model ofClass:[YCTMineUserInfoModel class]];;
}

- (NSString *)getLocationid {
    return [[YCTKeyValueStorage defaultStorage] objectForKey:k_user_locationId ofClass:[NSString class]];;
}

- (NSString *)getLocationName {
    return [[YCTKeyValueStorage defaultStorage] objectForKey:k_user_locationCity ofClass:[NSString class]];;
}

- (void)updateLoginModel:(YCTLoginModel *)loginModel {
    self.loginModel = loginModel;
    [[YCTKeyValueStorage defaultStorage] setObject:loginModel forKey:k_login_model];
}

- (void)updateUserInfo:(YCTMineUserInfoModel *)userInfo {
    self.userInfoModel = userInfo;
    [[YCTKeyValueStorage defaultStorage] setObject:userInfo forKey:k_user_info_model];
}

- (void)updateInfoModel {
    [[YCTKeyValueStorage defaultStorage] setObject:self.userInfoModel forKey:k_user_info_model];
}


- (void)setLocationId:(NSString *)locationId{
    [[YCTKeyValueStorage defaultStorage] setObject:locationId forKey:k_user_locationId];
    _locationId = locationId;
    
}

- (void)setLocationCity:(NSString *)locationCity{
    [[YCTKeyValueStorage defaultStorage] setObject:locationCity forKey:k_user_locationCity];
    _locationCity = locationCity;
}

@end

@interface YCTUserManager ()

@property (strong, nonatomic) YCTApiMineUserInfo *apiUserInfo;

@end

@implementation YCTUserManager

YCT_SINGLETON_IMP

- (void)autoLoginFetchUserInfo {
    if ([YCTUserDataManager sharedInstance].isLogin) {
        [self requestUserInfo];
        [self imLogin];
        [self sendbirdLogin];
    }
}

- (void)loginWithModel:(YCTLoginModel *)loginModel {
    [[YCTUserDataManager sharedInstance] updateLoginModel:loginModel];
    [self requestUserInfo];
    [self imLogin];
    [self sendbirdLogin];
}

- (void)logout {
    [self.apiUserInfo stop];
    self.apiUserInfo = nil;
    [[YCTUserDataManager sharedInstance] updateLoginModel:nil];
    [[YCTUserDataManager sharedInstance] updateUserInfo:nil];
    [self imLogout];
    [[YCTRootViewController sharedInstance] backToHome];
    [[LiveStreamManager shared] logoutUser];
}

- (void)updateUserInfo {
    [self requestUserInfo];
}

#pragma mark - Private

- (void)imLogin {
    [self uploadUserRegId];
    [YCTChatUtil loginSuccess:^{
        
    } fail:^(int code, NSString * _Nonnull msg) {
        
    }];
}
-(void)uploadUserRegId{
    YCTApiUploadUserRegId * api=[[YCTApiUploadUserRegId alloc] init];
    api.reg_id=JPUSHService.registrationID;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
- (void)sendbirdLogin {
    NSString *imName = [[YCTUserDataManager sharedInstance].loginModel.IMName stringByReplacingOccurrencesOfString:@"user" withString:@""];
    [[LiveStreamManager shared] loginUserWithUserId:imName onSuccess:^(SBDUser * _Nonnull) {
        
    } onFailure:^(NSError * _Nonnull) {
        
    }];
}


- (void)imLogout {
    [YCTChatUtil logoutSuccess:^{
        
    } fail:^(int code, NSString * _Nonnull msg) {
        
    }];
}

- (void)requestUserInfo {
    static int retryCount = 5;
    [self.apiUserInfo stop];
    self.apiUserInfo = [[YCTApiMineUserInfo alloc] init];
    [self.apiUserInfo startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        retryCount = 5;
        NSLog(@"loginRes:%@",request.responseString);
        [[YCTUserDataManager sharedInstance] updateUserInfo:request.responseDataModel];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        /// 考虑重新请求
        if (retryCount != 0) {
            [self performSelector:@selector(requestUserInfo) withObject:nil afterDelay:5];
            retryCount -= 0;
        }
    }];
}

@end
