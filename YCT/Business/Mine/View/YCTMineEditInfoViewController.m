//
//  YCTMineEditInfoViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/24.
//

#import "YCTMineEditInfoViewController.h"
#import "YCTMineEditInfoHeaderView.h"
#import "YCTTableViewCell.h"
#import "YCTDatePickerView.h"
#import "YCTImagePickerViewController.h"
#import "YCTMineEditIDViewController.h"
#import "YCTMineEditNicknameViewController.h"
#import "YCTMineEditIntroViewController.h"
#import "YCTMineEditCarouselViewController.h"
#import "YCTMineEditLabelViewController.h"
#import "YCTMineEditBgImageViewController.h"
#import "YCTMyQRCodeViewController.h"
#import "YCTGetLocationViewController.h"
#import "YCTMineEditMainProductViewController.h"
#import "YCTUserDataManager+Update.h"
#import "YCTApiUpdateUserInfo.h"
#import "YCTApiUpload.h"
#import "YCTPhotoBrowser.h"
#import "YCTChangeMobileViewController.h"
#define kNickNameTitle YCTLocalizedTableString(@"mine.edit.nickname", @"Mine")
#define kIDTitle YCTLocalizedTableString(@"mine.edit.ID", @"Mine")
#define kIntroTitle YCTLocalizedTableString(@"mine.edit.briefIntro", @"Mine")
#define kBirthDayTitle YCTLocalizedTableString(@"mine.edit.birthday", @"Mine")
#define kLocationTitle YCTLocalizedTableString(@"mine.edit.location", @"Mine")
#define kQRCodeTitle YCTLocalizedTableString(@"mine.edit.QRCode", @"Mine")
#define kBgImageTitle YCTLocalizedTableString(@"mine.edit.backgroundImage", @"Mine")
#define kCarouselTitle YCTLocalizedTableString(@"mine.edit.carousel", @"Mine")
#define kLabelTitle YCTLocalizedTableString(@"mine.edit.personalityLabel", @"Mine")
#define kLicenseTitle YCTLocalizedTableString(@"login.license", @"Login")
#define kHeadTitle YCTLocalizedTableString(@"login.head", @"Login")
#define kMainProductTitle YCTLocalizedTableString(@"mine.edit.mainProduct", @"Mine")
#define changeMobile YCTLocalizedTableString(@"mine.edit.regMobile", @"Mine")
//"mine.edit.mainProduct"

@interface YCTMineEditInfoViewController ()<UITableViewDelegate, UITableViewDataSource, YCTImagePickerViewControllerDelegate, YCTGetLocationViewControllerDelegate>

@property (nonatomic, strong) YCTMineEditInfoHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *infos;

@property (nonatomic, weak) YCTApiUpdateUserInfo *apiUpdateUserInfo;
@property (nonatomic, weak) YCTApiUpload *apiUpload;;

@end

@implementation YCTMineEditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *infos = @[
        kNickNameTitle,
        kIDTitle,
//        kIntroTitle,//简介
        kBirthDayTitle,
//        kLocationTitle,//所在地
        kQRCodeTitle,
        changeMobile,
        kBgImageTitle,
//        kCarouselTitle,
//        kLabelTitle,
    ].mutableCopy;
    
//    if ([YCTUserDataManager sharedInstance].userInfoModel.userType == YCTMineUserTypeNormal) {
//        [infos removeObject:kCarouselTitle];
//    } else {
//        [infos addObject:kLicenseTitle];
//        [infos addObject:kHeadTitle];
//        [infos addObject:kMainProductTitle];
//    }
    
    self.infos = infos.copy;
    
    self.title = YCTLocalizedTableString(@"mine.more.myAccount", @"Mine");
}

- (void)bindViewModel {
    @weakify(self);
    [[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.avatar) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        [self.headerView.avatarImageView loadImageGraduallyWithURL:[NSURL URLWithString:x] placeholderImageName:kDefaultAvatarImageName];
    }];
    
    [[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.sex) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        [self.headerView setSex:x.intValue];
    }];
}

