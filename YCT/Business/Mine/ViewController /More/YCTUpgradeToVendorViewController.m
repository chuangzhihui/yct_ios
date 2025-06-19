//
//  YCTUpgradeToVendorViewController.m
//  YCT
//
//  Created by 木木木 on 2022/3/1.
//

#import "YCTUpgradeToVendorViewController.h"
#import "YCTApiChangePassword.h"
#import "YCTApiUpgradeToVendor.h"
#import "YCTImagePickerViewController.h"
#import "YCTGetLocationViewController.h"
#import "YCTApiUpload.h"
#import "YCTImageUploader.h"
#import "UIImage+Common.h"
#import "YCTLocationManager.h"
#import "YCTMultiLineTextField.h"
#import "YCTDatePickerView.h"

@interface YCTUpgradeToVendorViewController ()<YCTGetLocationViewControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UILabel *companyNameTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *companyNameTextField;

@property (nonatomic, weak) IBOutlet UILabel *areaTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *areaTextField;

@property (nonatomic, weak) IBOutlet UILabel *detailAddressTitleLabel;
@property (nonatomic, weak) IBOutlet YCTMultiLineTextField *detailAddressTextField;
@property (nonatomic, weak) IBOutlet UIButton *siteButton;

@property (nonatomic, weak) IBOutlet UILabel *websiteTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *websiteTextField;

@property (nonatomic, weak) IBOutlet UILabel *socialCodeTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *socialCodeTextField;

@property (nonatomic, weak) IBOutlet UILabel *companyTypeTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *companyTypeTextField;

@property (nonatomic, weak) IBOutlet UILabel *foundDateTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *foundDateTextField;

@property (nonatomic, weak) IBOutlet UILabel *businessTermTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *businessTermTextField;

@property (nonatomic, weak) IBOutlet UILabel *legalnameTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *legalnameTextField;

@property (nonatomic, weak) IBOutlet UILabel *licenseTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *licenseImageView;
@property (nonatomic, weak) IBOutlet UILabel *licenseButtonLabel;
@property (nonatomic, weak) IBOutlet UIStackView *licenseButtonContainer;
@property (nonatomic, weak) IBOutlet UIButton *licenseDeleteButton;

@property (nonatomic, weak) IBOutlet UILabel *doorHeadTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *doorHeadImageView;
@property (nonatomic, weak) IBOutlet UILabel *doorHeadButtonLabel;
@property (nonatomic, weak) IBOutlet UIStackView *doorHeadImageButtonContainer;
@property (nonatomic, weak) IBOutlet UIButton *doorHeadDeleteButton;

@property (nonatomic, weak) IBOutlet UIButton *submitButton;

@property (nonatomic, copy) NSString *locationId;
@property (nonatomic, strong) NSString *licenseResult;
@property (nonatomic, strong) NSString *doorHeadResult;

@end

@implementation YCTUpgradeToVendorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self autoLocating];
}

