//
//  YCTChatListViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/20.
//

#import "YCTChatListViewController.h"
#import "YCTConversationContainerViewController.h"
#import "YCTFriendsListViewController.h"
#import "YCTAddFriendsViewController.h"

#import "TUIChatConversationModel.h"
#import "YTCCategoryNavigationTitleView.h"
#import "YCTUserManager.h"
#import "YCTLiveViewController.h"

@interface YCTChatListViewController ()<JXCategoryListContainerViewDelegate> {
    BOOL _isLoaded;
}

@property (strong, nonatomic) JXCategoryListContainerView *listView;

@property (strong, nonatomic) YCTConversationContainerViewController *conversationVC;
@property (strong, nonatomic) YCTFriendsListViewController *friendsVC;
@property (strong, nonatomic) YCTLiveViewController *liveVc;

@end

@implementation YCTChatListViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _isLoaded = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [YCTChatUtil loginSuccess:^{
        [self setupViews];
    } fail:^(int code, NSString * _Nonnull msg) {
        
    }];
};

#pragma mark - Private

- (void)setupNavigationBar {
    YTCCategoryNavigationTitleView *titleView = [[YTCCategoryNavigationTitleView alloc] init];
    titleView.titleView.listContainer = self.listView;
    titleView.titleView.titles = @[
        YCTLocalizedString(@"tabNews"),
        YCTLocalizedTableString(@"chat.main.news", @"Chat"),
        YCTLocalizedTableString(@"chat.main.friends", @"Chat"),];
    self.navigationItem.titleView = titleView;
    self.navigationItem.leftBarButtonItems = nil;
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [addButton setImage:[[UIImage imageNamed:@"chat_addFriend"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [addButton.widthAnchor constraintEqualToConstant:20].active = YES;
    [addButton.heightAnchor constraintEqualToConstant:20].active = YES;
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = addItem;
}

- (void)setupViews {
    if (_isLoaded) {
        return;
    }
    
    _isLoaded = YES;
    
    [self setupNavigationBar];
    
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Action

- (void)rightBarButtonClick:(UIButton *)sender {
    YCTAddFriendsViewController *vc = [[YCTAddFriendsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - JXCategoryListContainerViewDelegate

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 3;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if(index==0){
        return self.liveVc;
    }else if (index == 1) {
        return self.conversationVC;
    } else {
        return self.friendsVC;
    }
}

#pragma mark - Getter

- (JXCategoryListContainerView *)listView {
    if (!_listView) {
        _listView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _listView.contentScrollView.scrollEnabled = NO;
    }
    return _listView;
}

- (YCTConversationContainerViewController *)conversationVC {
    if (!_conversationVC) {
        _conversationVC = [[YCTConversationContainerViewController alloc] init];
    }
    return _conversationVC;
}

- (YCTFriendsListViewController *)friendsVC {
    if (!_friendsVC) {
        _friendsVC = [[YCTFriendsListViewController alloc] init];
    }
    return _friendsVC;
}
- (YCTLiveViewController *)liveVc {
    if (!_liveVc) {
        _liveVc = [[YCTLiveViewController alloc] init];
    }
    return _liveVc;
}
@end
