//
//  YCTMyFollowViewController.m
//  YCT
//
//  Created by 木木木 on 2022/1/16.
//

#import "YCTMyFollowViewController.h"
#import "YCTCommonFriendCell.h"
#import "YCTMyFollowViewModel.h"
#import "YCTUserFollowHelper.h"
#import "UIScrollView+YCTEmptyView.h"
#import "YCTOtherPeopleHomeViewController.h"

@interface YCTMyFollowViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YCTMyFollowViewModel *viewModel;
@end

@implementation YCTMyFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"chat.title.follow", @"Chat");
    [self requestFollow];
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

- (void)requestFollow {
    [[YCTHud sharedInstance] showLoadingHud];
    [self.viewModel resetRequestData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.models.count;
}

/*
 !isMutual isFollow 已关注
 isMutual isFollow 互相关注
 isMutual !isFollow 回关
 !isMutual !isFollow 关注
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTCommonFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTCommonFriendCell.cellReuseIdentifier forIndexPath:indexPath];
    YCTCommonUserModel *model = self.viewModel.models[indexPath.row];
    [cell setFollowHiddenState:model.userId];
    cell.vipImageView.hidden = !model.isauthentication;
    cell.titleLabel.text = model.nickName;
    cell.subLabel.text = model.userTag;
    [cell.avatarView loadImageGraduallyWithURL:[NSURL URLWithString:model.avatar] placeholderImageName:kDefaultAvatarImageName];
    
    if (model.isMutual) {
        [cell.followButton setTitle:YCTLocalizedTableString(@"chat.cell.refollow", @"Chat") forState:(UIControlStateNormal)];
        [cell.followButton setTitle:YCTLocalizedTableString(@"chat.cell.mutualFollow", @"Chat") forState:(UIControlStateSelected)];
    } else {
        [cell.followButton setTitle:YCTLocalizedTableString(@"chat.cell.follow", @"Chat") forState:(UIControlStateNormal)];
        [cell.followButton setTitle:YCTLocalizedTableString(@"chat.cell.followed", @"Chat") forState:(UIControlStateSelected)];
    }
    
    @weakify(cell, self);
    [[RACObserve(model, isFollow) takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(cell);
        cell.followButton.selected = x.boolValue;
        cell.followButton.backgroundColor = x.boolValue ? UIColor.selectedButtonBgColor : UIColor.mainThemeColor;
    }];
    
    [[[cell.followButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[YCTUserFollowHelper sharedInstance] handleFollowStateWithUser:model];
    }];
    
    cell.avatarClickBlock = ^{
        @strongify(self);
        YCTOtherPeopleHomeViewController *vc = [YCTOtherPeopleHomeViewController otherPeopleHomeWithUserId:model.userId];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
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

- (YCTMyFollowViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[YCTMyFollowViewModel alloc] init];
    }
    return _viewModel;
}

@end