- (void)dealloc {
    [self.apiUpdateUserInfo stop];
    [self.apiUpload stop];
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

#pragma mark - Private

- (void)chooseAvatar {
    YCTImagePickerViewController *vc = [[YCTImagePickerViewController alloc] initWithMaxImagesCount:1 delegate:self];
//    [vc configCircleCrop];
    [vc configCropSize:(CGSize){Iphone_Width, Iphone_Width}];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (void)updateBirthday:(NSString *)birthday {
    YCTApiUpdateUserInfo *apiSetAvatar = [[YCTApiUpdateUserInfo alloc] initWithType:(YCTApiUpdateUserInfoBirthday) value:birthday];
    [[YCTHud sharedInstance] showLoadingHud];
    [apiSetAvatar startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTUserDataManager sharedInstance] updateBirthday:birthday];
        [[YCTHud sharedInstance] hideHud];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
    self.apiUpdateUserInfo = apiSetAvatar;
}

- (void)updateSex:(YCTMineUserSex)sex {
    YCTApiUpdateUserInfo *apiSetAvatar = [[YCTApiUpdateUserInfo alloc] initWithType:(YCTApiUpdateUserInfoSex) value:@(sex)];
    [[YCTHud sharedInstance] showLoadingHud];
    [apiSetAvatar startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTUserDataManager sharedInstance] updateSex:sex];
        [[YCTHud sharedInstance] hideHud];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
    self.apiUpdateUserInfo = apiSetAvatar;
}

- (void)uploadAvatarImage:(UIImage *)avatarImage {
    YCTApiUpload *apiUpload = [[YCTApiUpload alloc] initWithImage:avatarImage];
    [[YCTHud sharedInstance] showLoadingHud];
    [apiUpload doStartWithSuccess:^(YCTCOSUploaderResult * _Nullable result) {
        [self updateAvatar:result.url image:avatarImage];
    } failure:^(NSString * _Nonnull errorString) {
        [[YCTHud sharedInstance] showDetailToastHud:errorString];
    }];
    self.apiUpload = apiUpload;
}

