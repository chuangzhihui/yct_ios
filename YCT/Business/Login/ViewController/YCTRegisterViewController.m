//
//  YCTRegisterViewController.m
//  YCT
//
//  Created by hua-cloud on 2021/12/25.
//

#import "YCTRegisterViewController.h"
#import "JXCategoryTitleView+Customization.h"
#import "YCTRegisterViewModel.h"
#import "YCTImagePickerViewController.h"
#import "YCTGetLocationViewController.h"
#import "YCTChooseCountryViewController.h"
#import "YCTLocationManager.h"
#import "YCTMultiLineTextField.h"

@interface YCTRegisterViewController ()<JXCategoryViewDelegate,YCTGetLocationViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIStackView *coRegisterContainer;

@property (weak, nonatomic) IBOutlet UILabel *phoneTitle;
@property (weak, nonatomic) IBOutlet UILabel *codeTitle;
@property (weak, nonatomic) IBOutlet UILabel *coNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *areaTitle;
@property (weak, nonatomic) IBOutlet UILabel *adressTitle;
@property (weak, nonatomic) IBOutlet UILabel *webTitle;
@property (weak, nonatomic) IBOutlet UILabel *mailTitle;
@property (weak, nonatomic) IBOutlet UILabel *saleManagerTitle;
@property (weak, nonatomic) IBOutlet UILabel *licenseTitle;
@property (weak, nonatomic) IBOutlet UILabel *coNumberTitle;
@property (weak, nonatomic) IBOutlet UILabel *mainDirectionTitle;
@property (weak, nonatomic) IBOutlet UILabel *headPhotoTitle;
@property (weak, nonatomic) IBOutlet UILabel *nickNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *avatarTitle;

@property (weak, nonatomic) IBOutlet UILabel *phoneArea;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *coName;
@property (weak, nonatomic) IBOutlet UITextField *area;
@property (weak, nonatomic) IBOutlet YCTMultiLineTextField *adress;
@property (weak, nonatomic) IBOutlet UIButton *siteButton;
@property (weak, nonatomic) IBOutlet UITextField *web;
@property (weak, nonatomic) IBOutlet UITextField *mail;
@property (weak, nonatomic) IBOutlet UITextField *saleManager;
@property (weak, nonatomic) IBOutlet UITextField *coNumber;
@property (weak, nonatomic) IBOutlet UITextField *mainDirection;
@property (weak, nonatomic) IBOutlet UITextField *nickNameField;
@property (weak, nonatomic) IBOutlet UIImageView *licenseImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIButton *uploadAvatar;

@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UILabel *codeCount;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet YYLabel *ruleLabel;
#pragma mark - image

@property (weak, nonatomic) IBOutlet UIStackView *licenseButtonContainer;
@property (weak, nonatomic) IBOutlet UIStackView *headImageButtonContainer;

@property (weak, nonatomic) IBOutlet UIButton *deleteLicenseButton;
@property (weak, nonatomic) IBOutlet UILabel *licenseButtonTitle;

@property (weak, nonatomic) IBOutlet UIButton *deleteheadButton;
@property (weak, nonatomic) IBOutlet UILabel *headButtonTitle;

@property (strong, nonatomic) JXCategoryTitleView * segmentView;
@property (weak, nonatomic) IBOutlet UIView *segmentContainer;

@property (strong, nonatomic) YCTRegisterViewModel * viewModel;
@end

@implementation YCTRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self autoLocating];
}

