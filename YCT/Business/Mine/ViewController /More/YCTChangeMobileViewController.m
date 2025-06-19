//
//  YCTChangeMobileViewController.m
//  YCT
//
//  Created by 木木木 on 2022/3/16.
//

#import "YCTChangeMobileViewController.h"
#import "YCTApiSendSmsCode.h"
#import "YCTApiChangePhoneNumber.h"
#import "YCTChooseCountryViewController.h"

@interface YCTChangeMobileViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *codeTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UILabel *codeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@property (weak, nonatomic) IBOutlet UILabel *mobileTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UILabel *phoneNewArea;
@property (weak, nonatomic) IBOutlet UILabel *codeNewTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeNewTextField;
@property (weak, nonatomic) IBOutlet UILabel *codeNewCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *codeNewButton;

@property (weak, nonatomic) IBOutlet UILabel *mobileNewTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *mobileNewTextField;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation YCTChangeMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"mine.title.changeMobilePhoneNo", @"Mine");
}

- (void)setupView {
    self.phoneNewArea.textColor = UIColor.mainTextColor;
    self.phoneNewArea.font = [UIFont PingFangSCMedium:16];
    self.phoneNewArea.text = @"+86";
    
    self.codeTitleLabel.text = YCTLocalizedTableString(@"login.Captcha", @"Login");
    self.codeNewTitleLabel.text = YCTLocalizedTableString(@"login.Captcha", @"Login");
    
    self.codeTextField.placeholder = YCTLocalizedTableString(@"login.placeHolder.Captcha", @"Login");
    self.codeNewTextField.placeholder = YCTLocalizedTableString(@"login.placeHolder.Captcha", @"Login");
    
    [self.codeButton setTitle:YCTLocalizedTableString(@"login.Obtain", @"Login") forState:UIControlStateNormal];
    [self.codeNewButton setTitle:YCTLocalizedTableString(@"login.Obtain", @"Login") forState:UIControlStateNormal];
    
    self.mobileTitleLabel.text = YCTLocalizedTableString(@"mine.changeMobilePhoneNo.oriPhoneNo", @"Mine");
    self.mobileTextField.placeholder = YCTLocalizedTableString(@"mine.changeMobilePhoneNo.placeHolder.oriPhoneNo", @"Mine");
    
    self.mobileNewTitleLabel.text = YCTLocalizedTableString(@"mine.changeMobilePhoneNo.newPhoneNo", @"Mine");
    self.mobileNewTextField.placeholder = YCTLocalizedTableString(@"mine.changeMobilePhoneNo.placeHolder.newPhoneNo", @"Mine");
        
    [self.saveButton setTitle:YCTLocalizedTableString(@"mine.password.save", @"Mine") forState:UIControlStateNormal];
    self.saveButton.layer.cornerRadius = 25;
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.scrollView.mj_insetT = kNavigationBarHeight;
}

- (void)bindViewModel {
    @weakify(self);
    
    self.phoneNewArea.userInteractionEnabled = YES;
    [self.phoneNewArea addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        @strongify(self);
        [self choosePhoneArea];
    }]];
    
    RAC(self.codeCountLabel, hidden) = [RACObserve(self.codeButton, selected) map:^id(id value) {
        return @(![value boolValue]);
    }];
    
    RAC(self.codeNewCountLabel, hidden) = [RACObserve(self.codeNewButton, selected) map:^id(id value) {
        return @(![value boolValue]);
    }];
    
    RAC(self.codeButton, hidden) = RACObserve(self.codeButton, selected);
    
    RAC(self.codeNewButton, hidden) = RACObserve(self.codeNewButton, selected);
    
    RAC(self.saveButton, enabled) = [RACSignal combineLatest:@[self.codeTextField.rac_textSignal, self.codeNewTextField.rac_textSignal, self.mobileTextField.rac_textSignal, self.mobileNewTextField.rac_textSignal] reduce:^(NSString *code, NSString *codeNew, NSString *mobile, NSString *mobileNew){
        return @(
        code.length > 0 &&
        codeNew.length > 0 &&
        mobile.length > 0 &&
        mobileNew.length > 0
        );
    }];
    
    [RACObserve(self.saveButton, enabled) subscribeNext:^(id x) {
        @strongify(self);
        [self.saveButton setTintColor:UIColor.whiteColor];
        [self.saveButton setBackgroundColor: [x boolValue] ? UIColor.mainThemeColor : UIColorFromRGB(0xD9D9D9)];
    }];
    
    [RACObserve(self.codeButton, enabled) subscribeNext:^(id x) {
        @strongify(self);
        [self.codeButton setTintColor:UIColor.mainThemeColor];
        [self.codeButton setTitleColor:[x boolValue] ? UIColor.mainThemeColor : UIColor.mainGrayTextColor forState:UIControlStateNormal];
    }];
}

