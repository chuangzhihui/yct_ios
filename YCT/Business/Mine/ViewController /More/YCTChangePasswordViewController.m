//
//  YCTChangePasswordViewController.m
//  YCT
//
//  Created by 木木木 on 2022/1/7.
//

#import "YCTChangePasswordViewController.h"
#import "YCTApiChangePassword.h"

@interface YCTChangePasswordViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

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

@implementation YCTChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"mine.title.password", @"Mine");
}

- (void)setupView {
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
    
    RAC(self.saveButton, enabled) = [RACSignal combineLatest:@[self.codeTextField.rac_textSignal, self.passwordTextField.rac_textSignal, self.rePasswordTextField.rac_textSignal] reduce:^(NSString *code, NSString *password, NSString *rePassword){
        return @(code.length > 0 && password.length > 0 && rePassword.length > 0);
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

- (IBAction)verificationCodeButtonClick:(UIButton *)sender {
    [[YCTHud sharedInstance] showLoadingHud];
    YCTApiChangePasswordSendSms *api = [[YCTApiChangePasswordSendSms alloc] init];
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
    YCTApiChangePassword *api = [[YCTApiChangePassword alloc] initWithPassword:self.passwordTextField.text smsCode:self.codeTextField.text];
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