- (void)updateAvatar:(NSString *)avatar image:(UIImage *)image {
    YCTApiUpdateUserInfo *apiSetAvatar = [[YCTApiUpdateUserInfo alloc] initWithType:(YCTApiUpdateUserInfoAvatar) value:avatar];
    [apiSetAvatar startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[SDImageCache sharedImageCache] storeImage:image forKey:avatar completion:^{
            [[YCTUserDataManager sharedInstance] updateAvatar:avatar];
            [[YCTHud sharedInstance] hideHud];
        }];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
    self.apiUpdateUserInfo = apiSetAvatar;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTTableViewCell.cellReuseIdentifier];
    cell.textLabel.text = self.infos[indexPath.row];
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arraw_gray_12_12"]];
    
    @weakify(cell);
    
    if ([self.infos[indexPath.row] isEqualToString:kNickNameTitle]) {
        [[[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.nickName) takeUntil:cell.rac_prepareForReuseSignal] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(cell);
            cell.detailTextLabel.textColor = UIColor.mainTextColor;
            cell.detailTextLabel.text = x ?: @"";
        }];
    }
    else if ([self.infos[indexPath.row] isEqualToString:kIDTitle]) {
        [[[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.userTag) takeUntil:cell.rac_prepareForReuseSignal] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(cell);
            cell.detailTextLabel.textColor = UIColor.mainTextColor;
            cell.detailTextLabel.text = x ?: @"";
        }];
    }
    else if ([self.infos[indexPath.row] isEqualToString:kIntroTitle]) {
        [[[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.introduce) takeUntil:cell.rac_prepareForReuseSignal] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(cell);
            if (x.length == 0) {
                cell.detailTextLabel.textColor = UIColor.mainGrayTextColor;
                cell.detailTextLabel.text = YCTLocalizedTableString(@"mine.edit.placeholder.clickToSet", @"Mine");
            } else {
                cell.detailTextLabel.textColor = UIColor.mainTextColor;
                cell.detailTextLabel.text = x;
            }
        }];
    }
    else if ([self.infos[indexPath.row] isEqualToString:kBirthDayTitle]) {
        [[[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.birthday) takeUntil:cell.rac_prepareForReuseSignal] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(cell);
            if (x.length == 0) {
                cell.detailTextLabel.textColor = UIColor.mainGrayTextColor;
                cell.detailTextLabel.text = YCTLocalizedTableString(@"mine.edit.placeholder.clickToSet", @"Mine");
            } else {
                cell.detailTextLabel.textColor = UIColor.mainTextColor;
                cell.detailTextLabel.text = x;
            }
        }];
    }
    else if ([self.infos[indexPath.row] isEqualToString:kLocationTitle]) {
        [[[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.locationStr) takeUntil:cell.rac_prepareForReuseSignal] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(cell);
            if (x.length == 0) {
                cell.detailTextLabel.textColor = UIColor.mainGrayTextColor;
                cell.detailTextLabel.text = YCTLocalizedTableString(@"mine.edit.placeholder.clickToSet", @"Mine");
            } else {
                cell.detailTextLabel.textColor = UIColor.mainTextColor;
                cell.detailTextLabel.text = x;
            }
        }];
    }
    else if ([self.infos[indexPath.row] isEqualToString:changeMobile]) {
        [[[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.mobile) takeUntil:cell.rac_prepareForReuseSignal] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(cell);
            cell.detailTextLabel.textColor = UIColor.mainTextColor;
            cell.detailTextLabel.text = x;
        }];
    }
    else if ([self.infos[indexPath.row] isEqualToString:kBgImageTitle]) {
        cell.detailTextLabel.textColor = UIColor.mainGrayTextColor;
        cell.detailTextLabel.text = YCTLocalizedTableString(@"mine.edit.placeholder.changeBgImage", @"Mine");
    }
    else if ([self.infos[indexPath.row] isEqualToString:kCarouselTitle]) {
        [[[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.banners) takeUntil:cell.rac_prepareForReuseSignal] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSArray * _Nullable x) {
            @strongify(cell);
            cell.detailTextLabel.textColor = UIColor.mainTextColor;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/5", @(x.count)];
        }];
    }
    else if ([self.infos[indexPath.row] isEqualToString:kLabelTitle]) {
        cell.detailTextLabel.textColor = UIColor.mainGrayTextColor;
        cell.detailTextLabel.text = YCTLocalizedTableString(@"mine.edit.placeholder.userLabels", @"Mine");
    }
    else if ([self.infos[indexPath.row] isEqualToString:kMainProductTitle]) {
        [[[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.direction) takeUntil:cell.rac_prepareForReuseSignal] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(cell);
            if (x.length == 0) {
                cell.detailTextLabel.textColor = UIColor.mainGrayTextColor;
                cell.detailTextLabel.text = YCTLocalizedTableString(@"mine.edit.placeholder.clickToSet", @"Mine");
            } else {
                cell.detailTextLabel.textColor = UIColor.mainTextColor;
                cell.detailTextLabel.text = x;
            }
        }];
    }
    else {
        cell.detailTextLabel.textColor = UIColor.mainTextColor;
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![YCTUserDataManager sharedInstance].userInfoModel) {
        return;
    }
    
    if ([self.infos[indexPath.row] isEqualToString:kNickNameTitle]) {
        YCTMineEditNicknameViewController*vc = [YCTMineEditNicknameViewController new];
        vc.originalValue = [YCTUserDataManager sharedInstance].userInfoModel.nickName;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if ([self.infos[indexPath.row] isEqualToString:kIDTitle]) {
        if ([YCTUserDataManager sharedInstance].userInfoModel.canEdituuid) {
            YCTMineEditIDViewController *vc = [YCTMineEditIDViewController new];
            vc.originalValue = [YCTUserDataManager sharedInstance].userInfoModel.userTag;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.modify.IDAlert", @"Mine")];
        }
    }
    
    else if ([self.infos[indexPath.row] isEqualToString:kIntroTitle]) {
        YCTMineEditIntroViewController *vc = [YCTMineEditIntroViewController new];
        vc.originalValue = [YCTUserDataManager sharedInstance].userInfoModel.introduce;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if ([self.infos[indexPath.row] isEqualToString:kCarouselTitle]) {
        YCTMineEditCarouselViewController *vc = [YCTMineEditCarouselViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if ([self.infos[indexPath.row] isEqualToString:kLabelTitle]) {
        YCTMineEditLabelViewController *vc = [YCTMineEditLabelViewController new];
        if ([YCTUserDataManager sharedInstance].userInfoModel.userTags.length == 0) {
            vc.orginalLabels = nil;
        } else {
            vc.orginalLabels = [[YCTUserDataManager sharedInstance].userInfoModel.userTags componentsSeparatedByString:@","];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if ([self.infos[indexPath.row] isEqualToString:kBgImageTitle]) {
        YCTMineEditBgImageViewController *vc = [YCTMineEditBgImageViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if ([self.infos[indexPath.row] isEqualToString:kQRCodeTitle]) {
        YCTMyQRCodeViewController *vc = [YCTMyQRCodeViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.infos[indexPath.row] isEqualToString:changeMobile]) {
        YCTChangeMobileViewController *vc = [YCTChangeMobileViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.infos[indexPath.row] isEqualToString:kLocationTitle]) {
        YCTGetLocationViewController *vc = [[YCTGetLocationViewController alloc] initWithDelegate:self];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if ([self.infos[indexPath.row] isEqualToString:kBirthDayTitle]) {
        YCTDatePickerView *datePickerView = [[YCTDatePickerView alloc] init];
        datePickerView.confirmClickBlock = ^(NSDate * _Nonnull date) {
            NSString *birthday = [date dateToStringWithFormate:@"yyyy-MM-dd"];
            [self updateBirthday:birthday];
        };
        [datePickerView yct_show];
    }
    
    else if ([self.infos[indexPath.row] isEqualToString:kLicenseTitle]) {
        [YCTPhotoBrowser showPhotoBrowerInVC:self photoCount:1 currentIndex:0 photoConfig:^(NSUInteger idx, NSURL * _Nonnull __autoreleasing * _Nullable photoUrl, UIImageView * _Nonnull __autoreleasing * _Nullable sourceImageView) {
            *photoUrl = [NSURL URLWithString:[YCTUserDataManager sharedInstance].userInfoModel.businessLicense];
        }];
    }
    
    else if ([self.infos[indexPath.row] isEqualToString:kHeadTitle]) {
        [YCTPhotoBrowser showPhotoBrowerInVC:self photoCount:1 currentIndex:0 photoConfig:^(NSUInteger idx, NSURL * _Nonnull __autoreleasing * _Nullable photoUrl, UIImageView * _Nonnull __autoreleasing * _Nullable sourceImageView) {
            *photoUrl = [NSURL URLWithString:[YCTUserDataManager sharedInstance].userInfoModel.doorHeadPic];
        }];
    }
    
    else if ([self.infos[indexPath.row] isEqualToString:kMainProductTitle]) {
        YCTMineEditMainProductViewController *vc = [YCTMineEditMainProductViewController new];
        vc.originalValue = [YCTUserDataManager sharedInstance].userInfoModel.direction;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - YCTImagePickerViewControllerDelegate

- (void)imagePickerController:(YCTImagePickerViewController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos {
    if (photos.count > 0) {
        [self uploadAvatarImage:photos.firstObject];
    }
}

#pragma mark - YCTGetLocationViewControllerDelegate

- (void)locationDidSelectWithAll:(NSArray<YCTMintGetLocationModel *> *)locations
                        lastPrev:(YCTMintGetLocationModel *)lastPrev
                            last:(YCTMintGetLocationModel *)last {
    YCTApiUpdateUserInfo *apiUpdateUserInfo = [[YCTApiUpdateUserInfo alloc] initWithType:(YCTApiUpdateUserInfoLocation) value:last.cid];
    [[YCTHud sharedInstance] showLoadingHud];
    [apiUpdateUserInfo startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *names = [locations valueForKey:@"name"];
        [[YCTUserDataManager sharedInstance] updateLocationStr:[names componentsJoinedByString:@""]];
        [[YCTHud sharedInstance] hideHud];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
    self.apiUpdateUserInfo = apiUpdateUserInfo;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 52;
        _tableView.rowHeight = 52;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.view.backgroundColor;
        [_tableView registerClass:YCTTableViewCell.class
           forCellReuseIdentifier:YCTTableViewCell.cellReuseIdentifier];
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (YCTMineEditInfoHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[YCTMineEditInfoHeaderView alloc] initWithFrame:(CGRect){0, 0, Iphone_Width, 230}];
        [_headerView.changeAvatarButton addTarget:self action:@selector(chooseAvatar) forControlEvents:(UIControlEventTouchUpInside)];
        @weakify(self);
        [[_headerView.maleButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self updateSex:YCTMineUserSexMale];
        }];
        [[_headerView.femaleButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self updateSex:YCTMineUserSexFemale];
        }];
    }
    return _headerView;
}

@end
