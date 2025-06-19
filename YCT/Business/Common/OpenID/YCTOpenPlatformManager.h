//
//  YCTOpenPlatformManager.h
//  YCT
//
//  Created by 木木木 on 2022/1/14.
//

#import <Foundation/Foundation.h>
#import "YCTOpenMessageObject.h"
#import "YCTOpenPlatformDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTOpenPlatformManager : NSObject

+ (instancetype)defaultManager;

- (void)setPlaform:(YCTOpenPlatformType)platformType
            appKey:(NSString *)appKey
         appSecret:(NSString * _Nullable)appSecret
     universalLink:(NSString * _Nullable)universalLink;

- (void)sendMessage:(YCTOpenMessageObject *)message
         toPlatform:(YCTOpenPlatformType)platformType
         completion:(YCTOpenPlatformShareCompletionHandler _Nullable)completion;

- (void)authenticationWithPlatformType:(YCTOpenPlatformType)platformType
                      inViewController:(UIViewController *)viewController
                            completion:(YCTOpenPlatformRequestCompletionHandler _Nullable)completion;

- (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity;
- (BOOL)handleApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;

@end

NS_ASSUME_NONNULL_END
