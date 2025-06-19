//
//  YCTConversationContainerViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/21.
//

#import "YCTConversationContainerViewController.h"
#import "YCTConversationListController.h"
#import "YCTChatViewController.h"
#import "YCTSystemMessageViewController.h"
#import "YCTFansViewController.h"
#import "YCTInteractiveMsgViewController.h"

#import "TUIDefine.h"
#import "TUITool.h"
#import "TUIContactSelectController.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "TUIChatConversationModel.h"
#import "TUIKit.h"
#import "TCUtil.h"

@interface YCTConversationContainerViewController ()<YCTConversationListControllerListener>

@end

@implementation YCTConversationContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    YCTConversationListController *conv = [[YCTConversationListController alloc] init];
    conv.delegate = self;
    [self addChildViewController:conv];
    [self.view addSubview:conv.view];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onFriendInfoChanged:) name:@"FriendInfoChangedNotification" object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)onFriendInfoChanged:(NSNotification *)notice {
    V2TIMFriendInfo *friendInfo = notice.object;
    if (friendInfo == nil) {
        return;
    }
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:YCTConversationListController.class]) {
            // 此处需要优化，目前修改备注通知均是demo层发出来的，所以.....
            TUIConversationListDataProvider *dataProvider = [(YCTConversationListController *)vc dataProvider];
            for (TUIConversationCellData *cellData in dataProvider.dataList) {
                if ([cellData.userID isEqualToString:friendInfo.userID]) {
                    NSString *title = friendInfo.friendRemark;
                    if (title.length == 0) {
                        title = friendInfo.userFullInfo.nickName;
                    }
                    if (title.length == 0) {
                        title = friendInfo.userID;
                    }
                    cellData.title = title;
                    [[(YCTConversationListController *)vc tableView] reloadData];
                    break;
                }
            }
            break;
        }
    }
}

#pragma mark - YCTConversationListControllerListener

- (void)conversationListController:(YCTConversationListController *)conversationController didSelectConversation:(YCTConversationCell *)conversationCell {
    [YCTChatViewController goToChatWithConversationData:[self getConversationModel:conversationCell.convData] from:self.navigationController];
}

- (void)didSelectInteractiveMsgs {
    YCTInteractiveMsgViewController *vc = [[YCTInteractiveMsgViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didSelectFansMsgs {
    YCTFansViewController *vc = [[YCTFansViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didSelectSystemNoticationMsgs {
    YCTSystemMessageViewController *vc = [[YCTSystemMessageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (TUIChatConversationModel *)getConversationModel:(TUIConversationCellData *)data {
    TUIChatConversationModel *model = [[TUIChatConversationModel alloc] init];
    model.conversationID = data.conversationID;
    model.userID = data.userID;
    model.groupType = data.groupType;
    model.groupID = data.groupID;
    model.userID = data.userID;
    model.title = data.title;
    model.faceUrl = data.faceUrl;
    model.avatarImage = data.avatarImage;
    model.draftText = data.draftText;
    return model;
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

@end
