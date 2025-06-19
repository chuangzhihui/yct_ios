//
//  YCTForgetPassViewController.m
//  YCT
//
//  Created by hua-cloud on 2022/3/17.
//

#import "YCTForgetPassViewController.h"
#import "YCTApiChangePassword.h"
#import "YCTApiSendSmsCode.h"
#import "YCTApiForgetPassword.h"
#import "YCTChooseCountryViewController.h"

@interface YCTForgetPassViewController ()
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *phoneTitle;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UILabel *phoneArea;

@property (weak, nonatomic) IBOutlet UILabel *codeTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UILabel *codeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@property (weak, nonatomic) IBOutlet UILabel *passwordTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *showPasswordButton;

@property (weak, nonatomic) IBOutlet UILabel *rePasswordTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *showRePasswordButton;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@end

@implementation YCTForgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"mine.title.password", @"Mine");
}

- (void)setupView {
    self.phoneArea.textColor = UIColor.mainTextColor;
    self.phoneArea.font = [UIFont PingFangSCMedium:16];
    self.phoneArea.text = @"+86";
    self.phoneTitle.text = YCTLocalizedTableString(@"login.phoneNum", @"Login");
    self.phone.placeholder = YCTLocalizedTableString(@"login.placeHolder.phoneNum", @"Login");
    self.codeTitleLabel.text = YCTLocalizedTableString(@"login.Captcha", @"Login");
    self.passwordTitleLabel.text = YCTLocalizedTableString(@"mine.password.newPassword", @"Mine");
    self.rePasswordTitleLabel.text = YCTLocalizedTableString(@"mine.password.newPassword", @"Mine");
    
    self.codeTextField.placeholder = YCTLocalizedTableString(@"login.placeHolder.Captcha", @"Login");
    self.passwordTextField.placeholder = YCTLocalizedTableString(@"mine.password.placeHolder.newPassword", @"Mine");
    self.rePasswordTextField.placeholder = YCTLocalizedTableString(@"mine.password.placeHolder.reNewPassword", @"Mine");
    
    [self.codeButton setTitle:YCTLocalizedTableString(@"login.Obtain", @"Login") forState:UIControlStateNormal];
    
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
    self.phoneArea.userInteractionEnabled = YES;
    [self.phoneArea addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        @strongify(self);
        [self choosePhoneArea];
    }]];
    
    RAC(self.passwordTextField, secureTextEntry) = [RACObserve(self.showPasswordButton, selected) map:^id _Nullable(id  _Nullable value) {
        return @(![value boolValue]);
    }];
    
    RAC(self.rePasswordTextField, secureTextEntry) = [RACObserve(self.showRePasswordButton, selected) map:^id _Nullable(id  _Nullable value) {
        return @(![value boolValue]);
    }];
    
    RAC(self.codeCountLabel, hidden) = [RACObserve(self.codeButton, selected) map:^id(id value) {
        return @(![value boolValue]);
    }];
    
    RAC(self.codeButton, hidden) = RACObserve(self.codeButton, selected);
    
    RAC(self.saveButton, enabled) = [RACSignal combineLatest:@[self.phone.rac_textSignal,self.codeTextField.rac_textSignal, self.passwordTextField.rac_textSignal, self.rePasswordTextField.rac_textSignal] reduce:^(NSString *phone,NSString *code, NSString *password, NSString *rePassword){
        return @(phone.length > 0 && code.length > 0 && password.length > 0 && rePassword.length > 0);
    }];
    
    RAC(self.codeButton, enabled) = [self.phone.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length > 0);
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

- (void)choosePhoneArea {
    YCTChooseCountryViewController *vc = [[YCTChooseCountryViewController alloc] init];
    @weakify(self);
    vc.choosePhoneAreaBlock = ^(NSString * _Nonnull no, NSString * _Nonnull name) {
        @strongify(self);
        self.phoneArea.text = no;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)verificationCodeButtonClick:(UIButton *)sender {
    [[YCTHud sharedInstance] showLoadingHud];
    YCTApiSendSmsCode *api = [[YCTApiSendSmsCode alloc] initWithMobile:self.phone.text key:k_passwordreg phoneAeaNo:self.phoneArea.text];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        [self startCountDown:sender];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (void)startCountDown:(UIButton *)sender {
    [self.codeTextField becomeFirstResponder];
    
    sender.selected = !sender.selected;
    @weakify(self);
    __block int time = 60;
    self.codeCountLabel.text = [NSString stringWithFormat:@"%dS",time];
    [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] takeUntilBlock:^BOOL(id x) {
        return time == 0;
    }] subscribeNext:^(id x) {
        @strongify(self);
        time --;
        self.codeCountLabel.text = [NSString stringWithFormat:@"%dS",time];
        if (time <= 0) {
            sender.selected = NO;
        }
    }];
}

- (IBAction)saveNewPassword:(id)sender {
    if (![self.passwordTextField.text isEqualToString:self.rePasswordTextField.text]) {
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.password.alert.password", @"Mine")];
        return;
    }
    
    [self.view endEditing:YES];
    
    [[YCTHud sharedInstance] showLoadingHud];
    YCTApiForgetPassword *api = [[YCTApiForgetPassword alloc] initWithMobile:self.phone.text smsCode:self.codeTextField.text phoneAreaNo:self.phoneArea.text password:self.passwordTextField.text];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showSuccessHud:request.getMsg];
        [[YCTHud sharedInstance] hideHudAfterDelay:kDefaultDelayTimeInterval completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (IBAction)showPasswordButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)showRePasswordButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
