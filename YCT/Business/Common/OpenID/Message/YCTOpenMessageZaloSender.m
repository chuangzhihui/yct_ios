//
//  YCTOpenMessageZaloSender.m
//  YCT
//
//  Created by 木木木 on 2022/1/22.
//

#import "YCTOpenMessageZaloSender.h"
#import <ZaloSDK/ZaloSDK.h>

@implementation YCTOpenMessageZaloSender

- (void)sendMessage:(YCTOpenMessageObject *)message
         toPlatform:(YCTOpenPlatformType)platformType
   inViewController:(UIViewController *)viewController
         completion:(YCTOpenPlatformShareCompletionHandler)completion {
    if ([message.shareObject isKindOfClass:YCTShareVideoItem.class]) {
        [self sendVideoMsg:(YCTShareVideoItem *)message.shareObject inViewController:viewController completion:completion];
    }
    else if ([message.shareObject isKindOfClass:YCTShareWebpageItem.class]) {
        [self sendWebpageMsg:(YCTShareWebpageItem *)message.shareObject inViewController:viewController completion:completion];
    }
}

- (void)sendVideoMsg:(YCTShareVideoItem *)message
    inViewController:(UIViewController *)viewController
          completion:(YCTOpenPlatformShareCompletionHandler)completion {
    ZOFeed *feed = [[ZOFeed alloc] initWithLink:message.videoUrl appName:YCTLocalizedTableString(@"CFBundleDisplayName", @"InfoPlist") message:message.title others:nil];
    feed.linkDesc = message.desc;
    [[ZaloSDK sharedInstance] sendMessage:feed inController:viewController callback:^(ZOShareResponseObject *response) {
        if (response.isSucess) {
            completion(YES, nil);
        } else {
            completion(NO, response.errorMessage);
        }
    }];
}

- (void)sendWebpageMsg:(YCTShareWebpageItem *)message
      inViewController:(UIViewController *)viewController
            completion:(YCTOpenPlatformShareCompletionHandler)completion {
    ZOFeed *feed = [[ZOFeed alloc] initWithLink:message.webpageUrl appName:YCTLocalizedTableString(@"CFBundleDisplayName", @"InfoPlist") message:message.title others:nil];
    feed.linkDesc = message.desc;
    [[ZaloSDK sharedInstance] sendMessage:feed inController:viewController callback:^(ZOShareResponseObject *response) {
        if (response.isSucess) {
            completion(YES, nil);
        } else {
            completion(NO, response.errorMessage);
        }
    }];
}

@end
