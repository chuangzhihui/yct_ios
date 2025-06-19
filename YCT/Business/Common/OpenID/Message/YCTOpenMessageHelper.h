//
//  YCTOpenMessageHelper.h
//  YCT
//
//  Created by 木木木 on 2022/1/14.
//

#import <Foundation/Foundation.h>
#import "YCTOpenMessageObject.h"
#import "YCTOpenPlatformDefine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YCTOpenMessageSend <NSObject>

- (void)sendMessage:(YCTOpenMessageObject *)message
         toPlatform:(YCTOpenPlatformType)platformType
   inViewController:(UIViewController *)viewController
         completion:(YCTOpenPlatformShareCompletionHandler _Nullable)completion;

@end

@interface YCTOpenMessageHelper : NSObject<YCTOpenMessageSend>

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
