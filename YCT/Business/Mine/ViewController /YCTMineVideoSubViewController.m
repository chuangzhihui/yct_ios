//
//  YCTMineVideoSubViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/12.
//

#import "YCTMineVideoSubViewController.h"
#import "YCTBaseVideoListCell.h"
#import "YCTMyVideoListViewModel.h"
#import "UIScrollView+YCTEmptyView.h"
#import "YCTVideoDetailViewController.h"
#import "YCTPublishBottomView.h"
#import "YCTPublishViewController.h"
#import "YCTRootViewController.h"
#import "YCTApiDelVideo.h"
#import "UIDevice+Common.h"
#import "YCT-Swift.h"
#import "YCTBecomeCompanyViewController.h"


@interface YCTMineVideoSubViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) YCTMyVideoListType type;
@property (nonatomic, strong) YCTMyVideoListViewModel *viewModel;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation YCTMineVideoSubViewController

- (instancetype)initWithType:(YCTMyVideoListType)type {
    self = [super init];
    if (self) {
        self.type = type;
        self.viewModel = [[YCTMyVideoListViewModel alloc] initWithType:type];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    
    if (self.type == YCTMyVideoListTypeDraft) {
        @weakify(self);
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithActionBlock:^(UILongPressGestureRecognizer * _Nonnull sender) {
            @strongify(self);
            if (sender.state == UIGestureRecognizerStateBegan) {
                [UIDevice launchImpactFeedback];
                CGPoint p = [sender locationInView:self.collectionView];
                NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
                if (indexPath) {
                    [self deleteVideoAtIndex:indexPath];
                }
            }
        }];
        lpgr.minimumPressDuration = 0.5;
        lpgr.delaysTouchesBegan = YES;
        [self.collectionView addGestureRecognizer:lpgr];
    }
    
    self.collectionView.contentOffset = CGPointMake(-kCollectionInset, -21);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void)bindViewModel {
    @weakify(self);
    
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
    
    [self.viewModel.netWorkErrorSubject subscribeNext:^(NSString * _Nullable x) {
        [[YCTHud sharedInstance] showDetailToastHud:x];
    }];
    
    [self.viewModel.loadAllDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
}

- (void)setupView {
    self.collectionView.emptyView.emptyButton.hidden = YES;
    NSString *info;
    switch (self.type) {
        case YCTMyVideoListTypeWorks: {
            self.collectionView.emptyView.emptyButton.hidden = NO;
            [self.collectionView.emptyView.emptyButton setTitle:YCTLocalizedTableString(@"mine.empty.works.action", @"Mine") forState:(UIControlStateNormal)];
            [[self.collectionView.emptyView.emptyButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
                YCTPublishBottomView * bottomView = [YCTPublishBottomView new];
                bottomView.onButtonClick = ^{
                    [self pushSwiftViewController];
                };
                
                bottomView.moveToProfileAdd = ^{
                    [self pushToBecomeCompany];
                };
                [bottomView yct_show];
            }];
            info = YCTLocalizedString(@"empty.works");
        }
            break;
        case YCTMyVideoListTypeAudit:
            info = YCTLocalizedString(@"empty.works");
            break;
        case YCTMyVideoListTypeLikes:
            info = YCTLocalizedString(@"empty.likes");
            break;
        case YCTMyVideoListTypeCollection:
            info = YCTLocalizedString(@"empty.collection");
            break;
        case YCTMyVideoListTypeDraft:
            info = YCTLocalizedString(@"empty.draft");
            break;
    }
    [self.collectionView setEmptyImage:[UIImage imageNamed:@"empty_myVideo"] emptyInfo:info];
}

- (void)pushToBecomeCompany {
    NSLog(@"Push to Become Company");
    YCTBecomeCompanyViewController * vc =  [YCTBecomeCompanyViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushSwiftViewController {
    NSLog(@"Button pressed");
    
    // Get the topmost view controller
    UIViewController *topViewController = [self topViewController];
    
    // Check if the top view controller is in a UINavigationController
    UINavigationController *navigationController = nil;
    if ([topViewController isKindOfClass:[UINavigationController class]]) {
        navigationController = (UINavigationController *)topViewController;
    } else if ([topViewController.navigationController isKindOfClass:[UINavigationController class]]) {
        navigationController = topViewController.navigationController;
    }
    
    if (navigationController) {
        // Load the storyboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AIChatBot" bundle:nil];
        
        // Instantiate the ChatBotViewController from the storyboard
        GenerateVideoViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"GenerateVideoViewController"];
        
        // Configure the view controller
        vc.hidesBottomBarWhenPushed = YES;
        
        // Push the new view controller onto the navigation stack
        [navigationController pushViewController:vc animated:YES];
    } else {
        NSLog(@"Error: Top view controller is not embedded in a UINavigationController.");
    }
}

// Helper method to get the topmost view controller
- (UIViewController *)topViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topController = rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}

- (void)deleteVideoAtIndex:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.viewModel.models.count) {
        return;
    }
    YCTVideoModel *model = self.viewModel.models[indexPath.row];
    [UIView showAlertSheetWith:YCTLocalizedTableString(@"mine.alert.deleteVideo", @"Mine") clickAction:^{
        [[YCTHud sharedInstance] showLoadingHud];
        [[[YCTApiDelVideo alloc] initWithVideoId:model.id] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [[YCTHud sharedInstance] hideHud];
            [self.viewModel resetRequestData];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [[YCTHud sharedInstance] hideHud];
        }];
    }];
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
    if (self.type == YCTMyVideoListTypeWorks) {
        YCTVideoDetailViewController * vc = [[YCTVideoDetailViewController alloc] initWithVideos:self.viewModel.models index:indexPath.row type:YCTVideoDetailTypeMine];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.type == YCTMyVideoListTypeAudit){
        YCTVideoDetailViewController * vc = [[YCTVideoDetailViewController alloc] initWithVideos:self.viewModel.models index:indexPath.row type:YCTVideoDetailTypeAudit];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.type == YCTMyVideoListTypeDraft){
        YCTVideoModel * model = self.viewModel.models[indexPath.row];
        [YCTPublishViewController publishDraftWithVideoId:[model.id integerValue]];
    }else{
        YCTVideoDetailViewController * vc = [[YCTVideoDetailViewController alloc] initWithVideos:self.viewModel.models index:indexPath.row type:YCTVideoDetailTypeOther];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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

- (void)listDidAppear {
    [self.viewModel resetRequestData];
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
