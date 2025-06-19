//
//  YCTOtherPeopleHomeSubViewController.m
//  YCT
//
//  Created by 木木木 on 2022/1/5.
//

#import "YCTOtherPeopleHomeSubViewController.h"
#import "YCTOtherPeopleVideoListViewModel.h"
#import "YCTBaseVideoListCell.h"
#import "UIScrollView+YCTEmptyView.h"
#import "YCTVideoDetailViewController.h"

@interface YCTOtherPeopleHomeSubViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, assign) BOOL isBlock;
@property (nonatomic, assign) YCTOthersVideoListType type;
@property (nonatomic, strong) YCTOtherPeopleVideoListViewModel *viewModel;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation YCTOtherPeopleHomeSubViewController

- (instancetype)initWithType:(YCTOthersVideoListType)type userId:(NSString *)userId isBlock:(BOOL)isBlock {
    self = [super init];
    if (self) {
        self.isBlock = isBlock;
        self.type = type;
        self.viewModel = [[YCTOtherPeopleVideoListViewModel alloc] initWithType:type userId:userId];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    if (self.isBlock) {
        [self.collectionView showEmptyViewWithImage:nil emptyInfo:YCTLocalizedTableString(@"others.alert.likesListBlock", @"Mine")];
    } else {
        [self setupView];
        [self.view showLoadingHud];
        [self.viewModel requestData];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void)bindViewModel {
    @weakify(self);
    
    [self.viewModel.loadingSubject subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (!x.boolValue) {
            [self.view hideHud];
        }
    }];
    
    [[[RACObserve(self.viewModel, models) skip:1] map:^id _Nullable(NSArray * _Nullable value) {
        return @(value.count == 0);
    }] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (x.boolValue) {
            [self.collectionView showEmptyView];
        } else {
            self.collectionView.backgroundView = nil;
        }
    }];
    
    RAC(self.collectionView.mj_footer, hidden) = [RACObserve(self.viewModel, models) map:^id _Nullable(NSArray * _Nullable value) {
        return @(value.count == 0);
    }];
    
    [self.viewModel.hasMoreDataSubject subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (x.boolValue) {
            [self.collectionView.mj_footer endRefreshing];
        } else {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
//    [self.viewModel.netWorkErrorSubject subscribeNext:^(NSString * _Nullable x) {
//        [[YCTHud sharedInstance] showDetailToastHud:x];
//    }];
    
    [self.viewModel.loadAllDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
}

- (void)setupView {
    NSString *info;
    switch (self.type) {
        case YCTOthersVideoListTypeWorks:
            info = YCTLocalizedString(@"empty.works");
            break;
        case YCTOthersVideoListTypeLikes:
            info = YCTLocalizedString(@"empty.likes");
            break;
    }
    [self.collectionView setEmptyImage:[UIImage imageNamed:@"empty_myVideo"] emptyInfo:info];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YCTBaseVideoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YCTBaseVideoListCell.cellReuseIdentifier forIndexPath:indexPath];
    [cell updateWithModel:self.viewModel.models[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YCTVideoDetailViewController *vc = [[YCTVideoDetailViewController alloc] initWithVideos:self.viewModel.models index:indexPath.row type:YCTVideoDetailTypeOther];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - JXPagerViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollCallback != nil) {
        self.scrollCallback(scrollView);
    }
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(kCollectionCellWidth, kCollectionCellHeight);
        flowLayout.minimumInteritemSpacing = kCollectionSpacing;
        flowLayout.minimumLineSpacing = kCollectionSpacing;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(21, kCollectionInset, 21, kCollectionInset);
        [_collectionView registerClass:YCTBaseVideoListCell.class forCellWithReuseIdentifier:YCTBaseVideoListCell.cellReuseIdentifier];
        @weakify(self);
        _collectionView.mj_footer = [YCTRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestData];
        }];
    }
    return _collectionView;
}

@end
