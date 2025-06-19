//
//  YCTChatViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/20.
//

#import "YCTChatViewController.h"
#import "TUIBaseChatViewController.h"
#import "YCTChatMoreViewController.h"
#import "TUIDefine.h"
#import "YCTAttentionCell.h"
#import "YCTChatVideoCell.h"
#import "YCTOtherPeopleHomeViewController.h"
#import "YCTApiFollowUser.h"
#import "YCTVideoPlayViewController.h"
#import "YCTVideoDetailViewController.h"
#import "YCTApiVideoDetailById.h"

@interface YCTChatViewController ()<TUIChatControllerListener>
@property (nonatomic, strong) TUIBaseChatViewController *chatVC;
@property (nonatomic, strong, readwrite) TUIChatConversationModel *conversationData;
@end

@implementation YCTChatViewController

+ (void)goToChatWithConversationData:(TUIChatConversationModel *)conversationData from:(UINavigationController *)navigationController {
    NSMutableArray *vcs = navigationController.viewControllers.mutableCopy;
    YCTChatViewController *chatVC = nil;
    for (UIViewController *vc in vcs) {
        if ([vc isKindOfClass:YCTChatViewController.class]) {
            chatVC = (YCTChatViewController *)vc;
            break;
        }
    }
    if (chatVC && [chatVC.conversationData.userID isEqualToString:conversationData.userID]) {
        [vcs removeObject:chatVC];
        [vcs addObject:chatVC];
    } else {
        YCTChatViewController *vc = [[YCTChatViewController alloc] init];
        vc.conversationData = conversationData;
        [vcs addObject:vc];
    }
    [navigationController setViewControllers:vcs.copy animated:YES];
}

+ (void)goToChatWithUserId:(NSString *)userId
                     title:(NSString *)title
                      from:(UINavigationController *)navigationController {
    NSMutableArray *vcs = navigationController.viewControllers.mutableCopy;
    YCTChatViewController *chatVC = nil;
    for (UIViewController *vc in vcs) {
        if ([vc isKindOfClass:YCTChatViewController.class]) {
            chatVC = (YCTChatViewController *)vc;
            break;
        }
    }
    if (chatVC && [chatVC.conversationData.userID isEqualToString:userId]) {
        [vcs removeObject:chatVC];
        [vcs addObject:chatVC];
    } else {
        YCTChatViewController *vc = [[YCTChatViewController alloc] initWithUserId:userId title:title];
        [vcs addObject:vc];
    }
    [navigationController setViewControllers:vcs.copy animated:YES];
}