- (void)setupView {
    [self.submitButton setTitle:YCTLocalizedTableString(@"mine.upgradeToVendor.submit", @"Mine") forState:UIControlStateNormal];
    self.submitButton.layer.cornerRadius = 25;
    
    self.doorHeadImageView.layer.cornerRadius = 6;
    self.licenseImageView.layer.cornerRadius = 6;
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.scrollView.delegate = self;
    self.scrollView.mj_insetT = kNavigationBarHeight;
    
    self.foundDateTextField.delegate = self;
    
    self.companyNameTitleLabel.text = YCTLocalizedTableString(@"mine.upgradeToVendor.companyName", @"Mine");
    self.companyNameTextField.placeholder = YCTLocalizedTableString(@"mine.upgradeToVendor.companyName.placeholder", @"Mine");
    
    self.areaTitleLabel.text = YCTLocalizedTableString(@"mine.upgradeToVendor.area", @"Mine");
    self.areaTextField.placeholder = YCTLocalizedTableString(@"mine.upgradeToVendor.area.placeholder", @"Mine");
    
    self.detailAddressTitleLabel.text = YCTLocalizedTableString(@"mine.upgradeToVendor.detailAddress", @"Mine");
    self.detailAddressTextField.placeholder = YCTLocalizedTableString(@"mine.upgradeToVendor.detailAddress.placeholder", @"Mine");
    
    self.websiteTitleLabel.text = YCTLocalizedTableString(@"mine.upgradeToVendor.website", @"Mine");
    self.websiteTextField.placeholder = YCTLocalizedTableString(@"mine.upgradeToVendor.website.placeholder", @"Mine");
    
    self.socialCodeTitleLabel.text = YCTLocalizedTableString(@"mine.upgradeToVendor.socialCode", @"Mine");
    self.socialCodeTextField.placeholder = YCTLocalizedTableString(@"mine.upgradeToVendor.socialCode.placeholder", @"Mine");
    
    self.companyTypeTitleLabel.text = YCTLocalizedTableString(@"mine.upgradeToVendor.companyType", @"Mine");
    self.companyTypeTextField.placeholder = YCTLocalizedTableString(@"mine.upgradeToVendor.companyType.placeholder", @"Mine");
    
    self.foundDateTitleLabel.text = YCTLocalizedTableString(@"mine.upgradeToVendor.foundDate", @"Mine");
    self.foundDateTextField.placeholder = YCTLocalizedTableString(@"mine.upgradeToVendor.foundDate.placeholder", @"Mine");
    
    self.businessTermTitleLabel.text = YCTLocalizedTableString(@"mine.upgradeToVendor.businessTerm", @"Mine");
    self.businessTermTextField.placeholder = YCTLocalizedTableString(@"mine.upgradeToVendor.businessTerm.placeholder", @"Mine");
    
    self.legalnameTitleLabel.text = YCTLocalizedTableString(@"mine.upgradeToVendor.legalRepresentative", @"Mine");
    self.legalnameTextField.placeholder = YCTLocalizedTableString(@"mine.upgradeToVendor.legalRepresentative.placeholder", @"Mine");
    
    self.doorHeadTitleLabel.text = YCTLocalizedTableString(@"mine.upgradeToVendor.companyDoorPhoto", @"Mine");
    self.doorHeadButtonLabel.text = YCTLocalizedTableString(@"mine.upgradeToVendor.photo", @"Mine");
    
    self.titleLabel.textColor = UIColor.mainTextColor;
    self.titleLabel.font = [UIFont PingFangSCBold:24];
    
    self.detailAddressTextField.textColor = UIColor.mainTextColor;
    self.detailAddressTextField.font = [UIFont PingFangSCMedium:16];
    
    self.licenseButtonLabel.textColor = UIColor.mainGrayTextColor;
    self.licenseButtonLabel.font = [UIFont PingFangSCMedium:12];
    self.doorHeadButtonLabel.textColor = UIColor.mainGrayTextColor;
    self.doorHeadButtonLabel.font = [UIFont PingFangSCMedium:12];
    
    [@[self.companyNameTitleLabel,
       self.areaTitleLabel,
       self.detailAddressTitleLabel,
       self.websiteTitleLabel,
       self.socialCodeTitleLabel,
       self.companyTypeTitleLabel,
       self.foundDateTitleLabel,
       self.businessTermTitleLabel,
       self.legalnameTitleLabel,
       self.licenseTitleLabel,
       self.doorHeadTitleLabel
     ] enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.font = [UIFont PingFangSCMedium:14];
        obj.textColor = UIColor.mainTextColor;
    }];
    
    [@[self.companyNameTextField,
       self.areaTextField,
       self.websiteTextField,
       self.socialCodeTextField,
       self.companyTypeTextField,
       self.foundDateTextField,
       self.businessTermTextField,
       self.legalnameTextField,
     ] enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.font = [UIFont PingFangSCMedium:16];
        obj.textColor = UIColor.mainTextColor;
    }];
}

