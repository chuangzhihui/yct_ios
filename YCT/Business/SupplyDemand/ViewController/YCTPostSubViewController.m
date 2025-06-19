//
//  YTCPostSubViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import "YCTPostSubViewController.h"
#import "YCTSupplyDemandListViewModel.h"
#import "YCTPostListCell.h"
#import "YCTPostDetailViewController.h"
#import "YCTPhotoBrowser.h"
#import "YCTOtherPeopleHomeViewController.h"

@interface YCTPostSubViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YCTSupplyDemandListViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation YCTPostSubViewController

- (instancetype)initWithType:(NSUInteger)type {
    self = [super init];
    if (self) {

        self.viewModel = [[YCTSupplyDemandListViewModel alloc] initWithType:type];
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
}

- (void)setupView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)reset {
    self.tableView.contentOffset = CGPointMake(0, -self.tableView.mj_insetT);
    [self.view showLoadingHud];
    [self.viewModel resetRequestData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTSupplyDemandItemModel *model = self.viewModel.models[indexPath.row];
    YCTPostListCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTPostListCell.cellReuseIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.goodstypeView.hidden = YES;
    [cell updateWithModel:model];
    @weakify(self);
    cell.imageClickBlock = ^(YCTPostListCell *cell, NSInteger index) {
        @strongify(self);
        [YCTPhotoBrowser showPhotoBrowerInVC:self photoCount:cell.model.imgs.count currentIndex:index photoConfig:^(NSUInteger idx, NSURL *__autoreleasing *photoUrl, UIImageView *__autoreleasing *sourceImageView) {
            *photoUrl = [NSURL URLWithString:cell.model.imgs[idx]];
            *sourceImageView = [cell.imagesView imageViewAtIndex:idx];
        }];
    };
    cell.avatarClickBlock = ^(YCTSupplyDemandItemModel *model) {
        @strongify(self);
        YCTOtherPeopleHomeViewController *vc = [YCTOtherPeopleHomeViewController otherPeopleHomeWithUserId:model.userId needGoMinePageIfNeeded:YES];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTPostDetailViewController *vc = [[YCTPostDetailViewController alloc] init];
    vc.model = self.viewModel.models[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = UIColor.tableBackgroundColor;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:YCTPostListCell.nib forCellReuseIdentifier:YCTPostListCell.cellReuseIdentifier];
        @weakify(self);
        _tableView.mj_footer = [YCTRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestData];
        }];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel resetRequestData];
        }];
    }
    return _tableView;
}

@end
