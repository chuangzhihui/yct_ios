//
//  YCTOpenPlatformManager.m
//  YCT
//
//  Created by 木木木 on 2022/1/14.
//

#import "YCTOpenPlatformManager.h"
#import "YCTOpenMessageHelper.h"
#import "WXApi.h"
#import <ZaloSDK/ZaloSDK.h>
#import "YCTOpenIDOAuthHelper.h"

@interface YCTOpenPlatformManager ()<WXApiDelegate>

@property (nonatomic, copy) YCTOpenPlatformRequestCompletionHandler requestCompletionHandler;
@property (nonatomic, copy) YCTOpenPlatformShareCompletionHandler shareCompletionHandler;

- (void)callErrorHandler:(NSString *)error;

@end

@implementation YCTOpenPlatformManager

NSString * const YCTAuthLoginErrorDomain = @"com.hhkj.yct.error.auth.login";

+ (instancetype)defaultManager {
    static YCTOpenPlatformManager *_defaultManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[YCTOpenPlatformManager alloc] init];
    });
    return _defaultManager;
}

- (void)setPlaform:(YCTOpenPlatformType)platformType
            appKey:(NSString *)appKey
         appSecret:(NSString *)appSecret
     universalLink:(NSString *)universalLink {
    if (appKey.length == 0) return;
    
    if (platformType == YCTOpenPlatformTypeWeChatSession
        || platformType == YCTOpenPlatformTypeWeChatTimeLine) {
        [WXApi registerApp:appKey universalLink:universalLink];
    }
    else if (platformType == YCTOpenPlatformTypeZalo) {
        [[ZaloSDK sharedInstance].config setPreferedLanguageType:(ZDKLanguageTypeEnglish)];
        [[ZaloSDK sharedInstance] initializeWithAppId:appKey];
    }
}

- (void)sendMessage:(YCTOpenMessageObject *)message
         toPlatform:(YCTOpenPlatformType)platformType
         completion:(YCTOpenPlatformShareCompletionHandler)completion {
    self.shareCompletionHandler = completion;
    [[YCTOpenMessageHelper sharedInstance] sendMessage:message toPlatform:platformType inViewController:[[[UIApplication sharedApplication] delegate] window].rootViewController completion:completion];
}

#pragma mark - OAuth

- (void)authenticationWithPlatformType:(YCTOpenPlatformType)platformType
                      inViewController:(UIViewController *)viewController
                            completion:(YCTOpenPlatformRequestCompletionHandler _Nullable)completion {
    self.requestCompletionHandler = completion;
    [[YCTOpenIDOAuthHelper sharedInstance] authenticationWithPlatformType:platformType inViewController:viewController];
}

#pragma mark - UIApplicationDelegate

- (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity {
    if ([WXApi handleOpenUniversalLink:userActivity delegate:self]) return YES;
    
    return NO;
}

- (BOOL)handleApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([WXApi handleOpenURL:url delegate:self]) return YES;
    
    if ([[ZDKApplicationDelegate sharedInstance] application:app openURL:url options:options]) return YES;
    
    return NO;
}

#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:SendAuthResp.class]) {
        SendAuthResp *response = (SendAuthResp *)resp;
        if (response.errCode == 0) {
            if (self.requestCompletionHandler) {
                self.requestCompletionHandler(response.code, nil);
            }
            self.requestCompletionHandler = nil;
        } else {
            [self callErrorHandler:response.errStr];
        }
    }
    else if ([resp isKindOfClass:SendMessageToWXResp.class]) {
        
        if (self.shareCompletionHandler) {
            SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
            if (response.errCode == 0) {
                self.shareCompletionHandler(YES, nil);
            } else {
                self.shareCompletionHandler(NO, response.errStr);
            }
            self.shareCompletionHandler = nil;
        }
    }
}

#pragma mark - Private

- (void)callErrorHandler:(NSString *)errorStr {
    if ([YCTOpenPlatformManager defaultManager].requestCompletionHandler) {
        NSError *error = [NSError errorWithDomain:YCTAuthLoginErrorDomain code:111 userInfo:@{NSLocalizedDescriptionKey:errorStr ?: YCTLocalizedString(@"alert.loginFailed")}];
        [YCTOpenPlatformManager defaultManager].requestCompletionHandler(nil, error);
        [YCTOpenPlatformManager defaultManager].requestCompletionHandler = nil;
    }
}

@end
