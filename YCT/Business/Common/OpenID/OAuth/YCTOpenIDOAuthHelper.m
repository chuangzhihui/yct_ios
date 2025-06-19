//
//  YCTOpenIDOAuthHelper.m
//  YCT
//
//  Created by 木木木 on 2022/1/14.
//

#import "YCTOpenIDOAuthHelper.h"
#import <ZaloSDK/ZaloSDK.h>
#import "YCTZaloAuthenUtils.h"
#import "YCTOpenPlatformManager.h"
#import "WXApi.h"

@interface YCTOpenPlatformManager (Protected)<WXApiDelegate>
@property (nonatomic, copy) YCTOpenPlatformRequestCompletionHandler requestCompletionHandler;
@property (nonatomic, copy) YCTOpenPlatformShareCompletionHandler shareCompletionHandler;
- (void)callErrorHandler:(NSString *)error;
@end

@implementation YCTOpenIDOAuthHelper

+ (instancetype)sharedInstance {
    static YCTOpenIDOAuthHelper *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         _sharedInstance = [YCTOpenIDOAuthHelper new];
    });
    return _sharedInstance;
}

- (void)authenticationWithPlatformType:(YCTOpenPlatformType)platformType
                      inViewController:(UIViewController *)viewController {
    if (platformType == YCTOpenPlatformTypeWeChatSession || platformType == YCTOpenPlatformTypeWeChatTimeLine) {
        [self weChatAuthenticationIn:viewController];
    }
    else if (platformType == YCTOpenPlatformTypeZalo) {
        [self zaloAuthenticationIn:viewController];
    }
}

#pragma mark - WeChat

- (void)weChatAuthenticationIn:(UIViewController *)viewController {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"1234";
    [WXApi sendAuthReq:req viewController:viewController delegate:[YCTOpenPlatformManager defaultManager] completion:NULL];
}

#pragma mark - Zalo

- (void)zaloAuthenticationIn:(UIViewController *)viewController {
    [[YCTZaloAuthenUtils sharedInstance] renewPKCECode];
    [[ZaloSDK sharedInstance] authenticateZaloWithAuthenType:ZAZaloSDKAuthenTypeViaZaloAppOnly parentController:viewController codeChallenge:[YCTZaloAuthenUtils sharedInstance].codeChallenage extInfo:nil handler:^(ZOOauthResponseObject *response) {
        if (response.isSucess) {
            [self getAccessTokenFromOAuthCode:response.oauthCode];
        } else {
            [[YCTOpenPlatformManager defaultManager] callErrorHandler:response.errorMessage];
        }
    }];
}

- (void)getAccessTokenFromOAuthCode:(NSString *)oauthCode {
    [[ZaloSDK sharedInstance] getAccessTokenWithOAuthCode:(NSString *)oauthCode codeVerifier:[YCTZaloAuthenUtils sharedInstance].codeVerifier completionHandler:^(ZOTokenResponseObject *response) {
        if (response.isSucess) {
            [[YCTZaloAuthenUtils sharedInstance] saveTokenResponse:response];
            [self getZaloUserProfile:response.accessToken];
        } else {
            [[YCTOpenPlatformManager defaultManager] callErrorHandler:response.errorMessage];
        }
    }];
}

- (void)getZaloUserProfile:(NSString *)accessToken {
    [[ZaloSDK sharedInstance] getZaloUserProfileWithAccessToken:accessToken callback:^(ZOGraphResponseObject *response) {
        if ([YCTOpenPlatformManager defaultManager].requestCompletionHandler) {
            [YCTOpenPlatformManager defaultManager].requestCompletionHandler(response.data, nil);
            [YCTOpenPlatformManager defaultManager].requestCompletionHandler = nil;
        }
    }];
}

@end
