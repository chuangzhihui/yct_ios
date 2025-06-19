//
//  YCTWebviewURLProvider.m
//  YCT
//
//  Created by 木木木 on 2022/1/24.
//

#import "YCTWebviewURLProvider.h"

#define kYCTBaseUrl @"https://yct.vnppp.net/index.html#/"

#define kYCTVideoPath @"video?"
#define kYCTUserPath @"index?"
#define kYCTDataPath @"data?"
#define kYCTAgreementPath @"agreement?"

/*
 分享视频的url：https://yct.vnppp.net/index.html#/video?id=视频ID&lan=语言类型
 
 分享用户主页的url  https://yct.vnppp.net/index.html#/index?id=用户ID&lan=语言类型
 
 数据看板webview 地址 https://yct.vnppp.net/index.html#/data?token=用户token&lan=语言类型
 
 ID 13用户协议 14隐私政策 15社会自律公约 16关务我们 https://yct.vnppp.net/index.html#/agreement?id=13~16
 */

@implementation YCTWebviewURLProvider

+ (NSString *)lan {
    return [[YCTSanboxTool getCurrentLanguage] isEqualToString:EN] ? @"2" : @"1";
}

+ (NSURL *)sharedVideoUrlWithId:(NSString *)videoId {
    NSString *url = [NSString stringWithFormat:@"%@%@id=%@&lan=%@", kYCTBaseUrl, kYCTVideoPath, videoId, [self lan]];
    return [NSURL URLWithString:url];
}

+ (NSURL *)sharedUserHomePageUrlWithId:(NSString *)userId {
    NSString *url = [NSString stringWithFormat:@"%@%@id=%@&lan=%@", kYCTBaseUrl, kYCTUserPath, userId, [self lan]];
    return [NSURL URLWithString:url];
}

+ (NSURL *)dataChartsUrl {
    NSString *url = [NSString stringWithFormat:@"%@%@token=%@&lan=%@", kYCTBaseUrl, kYCTDataPath, [YCTUserDataManager sharedInstance].loginModel.token, [self lan]];
    return [NSURL URLWithString:url];
}

+ (NSURL *)h5WithType:(YCTWebviewURLType)type {
    NSString *url = [NSString stringWithFormat:@"%@%@id=%d&lan=%@", kYCTBaseUrl, kYCTAgreementPath, type, [self lan]];
    return [NSURL URLWithString:url];
}

@end
