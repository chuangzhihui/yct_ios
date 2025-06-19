//
//  YCTZaloAuthenUtils.h
//  YCT
//
//  Created by 木木木 on 2022/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ZOTokenResponseObject;

@interface YCTZaloAuthenUtils : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, copy, readonly) NSString *codeChallenage;
@property (nonatomic, copy, readonly) NSString *codeVerifier;

- (NSString *)getAccessToken;

- (void)renewPKCECode;

- (void)saveTokenResponse:(ZOTokenResponseObject *)tokenResponse;

@end

NS_ASSUME_NONNULL_END
