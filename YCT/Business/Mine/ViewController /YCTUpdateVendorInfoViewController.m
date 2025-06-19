//
//  YCTUpdateVendorInfoViewController.m
//  YCT
//
//  Created by 木木木 on 2022/5/8.
//

#import "YCTUpdateVendorInfoViewController.h"
#import "YCTTextView.h"
#import "YCTImagePickerViewController.h"

#import "YCTApiUpdateUserInfo.h"
#import "YCTApiUpload.h"
#import "YCTUserDataManager+Update.h"

@interface YCTUpdateVendorInfoViewController ()<YCTImagePickerViewControllerDelegate>

@property (nonatomic, strong) UIImage *updatedImage;
@property (nonatomic, strong) NSString *updatedImageResult;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic, weak) IBOutlet UILabel *photoLabel;

@property (nonatomic, weak) IBOutlet UILabel *nameTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;

@property (nonatomic, weak) IBOutlet UILabel *phoneNumberTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumberTextField;

@property (nonatomic, weak) IBOutlet UILabel *emailTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;

@property (nonatomic, weak) IBOutlet UILabel *briefIntroTitleLabel;
@property (nonatomic, weak) IBOutlet YCTTextView *briefIntroTextView;

@property (nonatomic, weak) IBOutlet UIButton *submitButton;

@end

@implementation YCTUpdateVendorInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"mine.completeVendorInfo.title", @"Mine");

    [self refreshMineInfo];
}

- (void)setupView {
    [self.submitButton setTitle:YCTLocalizedTableString(@"mine.upgradeToVendor.submit", @"Mine") forState:UIControlStateNormal];
    self.submitButton.layer.cornerRadius = 25;
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.scrollView.mj_insetT = kNavigationBarHeight + 25;
    
    self.bgImageView.backgroundColor = UIColor.grayButtonBgColor;
    self.bgImageView.layer.cornerRadius = 10;
    self.bgImageView.clipsToBounds = YES;
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoLabel.text = YCTLocalizedTableString(@"mine.completeVendorInfo.bgImage", @"Mine");
    self.photoLabel.font = [UIFont PingFangSCMedium:12];
    self.photoLabel.textColor = UIColor.mainGrayTextColor;
    
    self.nameTitleLabel.text = YCTLocalizedTableString(@"mine.completeVendorInfo.contact", @"Mine");
    self.nameTextField.placeholder = YCTLocalizedTableString(@"mine.completeVendorInfo.contact.placeholder", @"Mine");
    
    self.phoneNumberTitleLabel.text = YCTLocalizedTableString(@"mine.completeVendorInfo.phonenumber", @"Mine");
    self.phoneNumberTextField.placeholder = YCTLocalizedTableString(@"mine.completeVendorInfo.phonenumber.placeholder", @"Mine");
    
    self.emailTitleLabel.text = YCTLocalizedTableString(@"mine.completeVendorInfo.email", @"Mine");
    self.emailTextField.placeholder = YCTLocalizedTableString(@"mine.completeVendorInfo.email.placeholder", @"Mine");
    
    self.briefIntroTitleLabel.text = YCTLocalizedTableString(@"mine.completeVendorInfo.briefTitle", @"Mine");
    self.briefIntroTextView.textView.placeholder = YCTLocalizedTableString(@"mine.completeVendorInfo.briefTitle.placeholder", @"Mine");
    
    self.nameTitleLabel.font = [UIFont PingFangSCMedium:14];
    self.nameTextField.font = [UIFont PingFangSCMedium:16];
    self.phoneNumberTitleLabel.font = [UIFont PingFangSCMedium:14];
    self.phoneNumberTextField.font = [UIFont PingFangSCMedium:16];
    self.emailTitleLabel.font = [UIFont PingFangSCMedium:14];
    self.emailTextField.font = [UIFont PingFangSCMedium:16];
    self.briefIntroTitleLabel.font = [UIFont PingFangSCMedium:14];
    self.briefIntroTextView.textView.font = [UIFont PingFangSCMedium:16];
    
    self.nameTitleLabel.textColor = UIColor.mainTextColor;
    self.nameTextField.textColor = UIColor.mainTextColor;
    self.phoneNumberTitleLabel.textColor = UIColor.mainTextColor;
    self.phoneNumberTextField.textColor = UIColor.mainTextColor;
    self.emailTitleLabel.textColor = UIColor.mainTextColor;
    self.emailTextField.textColor = UIColor.mainTextColor;
    self.briefIntroTitleLabel.textColor = UIColor.mainTextColor;
    self.briefIntroTextView.textView.textColor = UIColor.mainTextColor;
    self.briefIntroTextView.textView.placeholderTextColor = UIColor.yct_systemplaceholderColor;
    
    self.briefIntroTextView.backgroundColor = UIColor.whiteColor;
    self.briefIntroTextView.margin = 0;
    self.briefIntroTextView.marginTop = 0;
    self.briefIntroTextView.limitLength = 1000;
}