- (void)setupView {
    self.phoneArea.textColor = UIColor.mainTextColor;
    self.phoneArea.font = [UIFont PingFangSCMedium:16];
    self.phoneArea.text = @"+86";

    self.phoneTitle.text = YCTLocalizedTableString(@"login.phoneNum", @"Login");
    self.codeTitle.text = YCTLocalizedTableString(@"login.Captcha", @"Login");
    self.coNameTitle.text = YCTLocalizedTableString(@"login.coName", @"Login");
    self.areaTitle.text = YCTLocalizedTableString(@"login.area", @"Login");
    self.adressTitle.text = YCTLocalizedTableString(@"login.adress", @"Login");
    self.webTitle.text = YCTLocalizedTableString(@"mine.upgradeToVendor.website", @"Mine");
    self.mailTitle.text = YCTLocalizedTableString(@"mine.upgradeToVendor.email", @"Mine");
    self.saleManagerTitle.text = YCTLocalizedTableString(@"mine.upgradeToVendor.saleLeader", @"Mine");
    self.coNumberTitle.text = YCTLocalizedTableString(@"mine.upgradeToVendor.companyPhone", @"Mine");
    self.mainDirectionTitle.text = YCTLocalizedTableString(@"login.mainDirection", @"Login");
    self.licenseTitle.text = YCTLocalizedTableString(@"login.license", @"Login");
    self.headPhotoTitle.text = YCTLocalizedTableString(@"login.head", @"Login");
    self.nickNameTitle.text = YCTLocalizedTableString(@"mine.edit.nickname", @"Mine");
    
    self.phoneNum.placeholder = YCTLocalizedTableString(@"login.placeHolder.phoneNum", @"Login");
    self.code.placeholder = YCTLocalizedTableString(@"login.placeHolder.Captcha", @"Login");
    self.coName.placeholder = YCTLocalizedTableString(@"login.inputCoName", @"Login");
    self.area.placeholder = YCTLocalizedTableString(@"login.chooseArea", @"Login");
    self.adress.placeholder = YCTLocalizedTableString(@"login.inputCoAdress", @"Login");
    self.web.placeholder = YCTLocalizedTableString(@"mine.upgradeToVendor.website.placeholder", @"Mine");
    self.mail.placeholder = YCTLocalizedTableString(@"mine.upgradeToVendor.email.placeholder", @"Mine");
    self.saleManager.placeholder = YCTLocalizedTableString(@"mine.upgradeToVendor.saleLeader.placeholder", @"Mine");
    self.coNumber.placeholder = YCTLocalizedTableString(@"mine.upgradeToVendor.companyPhone.placeholder", @"Mine");
    self.mainDirection.placeholder = YCTLocalizedTableString(@"login.mainDirection.placeHolder", @"Login");
    self.nickNameField.placeholder = YCTLocalizedTableString(@"mine.title.inputNickName", @"Mine");
    self.avatarTitle.text = YCTLocalizedTableString(@"login.titkeSettingAvatar", @"Login");
    [self.codeButton setTitle:YCTLocalizedTableString(@"login.Obtain", @"Login") forState:UIControlStateNormal];
    self.ruleLabel.text = YCTLocalizedTableString(@"login.rule", @"Login");
    self.ruleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
    self.ruleLabel.textColor = UIColor.subTextColor;
    self.ruleLabel.preferredMaxLayoutWidth = Iphone_Width - 62;
    
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:YCTLocalizedTableString(@"login.rule", @"Login")];
    
    [mutableString yy_setTextHighlightRange:[mutableString.string rangeOfString:YCTLocalizedTableString(@"login.user", @"Login")] color:UIColor.mainThemeColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
        NSLog(@"用户协议");
        [YCT_Helper showWebView:@"https://yct.vnppp.net/index.html#/agreement?id=13" title:YCTLocalizedTableString(@"login.user", @"Login")];
    }];
    
    [mutableString addAttributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:[mutableString.string rangeOfString:YCTLocalizedTableString(@"login.user", @"Login")]];
    
    [mutableString yy_setTextHighlightRange:[mutableString.string rangeOfString:YCTLocalizedTableString(@"login.policy", @"Login")] color:UIColor.mainThemeColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"隐私政策");
        [YCT_Helper showWebView:@"https://yct.vnppp.net/index.html#/agreement?id=14" title:YCTLocalizedTableString(@"login.policy", @"Login")];
    }];
    [mutableString addAttributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:[mutableString.string rangeOfString:YCTLocalizedTableString(@"login.policy", @"Login")]];
    self.ruleLabel.numberOfLines = 0;
    self.ruleLabel.preferredMaxLayoutWidth = Iphone_Width - 62;
    self.ruleLabel.attributedText = mutableString;
    
    
    self.adress.font = self.phoneNum.font;
    self.adress.textColor = self.phoneNum.textColor;
    self.adress.userInteractionEnabled = NO;
    
    self.licenseButtonTitle.text = YCTLocalizedTableString(@"login.photo", @"Login");
    self.headButtonTitle.text = YCTLocalizedTableString(@"login.photo", @"Login");
    
    self.headImage.layer.cornerRadius = 6;
    self.licenseImage.layer.cornerRadius = 6;
    self.registerButton.layer.cornerRadius = 25.f;
    self.uploadAvatar.layer.cornerRadius = 50.f;
    self.avatar.layer.cornerRadius = 50.f;
    [self.registerButton setTitle:YCTLocalizedTableString(@"login.register", @"Login") forState:UIControlStateNormal];
    [self.segmentContainer addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)bindViewModel {
    @weakify(self);
    
    self.phoneArea.userInteractionEnabled = YES;
    [self.phoneArea addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        @strongify(self);
        [self choosePhoneArea];
    }]];
    
    RAC(self.coRegisterContainer, hidden) = [RACObserve(self.segmentView, selectedIndex) map:^id(id value) {
        return  @([value integerValue] == 0);
    }];
    
    RAC(self.licenseButtonContainer, hidden) = [RACObserve(self.licenseImage, image) map:^id(id value) {
        return  @(value != nil);
    }];
    
    RAC(self.headImageButtonContainer, hidden) = [RACObserve(self.headImage, image) map:^id(id value) {
        return  @(value != nil);
    }];
    
    RAC(self.deleteLicenseButton, hidden) = [RACObserve(self.licenseImage, image) map:^id(id value) {
        return  @(value == nil);
    }];
    
    RAC(self.deleteheadButton, hidden) = [RACObserve(self.headImage, image) map:^id(id value) {
        return  @(value == nil);
    }];
    
    RAC(self.viewModel, phoneAreaNo) = RACObserve(self.phoneArea, text);
    RAC(self.viewModel, phoneNum) = self.phoneNum.rac_textSignal;
    RAC(self.viewModel, verificationCode) = self.code.rac_textSignal;
    RAC(self.viewModel, coName) = self.coName.rac_textSignal;
    RAC(self.viewModel, area) = [RACSignal merge:@[self.area.rac_textSignal,RACObserve(self.area, text)]];
    RAC(self.viewModel, adress) = self.adress.rac_textSignal;
    RAC(self.viewModel, web) = self.web.rac_textSignal;
    RAC(self.viewModel, mail) = self.mail.rac_textSignal;
    RAC(self.viewModel, saleManager) = self.saleManager.rac_textSignal;
    RAC(self.viewModel, coNumber) = self.coNumber.rac_textSignal;
    RAC(self.viewModel, mainDirection) = self.mainDirection.rac_textSignal;
    RAC(self.viewModel, licenseImage) = RACObserve(self.licenseImage, image);
    RAC(self.viewModel, headImage) = RACObserve(self.headImage, image);
    RAC(self.viewModel, nickName) = self.nickNameField.rac_textSignal;
    RAC(self.viewModel, isFirm) = [RACObserve(self.segmentView, selectedIndex) map:^id(id value) {
        return  @([value integerValue] == 1);
    }];
    RAC(self.viewModel, isAgree) = RACObserve(self.confirmButton, selected);
    
    if (self.avatarUrl) {
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:self.avatarUrl]];
    }
    
    self.registerButton.rac_command = self.viewModel.registerCommad;
    self.codeButton.rac_command = self.viewModel.codeCommad;
    
    RAC(self.codeCount, hidden) = [RACObserve(self.codeButton, selected) map:^id(id value) {
        return @(![value boolValue]);
    }];
    
    RAC(self.codeButton, hidden) = RACObserve(self.codeButton, selected);
    
    
    [RACObserve(self.registerButton, enabled) subscribeNext:^(id x) {
        @strongify(self);
        [self.registerButton setTintColor:UIColor.whiteColor];
        [self.registerButton setBackgroundColor: [x boolValue] ? UIColor.mainThemeColor : UIColorFromRGB(0xD9D9D9)];
    }];
    
    [RACObserve(self.codeButton, enabled) subscribeNext:^(id x) {
        @strongify(self);
        [self.codeButton setTintColor:UIColor.mainThemeColor];
        [self.codeButton setTitleColor:[x boolValue] ? UIColor.mainThemeColor : UIColor.mainGrayTextColor forState:UIControlStateNormal];
    }];
    
    
    [self.viewModel.toastSubject subscribeNext:^(id  _Nullable x) {
        [[YCTHud sharedInstance] showToastHud:x];
    }];
    
    [self.viewModel.loadingSubject subscribeNext:^(id  _Nullable x) {
        if ([x boolValue]) {
            [[YCTHud sharedInstance] showLoadingHud];
        }else{
            [[YCTHud sharedInstance] hideHud];
        }
    }];
    
    [self.viewModel.registerSuccessSubject subscribeNext:^(id  _Nullable x) {
        [self dismissViewControllerAnimated:YES completion:NULL];
//        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.siteButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self autoLocating];
    }];
}

