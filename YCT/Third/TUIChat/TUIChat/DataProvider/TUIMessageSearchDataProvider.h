//
//  TUIMessageSearchDataProvider.h
//  TXIMSDK_TUIKit_iOS
//
//  Created by kayev on 2021/7/8.
//

#import "TUIMessageDataProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface TUIMessageSearchDataProvider : TUIMessageDataProvider

@property (nonatomic) BOOL isOlderNoMoreMsg;
@property (nonatomic) BOOL isNewerNoMoreMsg;
@property (nonatomic) V2TIMMessage * _Nullable msgForOlderGet;
@property (nonatomic) V2TIMMessage * _Nullable msgForNewerGet;


/// 加载指定的历史消息
- (void)loadMessageWithSearchMsg:(V2TIMMessage *)searchMsg
                ConversationInfo:(TUIChatConversationModel *)conversation
                    SucceedBlock:(void (^)(BOOL isOlderNoMoreMsg, BOOL isNewerNoMoreMsg, NSArray<TUIMessageCellData *> *newMsgs))SucceedBlock
                       FailBlock:(V2TIMFail)FailBlock;

- (void)loadMessageWithIsRequestOlderMsg:(BOOL)orderType
                        ConversationInfo:(TUIChatConversationModel *)conversation
                            SucceedBlock:(void (^)(BOOL isOlderNoMoreMsg, BOOL isNewerNoMoreMsg, BOOL isFirstLoad, NSArray<TUIMessageCellData *> *newUIMsgs))SucceedBlock
                               FailBlock:(V2TIMFail)FailBlock;

- (void)removeAllSearchData;

- (void)findMessages:(NSArray<NSString *> *)msgIDs callback:(void(^)(BOOL success, NSString *desc, NSArray<V2TIMMessage *> *messages))callback;

@end

NS_ASSUME_NONNULL_END