- (void)refreshMineInfo {
    if ([YCTUserDataManager sharedInstance].userInfoModel.userBg) {
        [self.bgImageView loadImageGraduallyWithURL:[NSURL URLWithString:[YCTUserDataManager sharedInstance].userInfoModel.userBg] placeholderImageName:@"mine_mine_bg"];
        self.photoImageView.hidden = YES;
        self.photoLabel.hidden = YES;
    } else {
        self.photoImageView.hidden = NO;
        self.photoLabel.hidden = NO;
    }
    
    self.briefIntroTextView.textView.text = [YCTUserDataManager sharedInstance].userInfoModel.introduce;
    self.nameTextField.text = [YCTUserDataManager sharedInstance].userInfoModel.companyContact;
    self.phoneNumberTextField.text = [YCTUserDataManager sharedInstance].userInfoModel.companyPhone;
    self.emailTextField.text = [YCTUserDataManager sharedInstance].userInfoModel.companyEmail;
}

- (IBAction)selectBgImage {
    YCTImagePickerViewController *vc = [[YCTImagePickerViewController alloc] initWithMaxImagesCount:1 delegate:self];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)updateVendorInfo {
    /// 没有更新过任何资料直接pop
    if (
        !self.updatedImage// updatedImage为空，意味着用户没有选择新的背景图
        && [self.briefIntroTextView.textView.text isEqualToString:[YCTUserDataManager sharedInstance].userInfoModel.introduce]
        && [self.phoneNumberTextField.text isEqualToString:[YCTUserDataManager sharedInstance].userInfoModel.companyPhone]
        && [self.nameTextField.text isEqualToString:[YCTUserDataManager sharedInstance].userInfoModel.companyContact]
        && [self.emailTextField.text isEqualToString:[YCTUserDataManager sharedInstance].userInfoModel.companyEmail]
        ) {
            [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (self.updatedImage) {
        @weakify(self);
        [self requestForUploadPhotoWithCompletion:^(BOOL success) {
            @strongify(self);
            if (success) {
                [self requestUpdateVendorInfo];
            }
        }];
    } else {
        [self requestUpdateVendorInfo];
    }
}

- (void)requestUpdateVendorInfo {
    NSString *userBg = self.updatedImageResult ?: [YCTUserDataManager sharedInstance].userInfoModel.userBg;
    NSString *introduce = self.briefIntroTextView.textView.text;
    NSString *companyContact = self.nameTextField.text;
    NSString *companyPhone = self.phoneNumberTextField.text;
    NSString *companyEmail = self.emailTextField.text;
    
    YCTApiUpdateVendorInfo *api = [[YCTApiUpdateVendorInfo alloc] initWithUserBg:userBg introduce:introduce companyContact:companyContact companyPhone:companyPhone companyEmail:companyEmail];
    
    [[YCTHud sharedInstance] showLoadingHud];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[YCTUserDataManager sharedInstance] updateUserBgImage:userBg];
        [[YCTUserDataManager sharedInstance] updateBriefIntro:introduce];
        [[YCTUserDataManager sharedInstance] updateCompanyContact:companyContact];
        [[YCTUserDataManager sharedInstance] updateCompanyPhone:companyPhone];
        [[YCTUserDataManager sharedInstance] updateCompanyEmail:companyEmail];
        
        [[YCTHud sharedInstance] hideHud];
        !self.updateCompletion ?: self.updateCompletion();
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (void)requestForUploadPhotoWithCompletion:(void(^)(BOOL success))completion {
    if (self.updatedImageResult) {
        completion(YES);
        return;
    }
    
    YCTApiUpload *apiUpload = [[YCTApiUpload alloc] initWithImage:self.updatedImage];
    [[YCTHud sharedInstance] showLoadingHud];
    [apiUpload doStartWithSuccess:^(YCTCOSUploaderResult * _Nullable result) {
        [[YCTHud sharedInstance] hideHud];
        self.updatedImageResult = result.url;
        completion(YES);
    } failure:^(NSString * _Nonnull errorString) {
        [[YCTHud sharedInstance] showDetailToastHud:errorString];
    }];
}

#pragma mark - YCTImagePickerViewControllerDelegate

- (void)imagePickerController:(YCTImagePickerViewController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos {
    if (photos.count) {
        self.updatedImageResult = nil;
        self.updatedImage = photos.firstObject;
        self.bgImageView.image = self.updatedImage;
    }
}
@end
