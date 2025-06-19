//
//  YCTOtherPeopleFollowListViewController.m
//  YCT
//
//  Created by 木木木 on 2022/1/12.
//

#import "YCTOtherPeopleFollowListViewController.h"
#import "YCTCommonFriendCell.h"
#import "YCTOtherPeopleFollowListViewModel.h"
#import "UIScrollView+YCTEmptyView.h"

@interface YCTOtherPeopleFollowListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YCTOtherPeopleFollowListViewModel *viewModel;
@end

@implementation YCTOtherPeopleFollowListViewController

- (instancetype)initWithUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        self.userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"others.title.hisFollow", @"Mine");
    [self requestFans];
}

- (void)bindViewModel {
    @weakify(self);
    
    [self.viewModel.loadingSubject subscribeNext:^(NSNumber * _Nullable x) {
        if (!x.boolValue) {
            [[YCTHud sharedInstance] hideHud];
        }
    }];
    
    [[[RACObserve(self.viewModel, models) skip:1] map:^id _Nullable(NSArray * _Nullable value) {
        return @(value.count == 0);
    }] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (x.boolValue) {
            [self.tableView showEmptyViewWithImage:[UIImage imageNamed:@"empty_follow"] emptyInfo:YCTLocalizedString(@"empty.follow")];
        } else {
            self.tableView.backgroundView = nil;
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

- (void)requestFans {
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
    cell.subLabel.text = model.intro ?: @"";
    [cell.avatarView loadImageGraduallyWithURL:[NSURL URLWithString:model.avatar] placeholderImageName:kDefaultAvatarImageName];
    [cell.followButton setTitle:YCTLocalizedTableString(@"chat.cell.follow", @"Chat") forState:(UIControlStateNormal)];
    [cell.followButton setTitle:YCTLocalizedTableString(@"chat.cell.followed", @"Chat") forState:(UIControlStateSelected)];
    
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

- (YCTOtherPeopleFollowListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[YCTOtherPeopleFollowListViewModel alloc] initWithUserId:self.userId];
    }
    return _viewModel;
}

@end
