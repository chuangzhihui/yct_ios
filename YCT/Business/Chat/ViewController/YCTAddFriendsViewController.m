//
//  YCTAddFriendsViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/22.
//

#import "YCTAddFriendsViewController.h"
#import "YCTSearchView.h"
#import "YCTCommonFriendCell.h"
#import "YCTAddFriendsViewModel.h"
#import "YCTQRCodeScanViewController.h"
#import "YCTOtherPeopleHomeViewController.h"
#import "YCTChatUtil.h"

@interface YCTAddFriendsViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) YCTSearchView *searchView;
@property (nonatomic, strong) UIButton *scanButton;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) YCTAddFriendsViewModel *viewModel;

@end

@implementation YCTAddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"chat.title.addFriends", @"Chat");
    [self requestUser];
}

- (void)bindViewModel {
    @weakify(self);
    
    [self.viewModel.loadingSubject subscribeNext:^(NSNumber * _Nullable x) {
        if (!x.boolValue) {
            [[YCTHud sharedInstance] hideHud];
        }
    }];
    
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
    
//    [self.viewModel.netWorkErrorSubject subscribeNext:^(NSString * _Nullable x) {
//        [[YCTHud sharedInstance] showDetailToastHud:x];
//    }];
    
    [self.viewModel.loadAllDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)setupView {
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(20 + kNavigationBarHeight);
        make.height.mas_equalTo(40);
    }];
    
    [self.searchView addSubview:self.scanButton];
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-4);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.mas_equalTo(0);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchView.mas_bottom).mas_offset(10);
        make.left.bottom.right.mas_equalTo(0);
    }];
}

#pragma mark - Private

- (void)requestUser {
    [[YCTHud sharedInstance] showLoadingHud];
    [self.viewModel resetRequestData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTCommonFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTCommonFriendCell.cellReuseIdentifier forIndexPath:indexPath];
    YCTCommonUserModel *model = self.viewModel.models[indexPath.row];
    [cell setFollowHiddenState:model.userId];
    cell.vipImageView.hidden = !model.isauthentication;
    cell.titleLabel.text = model.nickName;
    cell.subLabel.text = [NSString stringWithFormat:@"%@%@", YCTLocalizedTableString(@"mine.IDTitle", @"Mine"), model.userTag];
    [cell.avatarView loadImageGraduallyWithURL:[NSURL URLWithString:model.avatar] placeholderImageName:kDefaultAvatarImageName];
    
    @weakify(cell);
    [[RACObserve(model, isFollow) takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(cell);
        cell.followButton.selected = x.boolValue;
        cell.followButton.backgroundColor = x.boolValue ? UIColor.selectedButtonBgColor : UIColor.mainThemeColor;
    }];
    
    [[[cell.followButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[YCTUserFollowHelper sharedInstance] handleFollowStateWithUser:model];
    }];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.viewModel.keywords.length != 0) {
        return nil;
    }
    
#define TEXT_TAG 111
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"Header"];
        headerView.backgroundView = ({
            UIView *view = [UIView new];
            view.backgroundColor = tableView.backgroundColor;
            view;
        });
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.tag = TEXT_TAG;
        textLabel.font = [UIFont PingFangSCBold:14];
        textLabel.textColor = UIColor.mainTextColor;
        textLabel.text = YCTLocalizedTableString(@"chat.friends.recommend", @"Chat");
        [headerView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(24);
            make.left.mas_equalTo(16);
        }];
    }

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.viewModel.keywords.length != 0) {
        return 0;
    }

    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTCommonUserModel *model = self.viewModel.models[indexPath.row];
    YCTOtherPeopleHomeViewController *vc = [YCTOtherPeopleHomeViewController otherPeopleHomeWithUserId:model.userId];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.scanButton.hidden = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.scanButton.hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.viewModel.keywords = textField.text;
    [self requestUser];
    return YES;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView *_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.tableFooterView = [UIView new];
            _tableView.backgroundColor = self.view.backgroundColor;
            _tableView.rowHeight = 60;
            _tableView.estimatedRowHeight = 60;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [_tableView registerClass:YCTCommonFriendCell.class forCellReuseIdentifier:YCTCommonFriendCell.cellReuseIdentifier];
            [_tableView setDismissOnClick];
            @weakify(self);
            _tableView.mj_footer = [YCTRefreshFooter footerWithRefreshingBlock:^{
                @strongify(self);
                [self.viewModel requestData];
            }];
            _tableView;
        });
    }
    return _tableView;
}

- (YCTSearchView *)searchView {
    if (!_searchView) {
        _searchView = ({
            YCTSearchView *searchView = [[YCTSearchView alloc] init];
            searchView.textField.delegate = self;
            searchView.textField.placeholder = YCTLocalizedTableString(@"chat.search.placeholder", @"Chat");
            searchView.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            searchView.textField.returnKeyType = UIReturnKeySearch;
            searchView;
        });
    }
    return _searchView;
}

- (UIButton *)scanButton {
    if (!_scanButton) {
        _scanButton = ({
            UIButton *view = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [view setImage:[UIImage imageNamed:@"chat_scan"] forState:(UIControlStateNormal)];
            @weakify(self);
            [[view rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                YCTQRCodeScanViewController *vc = [[YCTQRCodeScanViewController alloc] init];
                vc.scanResultBlock = ^(NSString *result) {
                    NSString *idStr = [YCTChatUtil unwrappedUserIdFromUrl:result];
                    if (!idStr) return;
                    
                    NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
                    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:YCTQRCodeScanViewController.class]) {
                            [vcs removeObject:obj];
                            *stop = YES;
                        }
                    }];
                    [vcs addObject:[YCTOtherPeopleHomeViewController otherPeopleHomeWithUserId:idStr]];
                    [self.navigationController setViewControllers:vcs.copy animated:YES];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }];
            view;
        });
    }
    return _scanButton;
}

- (YCTAddFriendsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[YCTAddFriendsViewModel alloc] init];
    }
    return _viewModel;
}

@end