- (IBAction)oriPhoneNumberVerificationCodeClick:(UIButton *)sender {
    if (![self.mobileTextField.text isEqualToString:[YCTUserDataManager sharedInstance].userInfoModel.mobile]) {
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.changeMobilePhoneNo.alert.checkOriPhoneNumber", @"Mine")];
        return;
    }
    
    [[YCTHud sharedInstance] showLoadingHud];
    YCTApiSendSmsCodeForChangePhone *api = [[YCTApiSendSmsCodeForChangePhone alloc] init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        [self startCountDown:sender countDownLabel:self.codeCountLabel codeTextField:self.codeTextField];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (IBAction)newPhoneNumberVerificationCodeClick:(UIButton *)sender {
    if ([self.mobileNewTextField.text isEqualToString:[YCTUserDataManager sharedInstance].userInfoModel.mobile]) {
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.changeMobilePhoneNo.alert", @"Mine")];
        return;
    }
    
    [[YCTHud sharedInstance] showLoadingHud];
    YCTApiSendSmsCode *api = [[YCTApiSendSmsCode alloc] initWithMobile:self.mobileNewTextField.text key:k_changephoneReg phoneAeaNo:self.phoneNewArea.text];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        [self startCountDown:sender countDownLabel:self.codeNewCountLabel codeTextField:self.codeNewTextField];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (void)startCountDown:(UIButton *)sender
        countDownLabel:(UILabel *)countDownLabel
         codeTextField:(UITextField *)codeTextField {
    [codeTextField becomeFirstResponder];
    sender.selected = !sender.selected;
    __block int time = 60;
    countDownLabel.text = [NSString stringWithFormat:@"%dS",time];
    [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] takeUntilBlock:^BOOL(id x) {
        return time == 0;
    }] subscribeNext:^(id x) {
        time --;
        countDownLabel.text = [NSString stringWithFormat:@"%dS",time];
        if (time <= 0) {
            sender.selected = NO;
        }
    }];
}

- (IBAction)saveNewPhoneNumer:(id)sender {
    [self.view endEditing:YES];
    
    if (![self.mobileTextField.text isEqualToString:[YCTUserDataManager sharedInstance].userInfoModel.mobile]) {
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.changeMobilePhoneNo.alert.checkOriPhoneNumber", @"Mine")];
        return;
    }
    
    if ([self.mobileNewTextField.text isEqualToString:[YCTUserDataManager sharedInstance].userInfoModel.mobile]) {
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.changeMobilePhoneNo.alert", @"Mine")];
        return;
    }
    
    [[YCTHud sharedInstance] showLoadingHud];
    YCTApiChangePhoneNumber *api = [[YCTApiChangePhoneNumber alloc] init];
    api.mobile = self.mobileNewTextField.text;
    api.originalSmsCode = self.codeTextField.text;
    api.smsCode = self.codeNewTextField.text;
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showSuccessHud:request.getMsg];
        [[YCTHud sharedInstance] hideHudAfterDelay:kDefaultDelayTimeInterval completion:^{
            [[YCTUserManager sharedInstance] logout];
        }];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (void)choosePhoneArea {
    YCTChooseCountryViewController *vc = [[YCTChooseCountryViewController alloc] init];
    @weakify(self);
    vc.choosePhoneAreaBlock = ^(NSString * _Nonnull no, NSString * _Nonnull name) {
        @strongify(self);
        self.phoneNewArea.text = no;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end
