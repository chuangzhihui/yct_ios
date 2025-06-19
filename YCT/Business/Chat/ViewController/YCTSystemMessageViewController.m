//
//  YCTSystemMessageViewController1.m
//  YCT
//
//  Created by 木木木 on 2021/12/29.
//

#import "YCTSystemMessageViewController.h"
#import "YCTSystemMsgViewModel.h"
#import "YCTSystemMessageCell.h"
#import "UIScrollView+YCTEmptyView.h"

@interface YCTSystemMessageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) YCTSystemMsgViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YCTSystemMessageViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewModel = [[YCTSystemMsgViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"chat.title.systemMsgs", @"Chat");
    [self requestSystemMsg];
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
            [self.tableView showEmptyViewWithImage:[UIImage imageNamed:@"empty_systemMsg"] emptyInfo:YCTLocalizedString(@"empty.systemMsg")];
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
        make.left.right.bottom.mas_equalTo(0);
    }];
}

#pragma mark - Private

- (void)requestSystemMsg {
    [[YCTHud sharedInstance] showLoadingHud];
    [self.viewModel resetRequestData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTSystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTSystemMessageCell.cellReuseIdentifier forIndexPath:indexPath];
    cell.model = self.viewModel.models[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel getCellHeightAtIndex:indexPath.row];
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.tableBackgroundColor;
        [_tableView setMj_insetT:15];
        [_tableView registerClass:YCTSystemMessageCell.class forCellReuseIdentifier:YCTSystemMessageCell.cellReuseIdentifier];
        @weakify(self);
        _tableView.mj_footer = [YCTRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestData];
        }];
    }
    return _tableView;
}

@end
