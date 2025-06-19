//
//  YCTMineEditBgImageViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import "YCTMineEditBgImageViewController.h"
#import "YCTImagePickerViewController.h"

#import "YCTUserDataManager+Update.h"
#import "YCTApiUpdateUserInfo.h"
#import "YCTApiUpload.h"

#define kBgWHScale (210.0 / 375.0)

@interface YCTMineEditBgImageViewController ()<YCTImagePickerViewControllerDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *changeButton;
@end

@implementation YCTMineEditBgImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
}

- (void)bindViewModel {
    @weakify(self);
    [[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.userBg) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        [self.imageView loadImageGraduallyWithURL:[NSURL URLWithString:x]];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeNavigationBarColor:UIColor.blackColor titleColor:UIColor.whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self changeNavigationBarColor:UIColor.whiteColor titleColor:UIColor.navigationBarTitleColor];
}

- (void)setupView {
    self.changeButton = ({
        UIButton *view = [UIButton buttonWithType:(UIButtonTypeSystem)];
        NSString *title = [NSString stringWithFormat:@"  %@  ", YCTLocalizedTableString(@"mine.modify.changeBg", @"Mine")];
        [view setTitle:title forState:(UIControlStateNormal)];
        view.backgroundColor = UIColor.whiteColor;
        view.layer.cornerRadius = 22;
        view.titleLabel.font = [UIFont PingFangSCBold:15];
        [view setTitleColor:UIColor.mainTextColor forState:(UIControlStateNormal)];
        [view addTarget:self action:@selector(changeBgImage) forControlEvents:(UIControlEventTouchUpInside)];
        view;
    });
    [self.view addSubview:self.changeButton];
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-10);
        } else {
            make.bottom.mas_equalTo(-10);
        }
        make.centerX.mas_equalTo(0);
        make.width.mas_greaterThanOrEqualTo(150);
        make.height.mas_equalTo(44);
    }];
    
    self.imageView = ({
        UIImageView *view = [[UIImageView alloc] init];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.clipsToBounds = YES;
        view;
    });
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kNavigationBarHeight);
        make.bottom.mas_equalTo(self.changeButton.mas_top).mas_offset(-20);
    }];
}

- (void)changeBgImage {
    YCTImagePickerViewController *vc = [[YCTImagePickerViewController alloc] initWithMaxImagesCount:1 delegate:self];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (void)uploadBgImage:(UIImage *)bgImage {
    YCTApiUpload *apiUpload = [[YCTApiUpload alloc] initWithImage:bgImage];
    [[YCTHud sharedInstance] showLoadingHud];
    [apiUpload doStartWithSuccess:^(YCTCOSUploaderResult * _Nullable result) {
        [self updateBgImageUrl:result.url image:bgImage];
    } failure:^(NSString * _Nonnull errorString) {
        [[YCTHud sharedInstance] showDetailToastHud:errorString];
    }];
}

- (void)updateBgImageUrl:(NSString *)bgImageUrl image:(UIImage *)bgImage {
    YCTApiUpdateUserInfo *api = [[YCTApiUpdateUserInfo alloc] initWithType:(YCTApiUpdateUserInfoBackgroundImage) value:bgImageUrl];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[SDImageCache sharedImageCache] storeImage:bgImage forKey:bgImageUrl completion:^{
            [[YCTUserDataManager sharedInstance] updateUserBgImage:bgImageUrl];
            [[YCTHud sharedInstance] hideHud];
        }];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

#pragma mark - YCTImagePickerViewControllerDelegate

- (void)imagePickerController:(YCTImagePickerViewController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos {
    if (photos.count) {
        [self uploadBgImage:photos.firstObject];
    }
}

#pragma mark - Override

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
