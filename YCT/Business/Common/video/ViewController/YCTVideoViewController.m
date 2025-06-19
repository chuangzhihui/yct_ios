//
//  YCTHomeVideoViewController.m
//  YCT
//
//  Created by hua-cloud on 2021/12/12.
//

#import "YCTVideoViewController.h"
#import "YCTVideoTableCell.h"
#import "YCTVideoViewModel.h"
#import "YCTCommentViewController.h"
#import "YCTDragPresentView.h"
#import "YCTRefreshHeader.h"
#import "YCTOtherPeopleHomeViewController.h"
#import <TXLiteAVSDK_UGC/TXLiteAVSDK.h>
#import "YCTVideoFullScreenVC.h"
#import "DraggableView.h"
@interface YCTVideoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) YCTVideoViewModel * viewModel;
@property (nonatomic, strong) YCTVideoTableCell * currentCell;
@property (nonatomic, assign) NSInteger defaultIndex;
@property (nonatomic, assign) YCTVideoType type;
@end

@implementation YCTVideoViewController

- (instancetype)initWithVideoModels:(NSArray<YCTVideoModel *> *)videoModels
                              index:(NSInteger)index
                               type:(YCTVideoType)type{
    self = [super init];
    if (self) {
        self.type = type;
        self.defaultIndex = index;
        [self updateModels:videoModels refresh:NO];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    
    // Create and add the draggable view
    DraggableView *draggable = [[DraggableView alloc] initWithFrame:CGRectMake(0, 100, 140, 140) showLabelAndBackground:YES];
    draggable.hidden = true;
    draggable.onChatBotViewControllerAppearing = ^{
        [self callTapGestureOnVisibleCell];
    };
    
    [self.view addSubview:draggable];
}



- (void)callTapGestureOnVisibleCell {
    // Get the visible cell (since there's only one, it should be the only visible cell)
    YCTVideoTableCell *visibleCell = (YCTVideoTableCell *)[self.tableView visibleCells].firstObject;
    if (visibleCell) {
        // Call the public method on the visible cell
        [visibleCell triggerForStopPlaying];
    }
}

- (void)releasePlayer{
    [self.viewModel releasePlayer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self onWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self onWillDisappear];
}

- (void)onWillAppear{
    [self.viewModel onWillAppear];
}

- (void)onWillDisappear{
    [self.viewModel onWilldisappear];
}


- (void)setupView{
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kStatusBarHeight, 0, 0, 0));
    }];
}


- (void)bindViewModel{
    @weakify(self);
    [RACObserve(self.viewModel, cellModels) subscribeNext:^(NSArray * x) {
        @strongify(self);
        [self.tableView reloadData];
        ///第一次刷新完成之后配置初始index逻辑
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.viewModel.currentIndex < 0 && YCTArray(x, @[]).count > 0) {
                [self.tableView setContentOffset:CGPointMake(0, 0)];
                if (self.defaultIndex > 0) [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:MIN(x.count - 1, self.defaultIndex) inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                self.viewModel.currentIndex = self.defaultIndex;
            }
        });
    }];
    
    RAC(self, currentCell) = [RACObserve(self.viewModel, currentIndex) map:^id _Nullable(id  _Nullable value) {
        @strongify(self);
        return [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[value integerValue] inSection:0]];
    }];
    
    [self.viewModel.playSubject subscribeNext:^(YCTVodPlayerModel *  _Nullable x) {
        @strongify(self);
        TXVodPlayer * player = x.player;
        [player setupVideoWidget:self.currentCell.videoContainerView insertIndex:0];
    }];
    
}

#pragma mark - public
- (void)handlerWhenIndexChange:(void (^)(NSInteger))handler{
    [RACObserve(self.viewModel, currentIndex) subscribeNext:^(id  _Nullable x) {
        !handler ? : handler([x integerValue]);
    }];
}

- (void)handleWithHeaderRefershCallback:(dispatch_block_t)callBack{
    self.tableView.mj_header = [YCTRefreshHeader headerWithRefreshingBlock:^{
        !callBack ? : callBack();
    }];
}

- (void)handleWithFooerRefershCallback:(dispatch_block_t)callBack{
    self.tableView.mj_footer = [YCTRefreshFooter footerWithRefreshingBlock:^{
        !callBack ? : callBack();
    }];
}

