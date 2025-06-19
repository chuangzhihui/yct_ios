//
//  YCTPrivacySettingViewController.m
//  YCT
//
//  Created by 木木木 on 2022/1/9.
//

#import "YCTPrivacySettingViewController.h"
#import "YCTTableViewCell.h"
#import "YCTBlacklistViewController.h"
#import "YCTApiPrivacy.h"
#import "YCTPublishSettingBottomView.h"

#define kMargin 30
#define kTitle YCTLocalizedTableString(@"mine.title.privacySetting", @"Mine")

#define kLikesTitle YCTLocalizedTableString(@"mine.privacy.homepageLikesList", @"Mine")
#define kMsgTitle YCTLocalizedTableString(@"mine.privacy.privateMsg", @"Mine")
#define kFolllowFansTitle YCTLocalizedTableString(@"mine.privacy.followFans", @"Mine")
#define kBlacklistTitle YCTLocalizedTableString(@"mine.privacy.blacklist", @"Mine")

@interface YCTPrivacySettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSString *> *infos;
@property (nonatomic, copy) NSArray<NSString *> *images;
@property (nonatomic, strong) YCTPrivacyModel *privacyModel;
@end

@implementation YCTPrivacySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infos = @[
        kLikesTitle,
        kMsgTitle,
        kFolllowFansTitle,
        kBlacklistTitle,
    ];
    
    self.images = @[
        @"mine_more_homepageLikesSet",
        @"mine_more_privateMsgSet",
        @"mine_more_followFanslistSet",
        @"mine_more_blacklistSet",
    ];
    
    [self requestPrivacySetting];
}

