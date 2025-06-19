//
//  YCTZaloAuthenUtils.m
//  YCT
//
//  Created by 木木木 on 2022/1/14.
//

#import "YCTZaloAuthenUtils.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#import <ZaloSDK/ZaloSDK.h>

@interface YCTZaloAuthenUtils ()
@property (nonatomic, strong) ZOTokenResponseObject *tokenResponse;
@property (nonatomic, copy, readwrite) NSString *codeChallenage;
@property (nonatomic, copy, readwrite) NSString *codeVerifier;
@end

@implementation YCTZaloAuthenUtils

+ (instancetype)sharedInstance {
    static YCTZaloAuthenUtils *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         _sharedInstance = [YCTZaloAuthenUtils new];
    });
    return _sharedInstance;
}

- (NSString *)generateCodeVerifier {
    uint8_t randomBytes[32];
    
    int result = SecRandomCopyBytes(kSecRandomDefault, 32, randomBytes);
    if (result != 0) {
        return nil;
    }
    
    NSString *codeVerifier = [[[[[[[NSData alloc] initWithBytes:randomBytes length:32]
         base64EncodedStringWithOptions:(0)]
        stringByReplacingOccurrencesOfString:@"+" withString:@"-"]
        stringByReplacingOccurrencesOfString:@"/" withString:@"_"]
        stringByReplacingOccurrencesOfString:@"=" withString:@""]
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return codeVerifier;
}

- (NSString *)generateCodeChallengeWithCodeVerifier:(NSString *)codeVerifier {
    if (!codeVerifier) return nil;
    
    NSData *data = [codeVerifier dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) return nil;
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    
    NSString *challenge = [[[[[[[NSData alloc] initWithBytes:digest length:CC_SHA256_DIGEST_LENGTH]
         base64EncodedStringWithOptions:(0)]
        stringByReplacingOccurrencesOfString:@"+" withString:@"-"]
        stringByReplacingOccurrencesOfString:@"/" withString:@"_"]
        stringByReplacingOccurrencesOfString:@"=" withString:@""]
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return challenge;
}

- (void)renewPKCECode {
    self.codeVerifier = [self generateCodeVerifier];
    self.codeChallenage  = [self generateCodeChallengeWithCodeVerifier:self.codeVerifier];
}

- (NSString *)getAccessToken {
    return self.tokenResponse.accessToken;
}

- (void)saveTokenResponse:(ZOTokenResponseObject *)tokenResponse {
    self.tokenResponse = tokenResponse;
}

@end
