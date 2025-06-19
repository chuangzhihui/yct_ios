//
//  YCTChatViewController.h
//  YCT
//
//  Created by 木木木 on 2021/12/20.
//

#import "YCTBaseViewController.h"
#import "TUICommonModel.h"

@class TUIChatConversationModel;

NS_ASSUME_NONNULL_BEGIN

@interface YCTChatViewController : YCTBaseViewController

@property (nonatomic, strong) V2TIMMessage * _Nullable waitToSendMsg;

@property (nonatomic, strong, readonly) TUIChatConversationModel *conversationData;

- (void)sendMessage:(V2TIMMessage *)message;

+ (void)goToChatWithUserId:(NSString *)userId
                     title:(NSString * _Nullable)title
                      from:(UINavigationController *)navigationController;

+ (void)goToChatWithConversationData:(TUIChatConversationModel *)conversationData
                                from:(UINavigationController *)navigationController;

@end

NS_ASSUME_NONNULL_END
