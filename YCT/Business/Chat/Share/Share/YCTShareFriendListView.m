//
//  YCTShareFriendListView.m
//  YCT
//
//  Created by 木木木 on 2021/12/19.
//

#import "YCTShareFriendListView.h"
#import "YCTSearchView.h"
#import "YCTShareFriendsItemCell.h"
#import "YCTFriendsViewModel.h"

@interface YCTShareFriendListView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) YCTSearchView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YCTFriendsViewModel *viewModel;
@property (nonatomic, copy) void (^shareBlock)(YCTShareType shareType, YCTShareResultModel *resultModel);
@property (nonatomic, assign) BOOL isRequested;
@property (nonatomic, strong) NSMutableDictionary *sharedDic;

@end

@implementation YCTShareFriendListView

- (instancetype)initWithShareBlock:(void (^)(YCTShareType, YCTShareResultModel * _Nullable))shareBlock {
    self = [super init];
    if (self) {
        self.sharedDic = @{}.mutableCopy;
        self.isRequested = NO;
        self.shareBlock = shareBlock;
        [self setupViews];
        [self bindViewModel];
    }
    return self;
}

kDeallocDebugTest

- (void)bindViewModel {
    @weakify(self);
    
    [self.viewModel.loadingSubject subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (!x.boolValue) {
            [self hideHud];
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
    
    [self.viewModel.loadAllDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)setupViews {
    self.backgroundColor = UIColor.clearColor;
    UIView *topView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColor.whiteColor;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Iphone_Width, 20) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(20, 20)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, Iphone_Width, 20);
        maskLayer.path = maskPath.CGPath;
        view.layer.mask = maskLayer;
        view.layer.masksToBounds = YES;
        view;
    });
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    UIView *topGrayView = ({
        UIView *view = [[UIView alloc] init];
        view.layer.cornerRadius = 2;
        view.backgroundColor = UIColor.mainGrayTextColor;
        view;
    });
    [topView addSubview:topGrayView];
    [topGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(20);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(4);
    }];
    
    self.contentView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColor.whiteColor;
        view;
    });
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.top.mas_equalTo(topView.mas_bottom);
    }];
    
    self.searchView = ({
        YCTSearchView *view = [[YCTSearchView alloc] init];
        view.textField.placeholder = YCTLocalizedTableString(@"chat.search.placeholder", @"Chat");
        view;
    });
    [self.contentView addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
    }];
    
    self.tableView = ({
        UITableView *view = [[UITableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStylePlain)];
        view.backgroundColor = UIColor.whiteColor;
        view.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        view.tableFooterView = [UIView new];
        view.delegate = self;
        view.dataSource = self;
        @weakify(self);
        view.mj_footer = [YCTRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestData];
        }];
        [view registerClass:YCTShareFriendsItemCell.class forCellReuseIdentifier:YCTShareFriendsItemCell.cellReuseIdentifier];
        view;
    });
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchView.mas_bottom).mas_offset(15);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow) {
        if (!self.isRequested) {
            self.isRequested = YES;
            [self showLoadingHud];
            [self.viewModel requestData];
        }
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTShareFriendsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTShareFriendsItemCell.cellReuseIdentifier forIndexPath:indexPath];
    YCTChatFriendModel *model = self.viewModel.models[indexPath.row];
    cell.nameLabel.text = model.nickName;
    [cell.avatarImageView loadImageGraduallyWithURL:[NSURL URLWithString:model.avatar] placeholderImageName:kDefaultAvatarImageName];
    
    if (model.userId && self.sharedDic[model.userId]) {
        cell.shareButton.selected = YES;
        cell.shareButton.backgroundColor = UIColor.selectedButtonBgColor;
    } else {
        cell.shareButton.selected = NO;
        cell.shareButton.backgroundColor = UIColor.mainThemeColor;
    }
    
    @weakify(self, cell);
    [[[cell.shareButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self, cell);
        cell.shareButton.selected = YES;
        cell.shareButton.backgroundColor = UIColor.selectedButtonBgColor;
        if (model.userId) {
            [self.sharedDic setValue:@(YES) forKey:model.userId];
            !self.shareBlock ?: self.shareBlock(YCTShareUser, ({
                YCTShareResultModel *resultModel = [[YCTShareResultModel alloc] init];
                resultModel.userIds = @[model.userId];
                resultModel;
            }));
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62;
}

- (YCTFriendsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[YCTFriendsViewModel alloc] init];
    }
    return _viewModel;
}

@end