- (void)setupView {
    self.view.backgroundColor = UIColor.whiteColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)requestPrivacySetting {
    [[YCTHud sharedInstance] showLoadingHud];
    [[[YCTApiPrivacy alloc] init] startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        self.privacyModel = request.responseDataModel;
        [self.tableView reloadData];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (void)requestChangeStatus:(YCTPrivacyStatus)status operation:(YCTPrivacyOperation)operation {
    YCTApiPrivacy *api = [[YCTApiPrivacy alloc] initWithOperation:operation status:status];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        switch (operation) {
            case YCTPrivacyOperationHomepageLikes:
                self.privacyModel.myZanList = status;
                break;
            case YCTPrivacyOperationPrivateMsg:
                self.privacyModel.chatType = status;
                break;
            case YCTPrivacyOperationFollowFans:
                self.privacyModel.myFansList = status;
                break;
        }
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.privacyModel ? self.infos.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTTableViewCell.cellReuseIdentifier];
    NSString *title = self.infos[indexPath.row];
    cell.textLabel.font = [UIFont PingFangSCMedium:16];
    cell.detailTextLabel.font = [UIFont PingFangSCMedium:16];
    cell.detailTextLabel.textColor = UIColor.mainGrayTextColor;
    cell.textLabel.text = title;
    cell.imageView.image = [UIImage imageNamed:self.images[indexPath.row]];
    [cell setMargin:kMargin spacing:10];
    
    @weakify(self);
    if ([title isEqualToString:kLikesTitle]) {
        [[RACObserve(self.privacyModel, myZanList) takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            cell.detailTextLabel.text = self.privacyModel.myZanListStatus;
        }];
    }
    else if ([title isEqualToString:kMsgTitle]) {
        [[RACObserve(self.privacyModel, chatType) takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            cell.detailTextLabel.text = self.privacyModel.chatTypeStatus;
        }];
    }
    else if ([title isEqualToString:kFolllowFansTitle]) {
        [[RACObserve(self.privacyModel, myFansList) takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            cell.detailTextLabel.text = self.privacyModel.myFansListStatus;
        }];
    }
    else if ([title isEqualToString:kBlacklistTitle]) {
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

#pragma mark - UITableViewDelegat

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = self.infos[indexPath.row];
    
    if ([title isEqualToString:kLikesTitle]) {
        NSArray *titles = @[
            YCTLocalizedTableString(@"mine.privacy.title.public", @"Mine"),
            YCTLocalizedTableString(@"mine.privacy.title.privacy", @"Mine")];
        NSArray *subtitles = @[
            @"",
            YCTLocalizedTableString(@"mine.privacy.subtitle.privacy", @"Mine")];
        NSInteger index = -1;
        if (YCTPrivacyStatusAll == self.privacyModel.myZanList) {
            index = 0;
        } else if (YCTPrivacyStatusNone == self.privacyModel.myZanList) {
            index = 1;
        }
        YCTPublishSettingBottomView *view = [YCTPublishSettingBottomView settingViewWithDefaultIndex:index title:YCTLocalizedTableString(@"mine.privacy.zanTitle", @"Mine") titles:titles subtitles:subtitles selectedHandler:^(NSString * _Nullable title, NSInteger index) {
            YCTPrivacyStatus status = index == 0 ? YCTPrivacyStatusAll : YCTPrivacyStatusNone;
            [self requestChangeStatus:status operation:(YCTPrivacyOperationHomepageLikes)];
        }];
        [view yct_show];
    }
    else if ([title isEqualToString:kMsgTitle]) {
        NSArray *titles = @[
            YCTLocalizedTableString(@"mine.privacy.title.all", @"Mine"),
            YCTLocalizedTableString(@"mine.privacy.title.friend", @"Mine"),
            YCTLocalizedTableString(@"mine.privacy.title.close", @"Mine")];
        NSArray *subtitles = @[
            @"",
            YCTLocalizedTableString(@"mine.privacy.subtitle.friend", @"Mine"),
            YCTLocalizedTableString(@"mine.privacy.subtitle.close", @"Mine")];
        NSInteger index = -1;
        if (YCTPrivacyStatusAll == self.privacyModel.chatType) {
            index = 0;
        } else if (YCTPrivacyStatusCorrelation == self.privacyModel.chatType) {
            index = 1;
        } else if (YCTPrivacyStatusNone == self.privacyModel.chatType) {
            index = 2;
        }
        YCTPublishSettingBottomView *view = [YCTPublishSettingBottomView settingViewWithDefaultIndex:index title:YCTLocalizedTableString(@"mine.privacy.msgTitle", @"Mine") titles:titles subtitles:subtitles selectedHandler:^(NSString * _Nullable title, NSInteger index) {
            [self requestChangeStatus:(index + 1) operation:(YCTPrivacyOperationPrivateMsg)];
        }];
        [view yct_show];
    }
    else if ([title isEqualToString:kFolllowFansTitle]) {
        NSArray *titles = @[
            YCTLocalizedTableString(@"mine.privacy.title.public", @"Mine"),
            YCTLocalizedTableString(@"mine.privacy.title.privacy", @"Mine")];
        NSArray *subtitles = @[
            @"",
            YCTLocalizedTableString(@"mine.privacy.subtitle.privacy", @"Mine")];
        NSInteger index = -1;
        if (YCTPrivacyStatusAll == self.privacyModel.myFansList) {
            index = 0;
        } else if (YCTPrivacyStatusNone == self.privacyModel.myFansList) {
            index = 1;
        }
        YCTPublishSettingBottomView *view = [YCTPublishSettingBottomView settingViewWithDefaultIndex:index title:YCTLocalizedTableString(@"mine.privacy.followFansTitle", @"Mine") titles:titles subtitles:subtitles selectedHandler:^(NSString * _Nullable title, NSInteger index) {
            YCTPrivacyStatus status = index == 0 ? YCTPrivacyStatusAll : YCTPrivacyStatusNone;
            [self requestChangeStatus:status operation:(YCTPrivacyOperationFollowFans)];
        }];
        [view yct_show];
    }
    else if ([title isEqualToString:kBlacklistTitle]) {
        YCTBlacklistViewController *vc = [[YCTBlacklistViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 38) {
        if (![self.title isEqualToString:kTitle]) {
            self.title = kTitle;
        }
    } else {
        if (![self.title isEqualToString:@""]) {
            self.title = @"";
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
        _tableView.estimatedRowHeight = 48;
        _tableView.rowHeight = 48;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.view.backgroundColor;
        [_tableView registerClass:YCTTableViewCell.class
           forCellReuseIdentifier:YCTTableViewCell.cellReuseIdentifier];
        _tableView.tableHeaderView = ({
            UIView *header = [UIView new];
            header.frame = CGRectMake(0, 0, self.view.bounds.size.width, 58);
            header.backgroundColor = self.view.backgroundColor;
            UILabel *titleLabel = ({
                UILabel *view = [[UILabel alloc] init];
                view.frame = CGRectMake(kMargin, 5, 200, 33);
                view.textColor = UIColor.mainTextColor;
                view.font = [UIFont PingFangSCBold:24];
                view.text = kTitle;
                view;
            });
            [header addSubview:titleLabel];
            header;
        });
    }
    return _tableView;
}

@end
