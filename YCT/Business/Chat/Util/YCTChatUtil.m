//
//  YCTChatUtil.m
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import "YCTChatUtil.h"
#import "TUILogin.h"
#import "TUIMessageDataProvider.h"
#import "UIDevice+Common.h"
#import "YCTRootViewController.h"
#import "YCTChatViewController.h"

NSString *kYCTChatUtilUnreadMsgCountKey = @"kYCTChatUtilUnreadMsgCountKey";

NSString *kYCTChatUtilUnreadMsgChangedNotification = @"kYCTChatUtilUnreadMsgChangedNotification";
NSString *kYCTChatUtilLogoutSuccessNotification = @"kYCTChatUtilLogoutSuccessNotification";

@interface YCTChatUtil ()<V2TIMConversationListener>

@end

@implementation YCTChatUtil

YCT_SINGLETON_IMP

+ (void)loginSuccess:(YCTChatUtilSuccess)success fail:(YCTChatUtilFail)fail {
    [TUILogin login:[YCTUserDataManager sharedInstance].loginModel.IMName userSig:[YCTUserDataManager sharedInstance].loginModel.userSign succ:^{
        if (success) {
            success();
        }
        NSLog(@"-----> 登录成功");
        
        [[V2TIMManager sharedInstance] addConversationListener:[self sharedInstance]];
    } fail:^(int code, NSString *msg) {
        if (fail) {
            fail(code, msg);
        }
        NSLog(@"-----> 登录失败");
    }];
}

+ (void)logoutSuccess:(YCTChatUtilSuccess)success fail:(YCTChatUtilFail)fail {
    [TUILogin logout:^{
        if (success) {
            success();
        }
        [NSNotificationCenter.defaultCenter postNotificationName:kYCTChatUtilLogoutSuccessNotification object:nil];
        [[V2TIMManager sharedInstance] removeConversationListener:[self sharedInstance]];
    } fail:^(int code, NSString *msg) {
        if (fail) {
            fail(code, msg);
        }
        [NSNotificationCenter.defaultCenter postNotificationName:kYCTChatUtilLogoutSuccessNotification object:nil];
        [[V2TIMManager sharedInstance] removeConversationListener:[self sharedInstance]];
    }];
}

+ (NSString *)wrappedImID:(NSString *)userId {
    return [NSString stringWithFormat:@"user%@", userId];
}

+ (NSString *)unwrappedImID:(NSString *)imId {
    if ([imId hasPrefix:@"user"]) {
        imId = [imId stringByReplacingCharactersInRange:(NSRange){0, 4} withString:@""];
    }
    return imId;
}

+ (NSString *)unwrappedUserIdFromUrl:(NSString *)url {
    NSString *handledUrl = [url stringByReplacingOccurrencesOfString:@"#/" withString:@"/"];
    
    NSURL *URL = [NSURL URLWithString:handledUrl];
    if (!URL) return nil;
    
    __block NSString *idStr = nil;
    NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithURL:URL resolvingAgainstBaseURL:YES];
    [URLComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:@"id"]) {
            idStr = obj.value;
            *stop = YES;
        }
    }];
    return idStr;
}

+ (void)sendFollowMsg:(NSString *)nickName
            avatarUrl:(NSString *)avatarUrl
         followUserId:(NSString *)followUserId
               userId:(NSString *)userId
               remark:(NSString *)remark {
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setValue:@"bussiness_follow" forKey:BussinessID];
    [param setValue:nickName forKey:@"followUserName"];
    [param setValue:avatarUrl forKey:@"followAvatarUrl"];
    [param setValue:followUserId forKey:@"followUserId"];
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:0 error:&error];
    if (error) {
        NSLog(@"[%@] Post Json Error", [self class]);
        return;
    }
    V2TIMMessage *message = [[V2TIMManager sharedInstance] createCustomMessage:data];
    [self sendMsg:message userId:userId];
    
    if (remark.length > 0) {
        V2TIMMessage *message = [[V2TIMManager sharedInstance] createTextMessage:remark];
        [self sendMsg:message userId:userId];
    }
}

+ (void)sendVideoMsg:(NSString *)videoUrl
            thumbUrl:(NSString *)thumbUrl
             videoId:(NSString *)videoId
         videoUserId:(NSString *)videoUserId
       videoNickName:(NSString *)videoNickName
              userId:(NSString *)userId
              remark:(NSString *)remark {
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setValue:@"bussiness_Video" forKey:BussinessID];
    [param setValue:videoUrl forKey:@"videoUrl"];
    [param setValue:thumbUrl forKey:@"thumbUrl"];
    [param setValue:videoId forKey:@"videoid"];
    [param setValue:videoUserId forKey:@"userId"];
    [param setValue:videoNickName forKey:@"nickName"];
    [param setValue:remark forKey:@"remark"];
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:0 error:&error];
    if (error) {
        NSLog(@"[%@] Post Json Error", [self class]);
        return;
    }
    V2TIMMessage *message = [[V2TIMManager sharedInstance] createCustomMessage:data];
    [self sendMsg:message userId:userId];
    
    if (remark.length > 0) {
        V2TIMMessage *message = [[V2TIMManager sharedInstance] createTextMessage:remark];
        [self sendMsg:message userId:userId];
    }
}

+ (void)sendMsg:(V2TIMMessage *)message userId:(NSString *)userId {
    YCTRootViewController *rootVC = [YCTRootViewController sharedInstance];
    UINavigationController *vc = rootVC.viewControllers[rootVC.selectedIndex];

    __block YCTChatViewController *chatVC = nil;
    [vc.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:YCTChatViewController.class]) {
            chatVC = obj;
        }
    }];
    
    if (chatVC && [chatVC.conversationData.userID isEqualToString:[self wrappedImID:userId]]) {
        [chatVC sendMessage:message];
    } else {
        TUIChatConversationModel *conversationData = [[TUIChatConversationModel alloc] init];
        conversationData.userID = [self wrappedImID:userId];
        
        [TUIMessageDataProvider sendMessage:message toConversation:conversationData isSendPushInfo:YES isOnlineUserOnly:NO priority:V2TIM_PRIORITY_NORMAL Progress:NULL SuccBlock:^{
//            [UIDevice launchImpactFeedback];
        } FailBlock:NULL];
    }
}

#pragma mark - V2TIMConversationListener

- (void)onNewConversation:(NSArray<V2TIMConversation*> *) conversationList {
    [self updateConversation:conversationList];
}

- (void)onConversationChanged:(NSArray<V2TIMConversation*> *) conversationList {
    [self updateConversation:conversationList];
}

- (void)updateConversation:(NSArray *)convList {
    int unreadCount = 0;
    for (int i = 0 ; i < convList.count ; ++ i) {
        V2TIMConversation *conv = convList[i];
        unreadCount += conv.unreadCount;
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:kYCTChatUtilUnreadMsgChangedNotification object:@{kYCTChatUtilUnreadMsgCountKey: @(unreadCount)}];
}

@end
