//
//  YCTMineEditCarouselViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import "YCTMineEditCarouselViewController.h"
#import "YCTAddCarouselCell.h"
#import "YCTImagePickerViewController.h"
#import "YCTApiUpdateBanner.h"
#import "YCTApiUpload.h"
#import "YCTApiGetMyBanner.h"
#import "YCTUserDataManager+Update.h"

#define kBgWHScale (100.0 / 345.0)
#define kCellHeight ceil((Iphone_Width - 15 * 2) * kBgWHScale)

@interface YCTMineEditCarouselViewController ()<UITableViewDelegate, UITableViewDataSource, YCTImagePickerViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, copy) NSArray<YCTUserBannerItemModel *> *models;
@end

@implementation YCTMineEditCarouselViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = YCTLocalizedTableString(@"mine.title.carousel", @"Mine");
    self.addButton.hidden = YES;
    
    @weakify(self);
    [[RACObserve([YCTUserDataManager sharedInstance].userInfoModel, banners) ignore:nil] subscribeNext:^(NSArray<YCTUserBannerItemModel *> * _Nullable x) {
        @strongify(self);
        self.models = x;
        self.addButton.hidden = NO;
        [self.tableView reloadData];
    }];
    
    if (![YCTUserDataManager sharedInstance].userInfoModel.banners) {
        [self requestBanners:YES];
    }
}

- (void)setupView {
    self.addButton = ({
        UIButton *view = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [view setMainThemeStyleWithTitle:YCTLocalizedTableString(@"mine.modify.addCarousel", @"Mine") fontSize:16 cornerRadius:25 imageName:nil];
        [view addTarget:self action:@selector(addCarouselImage) forControlEvents:(UIControlEventTouchUpInside)];
        view;
    });
    [self.view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-25);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-25);
        }
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.addButton.mas_top);
    }];
}

#pragma mark - Actions

- (void)addCarouselImage {
    if (self.models.count >= 5) {
        [[YCTHud sharedInstance] showToastHud:YCTLocalizedTableString(@"mine.modify.addCarouselAlert", @"Mine")];
        return;
    }
    YCTImagePickerViewController *vc = [[YCTImagePickerViewController alloc] initWithMaxImagesCount:1 delegate:self];
    [self presentViewController:vc animated:YES completion:NULL];
}

#pragma mark - Request

- (void)topTheBanner:(NSString *)bannerId {
    [[YCTHud sharedInstance] showLoadingHud];
    [[[YCTApiSetBannerTop alloc] initWithBannerId:bannerId] startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        [self requestBanners:NO];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (void)deleteTheBanner:(NSString *)bannerId {
    [[YCTHud sharedInstance] showLoadingHud];
    [[[YCTApiDeleteBanner alloc] initWithBannerId:bannerId] startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        [self requestBanners:NO];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (void)requestBanners:(BOOL)needHud {
    if (needHud) {
        [[YCTHud sharedInstance] showLoadingHud];
    }
    [[[YCTApiGetMyBanner alloc] init] startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTUserDataManager sharedInstance] updateBanners:request.responseDataModel];
        if (needHud) {
            [[YCTHud sharedInstance] hideHud];
        }
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        if (needHud) {
            [[YCTHud sharedInstance] showDetailToastHud:request.getError];
        }
    }];
}

- (void)uploadBannerImage:(UIImage *)bannerImage {
    [[YCTHud sharedInstance] showLoadingHud];
    [[[YCTApiUpload alloc] initWithImage:bannerImage] doStartWithSuccess:^(YCTCOSUploaderResult * _Nullable result) {
        [self requestAddBanner:result.url image:bannerImage];
    } failure:^(NSString * _Nonnull errorString) {
        [[YCTHud sharedInstance] showDetailToastHud:errorString];
    }];
}

- (void)requestAddBanner:(NSString *)url image:(UIImage *)image {
    YCTApiAddBanner *api = [[YCTApiAddBanner alloc] initWithBannerUrl:url];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
//        [[YCTHud sharedInstance] showSuccessHud:request.getMsg];
        [[YCTHud sharedInstance] hideHud];
        [self requestBanners:NO];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.models.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTUserBannerItemModel *model = self.models[indexPath.section];
    YCTAddCarouselCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTAddCarouselCell.cellReuseIdentifier];
    [cell.carouselImageView loadImageGraduallyWithURL:[NSURL URLWithString:model.url]];
    [cell setFirst:indexPath.section == 0];
    
    @weakify(self);
    [[[cell.deleteButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self deleteTheBanner:model.bannerId];
    }];
    
    [[[cell.stickTopButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self topTheBanner:model.bannerId];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"Header"];
        header.backgroundView = ({
            UIView *view = [UIView new];
            view.backgroundColor = tableView.backgroundColor;
            view;
        });
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Footer"];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"Footer"];
        header.backgroundView = ({
            UIView *view = [UIView new];
            view.backgroundColor = tableView.backgroundColor;
            view;
        });
    }
    return header;
}

#pragma mark - YCTImagePickerViewControllerDelegate

- (void)imagePickerController:(YCTImagePickerViewController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos {
    if (photos.count) {
        [self uploadBannerImage:photos.firstObject];
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = kCellHeight;
        _tableView.rowHeight = kCellHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.view.backgroundColor;
        [_tableView registerClass:YCTAddCarouselCell.class
           forCellReuseIdentifier:YCTAddCarouselCell.cellReuseIdentifier];
    }
    return _tableView;
}

@end
