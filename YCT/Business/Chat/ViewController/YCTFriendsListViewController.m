//
//  YCTFriendsListViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/22.
//

#import "YCTFriendsListViewController.h"
#import "TUIDefine.h"
#import "YCTSearchView.h"
#import "TUISearchViewController.h"
#import "YCTCommonContactCell.h"
#import "YCTChatUIDefine.h"
#import "YCTFriendsViewModel.h"
#import "TUIChatConversationModel.h"
#import "YCTChatViewController.h"
#import "YCTAddFriendsViewController.h"
#import "YCTOtherPeopleHomeViewController.h"

#define kContactCellReuseId @"ContactCellReuseId"

@interface YCTFriendsListViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) YCTSearchView *searchView;
@property (nonatomic, strong) YCTFriendsViewModel *viewModel;

@end

@implementation YCTFriendsListViewController

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewModel = [[YCTFriendsViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
    [_tableView registerClass:[YCTCommonContactCell class] forCellReuseIdentifier:kContactCellReuseId];
    @weakify(self);
    _tableView.mj_footer = [YCTRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel requestData];
    }];
    _tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel resetRequestData];
    }];
    [self.view addSubview:_tableView];
    
    _searchView = [[YCTSearchView alloc] init];
    _searchView.textField.delegate = self;
    _searchView.frame = CGRectMake(15, 20, self.view.bounds.size.width - 15 * 2, 40);
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:_searchView];
    headerView.backgroundColor = UIColor.whiteColor;
    headerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 62);
    _tableView.tableHeaderView = headerView;

    [self bindViewModel];
}

- (void)bindViewModel {
    @weakify(self);
    
    RAC(self.tableView.mj_footer, hidden) = [RACObserve(self.viewModel, models) map:^id _Nullable(NSArray * _Nullable value) {
        return @(value.count == 0);
    }];
    
    [self.viewModel.hasMoreDataSubject subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (x.boolValue) {
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
    [self.viewModel.loadAllDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.viewModel resetRequestData];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTCommonContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kContactCellReuseId forIndexPath:indexPath];
    [cell fillWithData:self.viewModel.models[indexPath.row]];
    
    @weakify(self);
    cell.clickMessageBlock = ^(YCTChatFriendModel * _Nonnull model) {
        @strongify(self);
        [self onSelectMessage:model];
    };
    cell.clickAvatarBlock = ^(YCTChatFriendModel * _Nonnull model) {
        @strongify(self);
        YCTOtherPeopleHomeViewController *vc = [YCTOtherPeopleHomeViewController otherPeopleHomeWithUserId:model.userId];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        } 
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YCTConversationCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self showSearchVC];
    return NO;
}

#pragma mark - Private

- (void)showSearchVC {
//    TUISearchViewController *vc = [[TUISearchViewController alloc] init];
//    TUINavigationController *nav = [[TUINavigationController alloc] initWithRootViewController:(UIViewController *)vc];
//    nav.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self.parentViewController presentViewController:nav animated:NO completion:nil];
    
    YCTAddFriendsViewController *vc = [[YCTAddFriendsViewController alloc] init];
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark -

- (void)onSelectMessage:(YCTChatFriendModel *)model {
    [YCTChatViewController goToChatWithUserId:model.userId title:model.nickName from:self.navigationController];
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

@end

