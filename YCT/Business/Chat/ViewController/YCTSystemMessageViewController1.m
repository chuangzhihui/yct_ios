//
//  YCTSystemMessageViewController1.m
//  YCT
//
//  Created by 木木木 on 2021/12/29.
//

#import "YCTSystemMessageViewController1.h"
#import "YCTSystemMsgViewModel.h"
#import "YCTSystemMessageCell.h"
#import "UIScrollView+YCTEmptyView.h"

#define kHeaderHeight 40

@interface YCTSystemMessageViewController1 ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) YCTSystemMsgViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation YCTSystemMessageViewController1

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
    [self loadMessage];
}

- (void)setupView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)loadMessage {
    if (self.viewModel.isLoadingData || self.viewModel.isNoMoreData) {
        return;
    }
    [self.viewModel requestDataWithCompletion:^(BOOL isFirstLoad, BOOL isNoMoreData, NSArray<YCTSystemMsgModel *> * _Nonnull newData) {
        if (isNoMoreData) {
            self.indicatorView.mj_h = 0;
            self.tableView.mj_insetT = 15;
            if (self.viewModel.models.count == 0) {
                [self.tableView showEmptyViewWithImage:[UIImage imageNamed:@"empty_systemMsg"] emptyInfo:YCTLocalizedString(@"empty.systemMsg")];
            }
        }
        
        if (newData != 0) {
            [self.tableView reloadData];
            [self.tableView layoutIfNeeded];
            
            if (isFirstLoad) {
                [self scrollToBottom:NO];
            } else {
                CGFloat visibleHeight = 0;
                for (NSInteger i = 0; i < newData.count; ++i) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    visibleHeight += [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
                }
                if (isNoMoreData) {
                    visibleHeight -= kHeaderHeight;
                }
            
                [self.tableView setContentOffset:(CGPoint){0, self.tableView.contentOffset.y + visibleHeight}];
//                [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentOffset.y + visibleHeight, self.tableView.frame.size.width, self.tableView.frame.size.height) animated:NO];
            }
        }
        [self.indicatorView stopAnimating];
    } failBlock:^(NSString * _Nonnull error) {
        [self.indicatorView stopAnimating];
        [[YCTHud sharedInstance] showDetailToastHud:error];
    }];
}

#pragma mark - Private

- (void)scrollToBottom:(BOOL)animate {
    if (self.viewModel.models.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.viewModel.models.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animate];
    }
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.viewModel.isNoMoreData
        && scrollView.contentOffset.y <= kHeaderHeight) {
        if(!self.indicatorView.isAnimating){
            [self.indicatorView startAnimating];
        }
    }
    else {
        if (self.indicatorView.isAnimating) {
            [self.indicatorView stopAnimating];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= kHeaderHeight) {
        [self loadMessage];
    }
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
        [_tableView registerClass:YCTSystemMessageCell.class forCellReuseIdentifier:YCTSystemMessageCell.cellReuseIdentifier];
        _tableView.tableHeaderView = self.indicatorView;
    }
    return _tableView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, kHeaderHeight)];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    return _indicatorView;
}

@end
