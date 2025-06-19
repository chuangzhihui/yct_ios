//
//  YCTOpenPlatformDefine.h
//  YCT
//
//  Created by 木木木 on 2022/1/14.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YCTOpenPlatformType) {
    YCTOpenPlatformTypeWeChatSession,
    YCTOpenPlatformTypeWeChatTimeLine,
    YCTOpenPlatformTypeZalo,
    YCTOpenPlatformTypeFaceBook,
};

typedef void (^YCTOpenPlatformRequestCompletionHandler)(id _Nullable result, NSError * _Nullable error);
typedef void (^YCTOpenPlatformShareCompletionHandler)(BOOL isSuccess, NSString * _Nullable error);
