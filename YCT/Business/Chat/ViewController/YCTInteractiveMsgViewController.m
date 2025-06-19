//
//  YCTInteractiveMsgViewController.m
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import "YCTInteractiveMsgViewController.h"
#import "YCTInteractionMsgViewModel.h"
#import "YCTInteractiveMsgCell.h"
#import "UIScrollView+YCTEmptyView.h"
#import "YCTMyVideoListViewModel.h"
#import "YCTVideoDetailViewController.h"
@interface YCTInteractiveMsgViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) YCTInteractionMsgViewModel *viewModel;
@property (nonatomic, strong) YCTMyVideoListViewModel *videoModel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YCTInteractiveMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"chat.main.interactiveMessage", @"Chat");
    [self requestData];
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
            [self.tableView showEmptyViewWithImage:[UIImage imageNamed:@"empty_interactionMsg"] emptyInfo:YCTLocalizedString(@"empty.interactionMsg")];
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
    
    [self.videoModel.loadingSubject subscribeNext:^(NSNumber * _Nullable x) {
        [self.viewModel resetRequestData];
    }];
    
//    [[[RACObserve(self.videoModel, models) skip:1] map:^id _Nullable(NSArray * _Nullable value) {
//        return @(value.count == 0);
//    }] subscribeNext:^(NSNumber * _Nullable x) {
//        @strongify(self);
//        [self.viewModel resetRequestData];
//    }];
}

- (void)setupView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.bottom.right.mas_equalTo(0);
    }];
}

#pragma mark - Private

- (void)requestData {
    [[YCTHud sharedInstance] showLoadingHud];
    [self.videoModel requestAllData];
//    [self.viewModel resetRequestData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTInteractiveMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTInteractiveMsgCell.cellReuseIdentifier forIndexPath:indexPath];
    cell.model = self.viewModel.models[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel getCellHeightAtIndex:indexPath.row];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCTInteractionMsgModel * model= self.viewModel.models[indexPath.row];
    NSString * videoId=[NSString stringWithFormat:@"%ld",model.videoId];
    NSMutableArray<YCTVideoModel *> * arr=[NSMutableArray array];
    for(int i=0;i<self.videoModel.models.count;i++)
    {
        YCTVideoModel * videoModel=self.videoModel.models[i];
        if(arr.count==0)
        {
            if([videoId isEqualToString:videoModel.id])
            {
                [arr addObject:videoModel];
            }
        }else{
            [arr addObject:videoModel];
            if(arr.count>=10){
                break;
            }
        }
    }
    if(arr.count==0)
    {
        //视频已删除
        [[YCTHud sharedInstance] showToastHud:YCTLocalizedTableString(@"chat.main.videoDeleted", @"Chat")];
    }else{
        YCTVideoDetailViewController * vc = [[YCTVideoDetailViewController alloc] initWithVideos:arr index:0 type:YCTVideoDetailTypeMine];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
            _tableView.estimatedRowHeight = 0;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [_tableView registerClass:YCTInteractiveMsgCell.class forCellReuseIdentifier:YCTInteractiveMsgCell.cellReuseIdentifier];
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

- (YCTInteractionMsgViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[YCTInteractionMsgViewModel alloc] init];
    }
    return _viewModel;
}
- (YCTMyVideoListViewModel *)videoModel {
    if (!_videoModel) {
        _videoModel = [[YCTMyVideoListViewModel alloc] initWithType:YCTMyVideoListTypeWorks];
    }
    return _videoModel;
}
@end