- (void)endRefreshWithHasMore:(BOOL)hasMore{
//    if(self.tableView.mj_header.isRefreshing)
        [self.tableView.mj_header endRefreshing];
//    if(self.tableView.mj_footer.isRefreshing)
        [self.tableView.mj_footer endRefreshing];
//    if (!hasMore) self.tableView.mj_footer = nil;
}

- (void)updateModels:(NSArray<YCTVideoModel *> *)models refresh:(BOOL)refresh{
    [self.viewModel updateModels:models refresh:refresh];
}


#pragma mark - even
- (void)responseChainWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:k_even_comment_click]) {
        YCTVideoCellViewModel * vm = userInfo[@"vm"];
        YCTCommentViewController * comment = [[YCTCommentViewController alloc] initWithVideoId:userInfo[@"video_id"] commentCount:[userInfo[@"comment_count"] integerValue]];
        [comment setCommentCountCallback:^(NSInteger num) {
            vm.commentCount = [NSString stringWithFormat:@"%ld",num];
        }];
        [comment setOnGoUser:^(NSString * _Nonnull userId) {
            YCTOtherPeopleHomeViewController * vc = [YCTOtherPeopleHomeViewController otherPeopleHomeWithUserId:userId needGoMinePageIfNeeded:YES];
            if (vc) {
                [[UIViewController currentNavigationViewController] pushViewController:vc animated:YES];
            }
        }];
        [[YCTDragPresentView sharePresentView] showViewController:comment configMaker:^(YCTDragPresentConfig * _Nonnull config) {
            config.ignoreViewHeight = NO;
            config.viewHeight = Iphone_Height / 812 * 550;
        }];
    }else if([eventName isEqualToString:k_even_avatar_click]){
        NSString * userid = userInfo[@"user_id"];
        YCTOtherPeopleHomeViewController * vc = [YCTOtherPeopleHomeViewController otherPeopleHomeWithUserId:userid needGoMinePageIfNeeded:YES];
        if (vc) {
            [[UIViewController currentNavigationViewController] pushViewController:vc animated:YES];
        }
    }else if ([eventName isEqualToString:k_even_video_delete]){
        [[UIViewController currentNavigationViewController] popViewControllerAnimated:YES];
    }else if ([eventName isEqualToString:k_even_video_fullScreen]){
        YCTVideoCellViewModel * vm = userInfo[@"vm"];
        YCTVideoFullScreenVC *vc = [YCTVideoFullScreenVC.alloc init];
            @weakify(self);
            [self presentViewController:vc animated:YES completion:^{
                [self onWillDisappear];
                SJVideoPlayerURLAsset *asset = [SJVideoPlayerURLAsset.alloc initWithURL:[NSURL URLWithString:vm.videoUrl] startPosition:vm.playProgress];
                vc.player.URLAsset = asset;
            }];
            
        [vc setDismissCallBack:^(NSTimeInterval currentTime) {
            @strongify(self);
            [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:self.currentCell] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            [vm hanldeToSeekWithValue:currentTime];
        }];
    }
}

#pragma tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.cellModels.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //填充视频数据
    YCTVideoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTVideoTableCell.cellReuseIdentifier forIndexPath:indexPath];
    cell.type = self.type;
    
    [cell cellPrepareDisplayWithViewModel:self.viewModel.cellModels[indexPath.row]];
    return cell;
}



#pragma ScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        NSInteger endIndex = self.viewModel.currentIndex;
        YCTVideoTableCell * endCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:endIndex inSection:0]];
        [endCell contentTransformWhenEndDragging];
        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];

        if(translatedPoint.y < -100 && self.viewModel.currentIndex < (self.viewModel.cellModels.count - 1)) {
            self.viewModel.currentIndex ++;   //向下滑动索引递增
        }
        if(translatedPoint.y > 100 && self.viewModel.currentIndex > 0) {
            self.viewModel.currentIndex --;   //向上滑动索引递减
        }

        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.viewModel.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    });
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    YCTVideoTableCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.viewModel.currentIndex inSection:0]];
    [cell contentTransformWhenDragging];
}

#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollsToTop = NO;
        [_tableView registerNib:YCTVideoTableCell.nib forCellReuseIdentifier:YCTVideoTableCell.cellReuseIdentifier];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (YCTVideoViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [YCTVideoViewModel new];
    }
    return _viewModel;
}

- (void)dealloc{
    [self.viewModel releasePlayer];
}
@end
