//
//  YCTWebviewURLProvider.h
//  YCT
//
//  Created by 木木木 on 2022/1/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int, YCTWebviewURLType) {
    /// 用户协议
    YCTWebviewURLTypeUserAgreement  = 13,
    /// 隐私政策
    YCTWebviewURLTypePrivacyPolicy  = 14,
    /// 社会自律公约
    YCTWebviewURLTypePact           = 15,
    /// 关于我们
    YCTWebviewURLTypeAboutUs        = 16,
};

@interface YCTWebviewURLProvider : NSObject

+ (NSURL * _Nullable)sharedVideoUrlWithId:(NSString *)videoId;

+ (NSURL * _Nullable)sharedUserHomePageUrlWithId:(NSString *)userId;

+ (NSURL * _Nullable)dataChartsUrl;

+ (NSURL * _Nullable)h5WithType:(YCTWebviewURLType)type;

@end

NS_ASSUME_NONNULL_END
