//
//  YCTConversationListController.h
//  YCT
//
//  Created by 木木木 on 2021/12/21.
//

#import <UIKit/UIKit.h>
#import "YCTConversationCell.h"
#import "TUIConversationListDataProvider.h"
#import "TUIDefine.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TUISearchType) {
    TUISearchTypeContact     = 0,    // 联系人搜索
    TUISearchTypeGroup       = 1,    // 群聊搜索
    TUISearchTypeChatHistory = 2     // 聊天记录搜索
};


@protocol YCTConversationListControllerListener <NSObject>
@optional

- (NSString *)getConversationDisplayString:(V2TIMConversation *)conversation;

- (void)conversationListController:(UIViewController *)conversationController didSelectConversation:(YCTConversationCell *)conversationCell;

- (void)didSelectInteractiveMsgs;

- (void)didSelectFansMsgs;

- (void)didSelectSystemNoticationMsgs;

@end

@interface YCTConversationListController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, weak) id<YCTConversationListControllerListener> delegate;

@property (nonatomic, strong) TUIConversationListDataProvider *dataProvider;

@end

NS_ASSUME_NONNULL_END