- (void)bindViewModel {
    @weakify(self);
    
    RAC(self.licenseButtonContainer, hidden) = [RACObserve(self.licenseImageView, image) map:^id(id value) {
        return @(value != nil);
    }];
    
    RAC(self.doorHeadImageButtonContainer, hidden) = [RACObserve(self.doorHeadImageView, image) map:^id(id value) {
        return @(value != nil);
    }];
    
    RAC(self.licenseDeleteButton, hidden) = [RACObserve(self.licenseImageView, image) map:^id(id value) {
        return @(value == nil);
    }];
    
    RAC(self.doorHeadDeleteButton, hidden) = [RACObserve(self.doorHeadImageView, image) map:^id(id value) {
        return @(value == nil);
    }];
    
    RAC(self.submitButton, enabled) = [[RACSignal merge:@[
        self.companyNameTextField.rac_textSignal,
        self.detailAddressTextField.rac_textSignal,
        self.websiteTextField.rac_textSignal,
//        self.emailTextField.rac_textSignal,
//        self.saleHeadTextField.rac_textSignal,
//        self.companyPhoneTextField.rac_textSignal,
//        self.directionTextField.rac_textSignal,
        self.companyTypeTextField.rac_textSignal,
        self.socialCodeTextField.rac_textSignal,
        self.foundDateTextField.rac_textSignal,
        self.businessTermTextField.rac_textSignal,
        self.legalnameTextField.rac_textSignal,
        
        RACObserve(self.licenseImageView, image),
        RACObserve(self.doorHeadImageView, image),
        RACObserve(self, locationId)
    ]] map:^id _Nullable(id  _Nullable value) {
        @strongify(self);
        return @(
        self.companyNameTextField.text.length
        && self.detailAddressTextField.text.length
        && self.websiteTextField.text.length
//        && self.emailTextField.text.length
//        && self.saleHeadTextField.text.length
//        && self.companyPhoneTextField.text.length
//        && self.directionTextField.text.length
        
        && self.companyTypeTextField.text.length
        && self.socialCodeTextField.text.length
        && self.foundDateTextField.text.length
        && self.businessTermTextField.text.length
        && self.legalnameTextField.text.length
        
        && self.licenseImageView.image
        && self.doorHeadImageView.image
        && self.locationId
        );
    }];
    
    [RACObserve(self.submitButton, enabled) subscribeNext:^(id x) {
        @strongify(self);
        [self.submitButton setBackgroundColor: [x boolValue] ? UIColor.mainThemeColor : UIColorFromRGB(0xD9D9D9)];
    }];
    
    [[self.siteButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self autoLocating];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.foundDateTextField) {
        YCTDatePickerView *datePickerView = [[YCTDatePickerView alloc] init];
        datePickerView.confirmClickBlock = ^(NSDate * _Nonnull date) {
            self.foundDateTextField.text = [date dateToStringWithFormate:@"yyyy-MM-dd"];
        };
        [datePickerView yct_show];
        return NO;
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y + kNavigationBarHeight > 70) {
        if (![self.title isEqualToString:YCTLocalizedTableString(@"mine.title.upgradeToVendor", @"Mine")]) {
            self.title = YCTLocalizedTableString(@"mine.title.upgradeToVendor", @"Mine");
        }
    } else {
        if (![self.title isEqualToString:@""]) {
            self.title = @"";
        }
    }
}

#pragma mark - Actions

- (void)autoLocating {
    [[YCTLocationManager sharedInstance] requestLocationWithCompletion:^(YCTLocationResultModel * _Nullable model, NSError * _Nullable error) {
        if (model) {
            self.detailAddressTextField.text = model.formattedAddress;
        } else {
            [[YCTHud sharedInstance] showDetailToastHud:error.localizedDescription];
        }
    }];
}

