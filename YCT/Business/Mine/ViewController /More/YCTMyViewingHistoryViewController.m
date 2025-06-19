//
//  YCTMyViewingHistoryViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import "YCTMyViewingHistoryViewController.h"
#import "YCTBaseVideoListCell.h"
#import "YCTMyWatchHistoryViewModel.h"
#import "YCTVideoDetailViewController.h"

@interface YCTMyViewingHistoryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) YCTMyWatchHistoryViewModel *viewModel;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation YCTMyViewingHistoryViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewModel = [[YCTMyWatchHistoryViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = YCTLocalizedTableString(@"mine.title.viewHistory", @"Mine");
    [[YCTHud sharedInstance] showLoadingHud];
    [self.viewModel requestData];
}

- (void)bindViewModel {
    @weakify(self);
    
    RAC(self.collectionView.mj_footer, hidden) = [RACObserve(self.viewModel, models) map:^id _Nullable(NSArray * _Nullable value) {
        return @(value.count == 0);
    }];
    
    [self.viewModel.loadingSubject subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (!x.boolValue) {
            if (self.collectionView.mj_header.isRefreshing) {
                [self.collectionView.mj_header endRefreshing];
            }
            [[YCTHud sharedInstance] hideHud];
        } else {
            [[YCTHud sharedInstance] showLoadingHud];
        }
    }];
    
    [self.viewModel.hasMoreDataSubject subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (x.boolValue) {
            [self.collectionView.mj_footer endRefreshing];
        } else {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
    [self.viewModel.netWorkErrorSubject subscribeNext:^(NSString * _Nullable x) {
        [[YCTHud sharedInstance] showDetailToastHud:x];
    }];
    
    [self.viewModel.loadAllDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
}

- (void)setupView {
    UIBarButtonItem *cleanItem = [[UIBarButtonItem alloc] initWithTitle:YCTLocalizedTableString(@"mine.viewHistory.clear", @"Mine") style:(UIBarButtonItemStylePlain) target:self action:@selector(cleanViewingHistory)];
    [cleanItem setTitleTextAttributes:@{
        NSFontAttributeName: [UIFont PingFangSCMedium:16],
        NSForegroundColorAttributeName: UIColor.mainGrayTextColor
    } forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = cleanItem;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

#pragma mark - Private

- (void)cleanViewingHistory {
    [UIView showAlertSheetWith:YCTLocalizedTableString(@"mine.alert.viewHistory.clearAlert", @"Mine") clickAction:^{
        [self.viewModel requestClearHistory];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.models.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YCTBaseVideoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YCTBaseVideoListCell.cellReuseIdentifier forIndexPath:indexPath];
    [cell updateWithModel:self.viewModel.models[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YCTVideoDetailViewController *vc = [[YCTVideoDetailViewController alloc] initWithVideos:self.viewModel.models index:indexPath.row type:YCTVideoDetailTypeMine];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = ({
            UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
            layout.sectionInset = UIEdgeInsetsMake(kCollectionInset, kCollectionInset, kCollectionInset, kCollectionInset);
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            layout.minimumLineSpacing = kCollectionSpacing;
            layout.minimumInteritemSpacing = kCollectionSpacing;
            layout.itemSize = CGSizeMake(kCollectionCellWidth, kCollectionCellHeight);
            
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:layout];
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.alwaysBounceVertical = YES;
            collectionView.backgroundColor = UIColor.whiteColor;
            [collectionView registerClass:YCTBaseVideoListCell.class forCellWithReuseIdentifier:YCTBaseVideoListCell.cellReuseIdentifier];
            
            @weakify(self);
            collectionView.mj_footer = [YCTRefreshFooter footerWithRefreshingBlock:^{
                @strongify(self);
                [self.viewModel requestData];
            }];
            collectionView.mj_header = [YCTRefreshHeader headerWithRefreshingBlock:^{
                @strongify(self);
                [self.viewModel refreshRequestData];
            }];
            collectionView;
        });
    }
    return _collectionView;
}

@end
