//
//  YCTBlacklistViewController.m
//  YCT
//
//  Created by 木木木 on 2022/1/9.
//

#import "YCTBlacklistViewController.h"
#import "YCTCommonFriendCell.h"
#import "YCTBlacklistViewModel.h"

@interface YCTBlacklistViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YCTBlacklistViewModel *viewModel;
@end

@implementation YCTBlacklistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"mine.title.blacklist", @"Mine");
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
    
    [self.viewModel.netWorkErrorSubject subscribeNext:^(NSString * _Nullable x) {
        [[YCTHud sharedInstance] showDetailToastHud:x];
    }];
    
    [self.viewModel.loadAllDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)setupView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.bottom.right.mas_equalTo(0);
    }];
}

#pragma mark - Private

- (void)requestUser {
    [[YCTHud sharedInstance] showLoadingHud];
    [self.viewModel resetRequestData];
}

- (void)requestBlockUser:(YCTBlacklistItemModel *)userModel {
    [[YCTHud sharedInstance] showLoadingHud];
    YCTHandleBlacklistType type = userModel.isBlack ? YCTHandleBlacklistTypeRemove : YCTHandleBlacklistTypeAdd;
    YCTApiHandleBlacklist *api = [[YCTApiHandleBlacklist alloc] initWithType:type userId:userModel.userId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        userModel.isBlack = !userModel.isBlack;
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTCommonFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTCommonFriendCell.cellReuseIdentifier forIndexPath:indexPath];
    YCTBlacklistItemModel *model = self.viewModel.models[indexPath.row];
    cell.titleLabel.text = model.nickName;
    cell.subLabel.text = [NSString stringWithFormat:@"%@%@", YCTLocalizedTableString(@"mine.IDTitle", @"Mine"), model.userTag];
    [cell.avatarView loadImageGraduallyWithURL:[NSURL URLWithString:model.avatar] placeholderImageName:kDefaultAvatarImageName];

    [cell.followButton setTitle:YCTLocalizedTableString(@"mine.privacy.block", @"Mine") forState:(UIControlStateNormal)];
    [cell.followButton setTitle:YCTLocalizedTableString(@"mine.privacy.unblock", @"Mine") forState:(UIControlStateSelected)];

    @weakify(self, cell);
    [[RACObserve(model, isBlack) takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(cell);
        cell.followButton.selected = x.boolValue;
        cell.followButton.backgroundColor = x.boolValue ? UIColor.selectedButtonBgColor : UIColor.mainThemeColor;
    }];

    [[[cell.followButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self requestBlockUser:model];
    }];
    return cell;
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

- (YCTBlacklistViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[YCTBlacklistViewModel alloc] init];
    }
    return _viewModel;
}

@end
