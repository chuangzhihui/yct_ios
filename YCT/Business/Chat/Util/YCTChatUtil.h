//
//  YCTChatUtil.h
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *kYCTChatUtilUnreadMsgCountKey;

UIKIT_EXTERN NSString *kYCTChatUtilUnreadMsgChangedNotification;
UIKIT_EXTERN NSString *kYCTChatUtilLogoutSuccessNotification;

typedef void (^YCTChatUtilFail)(int code, NSString * msg);
typedef void (^YCTChatUtilSuccess)(void);

@interface YCTChatUtil : NSObject

YCT_SINGLETON_DEF

+ (void)loginSuccess:(YCTChatUtilSuccess)success fail:(YCTChatUtilFail)fail;

+ (void)logoutSuccess:(YCTChatUtilSuccess)success fail:(YCTChatUtilFail)fail;

+ (NSString *)wrappedImID:(NSString *)userId;

+ (NSString *)unwrappedImID:(NSString *)imId;

+ (NSString * _Nullable)unwrappedUserIdFromUrl:(NSString *)url;

+ (void)sendFollowMsg:(NSString *)nickName
            avatarUrl:(NSString *)avatarUrl
         followUserId:(NSString *)followUserId
               userId:(NSString *)userId
               remark:(NSString *)remark;

+ (void)sendVideoMsg:(NSString *)videoUrl
            thumbUrl:(NSString *)thumbUrl
             videoId:(NSString *)videoId
         videoUserId:(NSString *)videoUserId
       videoNickName:(NSString *)videoNickName
              userId:(NSString *)userId
              remark:(NSString *)remark;

@end

NS_ASSUME_NONNULL_END