- (IBAction)chooseAreaButtonPressed:(UIButton *)sender {
    YCTGetLocationViewController *vc = [[YCTGetLocationViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)deleteLicenseImageButtonPressed:(UIButton *)sender {
    self.licenseImageView.image = nil;
}

- (IBAction)deleteHeadImageButtonPressed:(UIButton *)sender {
    self.doorHeadImageView.image = nil;
}

- (IBAction)licenseButtonPressed:(UIButton *)sender {
    @weakify(self);
    YCTImagePickerViewController *vc = [[YCTImagePickerViewController alloc] initWithMaxImagesCount:1 didFinishPickingPhotos:^(NSArray<UIImage *> * _Nonnull photos) {
        @strongify(self);
        self.licenseResult = nil;
        self.licenseImageView.image = [photos firstObject];
    }];
    [vc configCropSize:(CGSize){Iphone_Width, ceil((210.0 / 375.0) * Iphone_Width)}];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)headButtonPressed:(UIButton *)sender {
    @weakify(self);
    YCTImagePickerViewController *vc = [[YCTImagePickerViewController alloc] initWithMaxImagesCount:1 didFinishPickingPhotos:^(NSArray<UIImage *> * _Nonnull photos) {
        @strongify(self);
        self.doorHeadResult = nil;
        self.doorHeadImageView.image = [photos firstObject];
    }];
    [vc configCropSize:(CGSize){Iphone_Width, ceil((210.0 / 375.0) * Iphone_Width)}];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)sendersubmitButtonPressed:(UIButton *)sender {
    @weakify(self);
    [[YCTHud sharedInstance] showLoadingHud];
    [self requestForUploadPhotoWithCompletion:^(BOOL success) {
        @strongify(self);
        if (success) {
            [self submitRequest];
        } else {
            [[YCTHud sharedInstance] hideHud];
        }
    }];
}

#pragma mark - Request

- (void)submitRequest {
    YCTApiUpgradeToVendor *api = [YCTApiUpgradeToVendor new];
    api.companyName = self.companyNameTextField.text;
    api.companyAddress = self.detailAddressTextField.text;
//    api.companyPhone = self.companyPhoneTextField.text;
    api.companyWebSite = self.websiteTextField.text;
//    api.companyEmail = self.emailTextField.text;
//    api.companyContact = self.saleHeadTextField.text;
//    api.direction = self.directionTextField.text;
    api.businessLicense = self.licenseResult;
    api.doorHeadPic = self.doorHeadResult;
    api.locationId = self.locationId;
    api.companytype = self.companyTypeTextField.text;
    api.socialcode = self.socialCodeTextField.text;
    api.businessstart = self.foundDateTextField.text;
//    api.businessterm = self.businessTermTextField.text;
    api.legalname = self.legalnameTextField.text;
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[YCTUserManager sharedInstance] updateUserInfo];
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.upgradeToVendor.submit.alert", @"Mine")];
        [[YCTHud sharedInstance] hideHudAfterDelay:kDefaultDelayTimeInterval completion:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (void)requestForUploadPhotoWithCompletion:(void(^)(BOOL success))completion{
    if (self.licenseResult && self.doorHeadResult) {
        completion(YES);
        return;
    }
    
    NSMutableArray * images = @[].mutableCopy;
    if (!self.doorHeadResult) {
        [images addObject:self.doorHeadImageView.image];
    }
    if (!self.licenseResult) {
        [images addObject:self.licenseImageView.image];
    }
    YCTImageUploader *uploader = [[YCTImageUploader alloc] init];
    [uploader uploadImages:images optionsMaker:^(YCTImageUploaderOptionsMaker * _Nonnull option) {
        option.maxConcurrentTaskNumber = 1;
    } completion:^(NSDictionary * _Nonnull imageUrlDic) {
        self.doorHeadResult = imageUrlDic[self.doorHeadImageView.image.imageHash] ? imageUrlDic[self.doorHeadImageView.image.imageHash] : self.doorHeadResult;
        self.licenseResult = imageUrlDic[self.licenseImageView.image.imageHash] ? imageUrlDic[self.licenseImageView.image.imageHash] : self.licenseResult;
        if (self.licenseResult && self.doorHeadResult) {
            completion(YES);
        }else{
            completion(NO);
        }
    }];
    
}

#pragma mark - YCTGetLocationViewControllerDelegate

- (void)locationDidSelectWithAll:(NSArray<YCTMintGetLocationModel *> *)locations
                        lastPrev:(YCTMintGetLocationModel *)lastPrev
                            last:(YCTMintGetLocationModel *)last {
    self.areaTextField.text = last.name;
    self.locationId = last.cid;
}

@end