- (instancetype)initWithUserId:(NSString *)userId title:(nullable NSString *)title {
    self = [super init];
    if (self) {
        TUIChatConversationModel *conversationData = [[TUIChatConversationModel alloc] init];
        conversationData.userID = [YCTChatUtil wrappedImID:userId];
        conversationData.title = title;
        self.conversationData = conversationData;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [moreButton setImage:[[UIImage imageNamed:@"chat_more"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [moreButton.widthAnchor constraintEqualToConstant:22].active = YES;
    [moreButton.heightAnchor constraintEqualToConstant:22].active = YES;
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItem = moreItem;
    
    self.chatVC = [[TUIBaseChatViewController alloc] init];
    [self.chatVC setDelegate:self];
    [self.chatVC setConversationData:self.conversationData];
    [self addChildViewController:self.chatVC];
    [self.view addSubview:self.chatVC.view];
    
    RAC(self, title) = [RACObserve(_conversationData, title) distinctUntilChanged];
    [self checkTitle:YES];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onFriendInfoChanged:) name:@"FriendInfoChangedNotification" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.waitToSendMsg) {
        [self.chatVC sendMessage:self.waitToSendMsg];
        self.waitToSendMsg = nil;
    }
}

- (void)rightBarButtonClick:(id)sender {
    @weakify(self);
    [[V2TIMManager sharedInstance] getFriendsInfo:@[self.conversationData.userID] succ:^(NSArray<V2TIMFriendInfoResult *> *resultList) {
        @strongify(self);
        V2TIMFriendInfoResult *infoResult = resultList.firstObject;
        YCTChatMoreViewController *vc = [[YCTChatMoreViewController alloc] init];
        vc.friendProfile = infoResult.friendInfo;
        [self.navigationController pushViewController:vc animated:YES];
    } fail:^(int code, NSString *desc) {
        
    }];
}

- (void)onFriendInfoChanged:(NSNotification *)notice {
    [self checkTitle:YES];
}

- (void)checkTitle:(BOOL)force {
    if (force || self.conversationData.title.length == 0) {
        if (self.conversationData.userID.length > 0) {
            @weakify(self);
            [[V2TIMManager sharedInstance] getFriendsInfo:@[self.conversationData.userID] succ:^(NSArray<V2TIMFriendInfoResult *> *resultList) {
                @strongify(self);
                V2TIMFriendInfoResult *friendInfoResult = resultList.firstObject;
                
                if (friendInfoResult.relation & V2TIM_FRIEND_RELATION_TYPE_IN_MY_FRIEND_LIST
                    && friendInfoResult.friendInfo.friendRemark.length > 0) {
                    self.conversationData.title = friendInfoResult.friendInfo.friendRemark;
                } else {
                    [[V2TIMManager sharedInstance] getUsersInfo:@[self.conversationData.userID] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
                        V2TIMUserFullInfo *userInfo = infoList.firstObject;
                        if (userInfo.nickName.length > 0) {
                            self.conversationData.title = userInfo.nickName;
                        }
                    } fail:nil];
                }
            } fail:nil];
        }
    }
}

- (void)sendMessage:(V2TIMMessage *)message {
    [self.chatVC.messageController sendMessage:message];
}

#pragma mark - TUIChatControllerListener

- (void)chatController:(TUIBaseChatViewController *)controller onSelectMessageContent:(TUIMessageCell *)cell {
    if ([cell isKindOfClass:YCTAttentionCell.class]) {
        YCTAttentionCellData *data = ((YCTAttentionCell *)cell).customData;
        YCTOtherPeopleHomeViewController *vc = [YCTOtherPeopleHomeViewController otherPeopleHomeWithUserId:data.followUserId];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cell isKindOfClass:YCTChatVideoCell.class]) {
        
        YCTChatVideoCellData *data = ((YCTChatVideoCell *)cell).customData;
        
        //#import "YCTApiVideoDetailById.h"
        
        [[YCTHud sharedInstance] showLoadingHud];
        [[[YCTApiVideoDetailById alloc] initWithVideoId:data.videoId] startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
            if (YCT_IS_ARRAY(request.responseDataModel)) {
                [[YCTHud sharedInstance] hideHud];
                YCTVideoDetailViewController *vc = [[YCTVideoDetailViewController alloc] initWithVideos:request.responseDataModel index:0 type:(YCTVideoDetailTypeOther)];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [[YCTHud sharedInstance] showToastHud:YCTLocalizedString(@"request.error")];
            }
            
        } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
            [[YCTHud sharedInstance] showToastHud:request.getError];
        }];
        
//        YCTVideoPlayViewController *vc = [[YCTVideoPlayViewController alloc] init];
//        vc.videoUrl = [NSURL URLWithString:data.videoUrl];
//        vc.thumbUrl = [NSURL URLWithString:data.thumbUrl];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Event

- (void)responseChainWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:k_even_followCell_click]) {
        NSString *userId = userInfo[@"userId"];
        if (userId.length == 0) {
            return;
        }
        YCTApiFollowUser *api = [YCTApiFollowUser new];
        [[YCTHud sharedInstance] showLoadingHud];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [[YCTHud sharedInstance] hideHud];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [[YCTHud sharedInstance] hideHud];
        }];
    }
}

@end
