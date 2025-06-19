//
//  YCTLoginViewController.m
//  YCT
//
//  Created by hua-cloud on 2021/12/23.
//

#import "YCTOpenIDBindingViewController.h"
#import "YCTChooseCountryViewController.h"

@interface YCTOpenIDBindingViewController ()
@property (nonatomic, weak) IBOutlet UILabel *helloTitle;
@property (nonatomic, weak) IBOutlet UILabel *subTitle;

@property (nonatomic, weak) IBOutlet UILabel *phoneArea;
@property (nonatomic, weak) IBOutlet UIView *phoneSeparatorLine;
@property (nonatomic, weak) IBOutlet UILabel *phoneNumTitle;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumField;

@property (nonatomic, weak) IBOutlet UIStackView *codeContainer;
@property (nonatomic, weak) IBOutlet UILabel *codeTitle;
@property (nonatomic, weak) IBOutlet UITextField *code;
@property (nonatomic, weak) IBOutlet UILabel *codeCount;
@property (nonatomic, weak) IBOutlet UIButton *codeButton;

@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@property (nonatomic, copy) dispatch_block_t loginCompletion;
@property (nonatomic, strong) id<YCTOpenIDBindingViewModelProtocol> viewModel;
@end

@implementation YCTOpenIDBindingViewController

- (instancetype)initWithViewModel:(id<YCTOpenIDBindingViewModelProtocol>)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupView {
    self.phoneArea.textColor = UIColor.mainTextColor;
    self.phoneArea.font = [UIFont PingFangSCMedium:16];
    self.phoneArea.text = @"+86";
    
    self.helloTitle.text = YCTLocalizedTableString(@"login.hello", @"Login");
    self.subTitle.text = YCTLocalizedTableString(@"login.bind.helloSubTitle", @"Login");
    self.phoneNumTitle.text = YCTLocalizedTableString(@"login.phoneNum", @"Login");
    self.codeTitle.text = YCTLocalizedTableString(@"login.Captcha", @"Login");
    
    self.phoneNumField.placeholder = YCTLocalizedTableString(@"login.placeHolder.phoneNum", @"Login");
    self.code.placeholder = YCTLocalizedTableString(@"login.placeHolder.Captcha", @"Login");
    
    [self.codeButton setTitle:YCTLocalizedTableString(@"login.Obtain", @"Login") forState:UIControlStateNormal];
    
    [self.loginButton setTitle:YCTLocalizedTableString(@"login.confirm", @"Login") forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = 25;
}

- (void)bindViewModel {
    @weakify(self);
    
    self.phoneArea.userInteractionEnabled = YES;
    [self.phoneArea addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        @strongify(self);
        [self choosePhoneArea];
    }]];
    
    RAC(self.viewModel, mobile) = self.phoneNumField.rac_textSignal;
    RAC(self.viewModel, smsCode) = self.code.rac_textSignal;
    RAC(self.viewModel, phoneAreaNo) = RACObserve(self.phoneArea, text);
    self.loginButton.rac_command = self.viewModel.bindCommad;
    self.codeButton.rac_command = self.viewModel.codeCommad;
    
    RAC(self.codeCount, hidden) = [RACObserve(self.codeButton, selected) map:^id(id value) {
        return @(![value boolValue]);
    }];
    
    RAC(self.codeButton, hidden) = RACObserve(self.codeButton, selected);
    
    [RACObserve(self.loginButton, enabled) subscribeNext:^(id x) {
        @strongify(self);
        [self.loginButton setTintColor:UIColor.whiteColor];
        [self.loginButton setBackgroundColor: [x boolValue] ? UIColor.mainThemeColor : UIColorFromRGB(0xD9D9D9)];
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
        } else {
            [[YCTHud sharedInstance] hideHud];
        }
    }];
    
    [self.viewModel.bindCompletionSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:self.loginCompletion];
    }];
    
    [self.viewModel.needRegisterSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:self.class]) {
                [vcs removeObject:obj];
                *stop = YES;
            }
        }];
        YCTRegisterViewController *vc = [[YCTRegisterViewController alloc] init];
        self.viewModel.configResigerInfoBlock(vc);
        [vcs addObject:vc];
        [self.navigationController setViewControllers:vcs.copy animated:YES];
    }];
}

- (IBAction)verificationcodeverificationCodeButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    @weakify(self);
    __block int time = 60;
    self.codeCount.text = [NSString stringWithFormat:@"%dS", time];
    [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] takeUntilBlock:^BOOL(id x) {
        return time == 0;
    }] subscribeNext:^(id x) {
        @strongify(self);
        time --;
        self.codeCount.text = [NSString stringWithFormat:@"%dS", time];
        if (time <= 0) {
            sender.selected = NO;
        }
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

@end
