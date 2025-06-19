//
//  YCTOpenIDOAuthHelper.h
//  YCT
//
//  Created by 木木木 on 2022/1/14.
//

#import <Foundation/Foundation.h>
#import "YCTOpenPlatformDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTOpenIDOAuthHelper : NSObject

+ (instancetype)sharedInstance;

- (void)authenticationWithPlatformType:(YCTOpenPlatformType)platformType
                      inViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
