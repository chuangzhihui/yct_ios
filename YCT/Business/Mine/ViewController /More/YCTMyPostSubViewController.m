//
//  YCTMyPostSubViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import "YCTMyPostSubViewController.h"
#import "YCTMyPostCell.h"
#import "UIScrollView+YCTEmptyView.h"
#import "YCTPostAddViewController.h"
#import "YCTApiUpdateGX.h"
#import "YCTPhotoBrowser.h"

@interface YCTMyPostSubViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) BOOL needRefresh;
@property (nonatomic, assign) NSUInteger type;
@property (nonatomic, strong) YCTMyGXListViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation YCTMyPostSubViewController

- (instancetype)initWithType:(NSUInteger)type {
    self = [super init];
    if (self) {
        self.type = type;
        self.viewModel = [[YCTMyGXListViewModel alloc] initWithType:type];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.tableBackgroundColor;
    
    [self.view showLoadingHud];
    [self.viewModel requestData];
}

- (void)bindViewModel {
    @weakify(self);
    
    RAC(self.tableView.mj_footer, hidden) = [RACObserve(self.viewModel, models) map:^id _Nullable(NSArray * _Nullable value) {
        return @(value.count == 0);
    }];
    
    [self.viewModel.loadingSubject subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (!x.boolValue) {
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            [self.view hideHud];
        }
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
        @strongify(self);
        [self.view showDetailToastHud:x];
    }];
    
    [self.viewModel.loadAllDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:YCTNotification_myPostRefresh object:nil] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id x) {
        @strongify(self);
        if (self.isShowing) {
            [self.tableView.mj_header beginRefreshing];
        } else {
            self.needRefresh = YES;
        }
    }];
}

- (void)setupView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.tableView setEmptyImage:[UIImage imageNamed:@"empty_myVideo"] emptyInfo:YCTLocalizedTableString(@"mine.empty.post", @"Mine")];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTMyPostCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTMyPostCell.cellReuseIdentifier];
    [cell updateWithModel:self.viewModel.models[indexPath.row]];
    @weakify(self);
    cell.imageClickBlock = ^(YCTMyPostCell *cell, NSInteger index) {
        @strongify(self);
        [YCTPhotoBrowser showPhotoBrowerInVC:self photoCount:cell.model.imgs.count currentIndex:index photoConfig:^(NSUInteger idx, NSURL *__autoreleasing *photoUrl, UIImageView *__autoreleasing *sourceImageView) {
            *photoUrl = [NSURL URLWithString:cell.model.imgs[idx]];
            *sourceImageView = [cell.imagesView imageViewAtIndex:idx];
        }];
    };
    return cell;
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
    self.isShowing = YES;
    
    if (self.needRefresh) {
        self.needRefresh = NO;
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)listDidDisappear {
    self.isShowing = NO;
}

#pragma mark - Event

- (void)responseChainWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:k_even_reEdit_click]) {
        YCTMyGXListModel *model = userInfo[@"model"];
        if (model) {
            YCTPostAddViewController *vc = [[YCTPostAddViewController alloc] initWithModel:model];
            vc.submitSuccessBlock = ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:YCTNotification_myPostRefresh object:nil];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([eventName isEqualToString:k_even_offshelf_click]) {
        YCTMyGXListModel *model = userInfo[@"model"];
        if (model) {
            YCTApiOffshelfGX *api = [[YCTApiOffshelfGX alloc] initWithGXId:model.identifier];
            [self.view showLoadingHud];
            [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                [self.view hideHud];
                [[NSNotificationCenter defaultCenter] postNotificationName:YCTNotification_myPostRefresh object:nil];
            } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
                [self.view showDetailToastHud:request.getError];
            }];
        }
    }
    else if ([eventName isEqualToString:k_even_delete_click]) {
        YCTMyGXListModel *model = userInfo[@"model"];
        if (model) {
            YCTApiDeleteGX *api = [[YCTApiDeleteGX alloc] initWithGXId:model.identifier];
            [self.view showLoadingHud];
            [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                [self.view hideHud];
                [[NSNotificationCenter defaultCenter] postNotificationName:YCTNotification_myPostRefresh object:nil];
            } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
                [self.view showDetailToastHud:request.getError];
            }];
        }
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44;
        _tableView.backgroundColor = UIColor.tableBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:YCTMyPostCell.nib forCellReuseIdentifier:YCTMyPostCell.cellReuseIdentifier];
        @weakify(self);
        _tableView.mj_footer = [YCTRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestData];
        }];
        _tableView.mj_header = [YCTRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel refreshRequestData];
        }];
    }
    return _tableView;
}

@end
