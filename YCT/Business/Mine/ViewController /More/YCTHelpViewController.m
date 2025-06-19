//
//  YCTHelpViewController.m
//  YCT
//
//  Created by 木木木 on 2022/1/19.
//

#import "YCTHelpViewController.h"
#import "YCTApiHelp.h"
#import "YCTHelpItemCell.h"
#import "YCTFeedBackViewController.h"

@interface YCTHelpViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *feedbackButton;
@property (nonatomic, copy) NSArray<YCTHelpItemModel *> *models;
@end

@implementation YCTHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"mine.more.feedback", @"Mine");
    [self requestHelp];
}

- (void)setupView {
    [self.view addSubview:self.feedbackButton];
    [self.feedbackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 50));
        make.centerX.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-25);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-25);
        }
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.feedbackButton.mas_top).mas_offset(-20);
    }];
}

- (void)requestHelp {
    [[YCTHud sharedInstance] showLoadingHud];
    [[[YCTApiHelp alloc] init] startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        NSLog(@"huitiao:%@",request.responseString);
        self.models = YCTArray(request.responseDataModel, @[]);
        [self.tableView reloadData];
        [[YCTHud sharedInstance] hideHud];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTHelpItemCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTHelpItemCell.cellReuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YCTHelpItemModel *model = self.models[indexPath.row];
    cell.qLabel.text = model.title ?: @" ";
    cell.aLabel.text = model.content ?: @" ";
    return cell;
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
            _tableView.rowHeight = UITableViewAutomaticDimension;
            _tableView.estimatedRowHeight = 44;
//            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [_tableView registerNib:YCTHelpItemCell.nib forCellReuseIdentifier:YCTHelpItemCell.cellReuseIdentifier];
            _tableView;
        });
    }
    return _tableView;
}

- (UIButton *)feedbackButton {
    if (!_feedbackButton) {
        _feedbackButton = ({
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
            [button setMainThemeStyleWithTitle:YCTLocalizedTableString(@"mine.feedback.feedback", @"Mine") fontSize:16 cornerRadius:25 imageName:@"mine_feedback"];
            @weakify(self);
            [[button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                YCTFeedBackViewController *vc = [[YCTFeedBackViewController alloc] initFeedBack];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            button;
        });
    }
    return _feedbackButton;
}

@end