- (IBAction)verificationCodeButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    @weakify(self);
    __block int time = 60;
    self.codeCount.text = [NSString stringWithFormat:@"%dS",time];
    [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] takeUntilBlock:^BOOL(id x) {
        return time == 0;
    }] subscribeNext:^(id x) {
        @strongify(self);
        time --;
        self.codeCount.text = [NSString stringWithFormat:@"%dS",time];
        if (time <= 0) {
            sender.selected = NO;
        }
    }];
}

- (IBAction)avatarPressed:(UIButton *)sender {
    @weakify(self);
    YCTImagePickerViewController *vc = [[YCTImagePickerViewController alloc] initWithMaxImagesCount:1 didFinishPickingPhotos:^(NSArray<UIImage *> * _Nonnull photos) {
        @strongify(self);
        self.avatar.image = [photos firstObject];
        self.viewModel.userAvatar = self.avatar.image;
        self.viewModel.avatarUrl = nil;
    }];
    [vc configCropSize:(CGSize){Iphone_Width, Iphone_Width}];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)licenseButtonPressed:(UIButton *)sender {
    @weakify(self);
    YCTImagePickerViewController *vc = [[YCTImagePickerViewController alloc] initWithMaxImagesCount:1 didFinishPickingPhotos:^(NSArray<UIImage *> * _Nonnull photos) {
        @strongify(self);
        self.licenseImage.image = [photos firstObject];
    }];
    [vc configCropSize:(CGSize){Iphone_Width, ceil((210.0 / 375.0) * Iphone_Width)}];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)headButtonPressed:(UIButton *)sender {
    @weakify(self);
    YCTImagePickerViewController *vc = [[YCTImagePickerViewController alloc] initWithMaxImagesCount:1 didFinishPickingPhotos:^(NSArray<UIImage *> * _Nonnull photos) {
        @strongify(self);
        self.headImage.image = [photos firstObject];
    }];
    [vc configCropSize:(CGSize){Iphone_Width, ceil((210.0 / 375.0) * Iphone_Width)}];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)chooseAreaButtonPressed:(UIButton *)sender {
    YCTGetLocationViewController *vc = [[YCTGetLocationViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)deleteLicenseImageButtonPressed:(UIButton *)sender {
    self.licenseImage.image = nil;
}

- (IBAction)deleteHeadImageButtonPressed:(UIButton *)sender {
    self.headImage.image = nil;
}

- (IBAction)confirmButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)choosePhoneArea {
    YCTChooseCountryViewController *vc = [[YCTChooseCountryViewController alloc] init];
    @weakify(self);
    vc.choosePhoneAreaBlock = ^(NSString * _Nonnull no, NSString * _Nonnull name) {
        @strongify(self);
        self.phoneArea.text = no;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)autoLocating {
    [[YCTLocationManager sharedInstance] requestLocationWithCompletion:^(YCTLocationResultModel * _Nullable model, NSError * _Nullable error) {
        if (model) {
            self.adress.text = model.formattedAddress;
        } else {
            [[YCTHud sharedInstance] showDetailToastHud:error.localizedDescription];
        }
    }];
}

#pragma mark -
- (void)locationDidSelectWithAll:(NSArray<YCTMintGetLocationModel *> *)locations
                        lastPrev:(YCTMintGetLocationModel *)lastPrev
                            last:(YCTMintGetLocationModel *)last{
    self.area.text = [NSString stringWithFormat:@"%@",last.name];
    self.viewModel.locationId = last.cid;
}

#pragma mark - JXCategoryViewDelegate

#pragma mark - getter
- (JXCategoryTitleView *)segmentView{
    if (!_segmentView) {
        _segmentView = [JXCategoryTitleView normalCategoryTitleView];
        _segmentView.titleFont = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
        _segmentView.titleSelectedFont = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
        _segmentView.titleColor = UIColorFromRGB(0x2C2C2C);
        _segmentView.titleSelectedColor = UIColorFromRGB(0x2C2C2C);
        _segmentView.cellSpacing = 0;
        _segmentView.contentEdgeInsetLeft = 40;
        _segmentView.contentEdgeInsetRight = 40;
        _segmentView.averageCellSpacingEnabled = NO;
        _segmentView.cellWidth = (Iphone_Width - 80)/2;
        _segmentView.hidden = YES;
        _segmentView.titles = @[
            YCTLocalizedTableString(@"login.UserSignUp", @"Login"),
            YCTLocalizedTableString(@"login.firm", @"Login"),];
        UIView *line = [_segmentView viewWithTag:kLineViewTag];
        [line removeFromSuperview];
    }
    return _segmentView;
}

- (YCTRegisterViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YCTRegisterViewModel alloc] init];
        _viewModel.unionid = self.unionid;
        _viewModel.zlId = self.zlId;
        _viewModel.nickName = self.nickName;
        _viewModel.avatarUrl = self.avatarUrl;
        
    }
    return _viewModel;
}
@end
