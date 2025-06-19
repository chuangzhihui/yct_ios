//
//  YCTLoginViewController.m
//  YCT
//
//  Created by hua-cloud on 2021/12/23.
//

#import "YCTLoginViewController.h"
#import "YCTRegisterViewController.h"
#import "YCTLoginViewModel.h"
#import "YCTChooseCountryViewController.h"
#import "YCTOpenIDBindingViewController.h"
#import "YCTWeChatLoginBindingViewModel.h"
#import "YCTZaloLoginBindingViewModel.h"
#import "YCTApiWeChatLogin.h"
#import "YCTApiZaloLogin.h"
#import "YCTApiWeChatUserinfo.h"
#import "YCTApiWeChatAccessToken.h"
#import "YCTForgetPassViewController.h"
#import "YCTApiLoginType.h"
#import "YCTApiFaceBookLogin.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "YCTFaceLoginBindingViewModel.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "YCT-Bridging-Header.h"
#import "YCT-Swift.h"
#import "YCTApiUploadUserRegId.h"
#import "JPUSHService.h"
#import "YCT-Swift.h"
@class LineLoginManager;

@import GoogleSignIn;
@interface YCTLoginViewController ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
@property (weak, nonatomic) IBOutlet UILabel *helloTitle;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@property (weak, nonatomic) IBOutlet UILabel *phoneArea;
@property (weak, nonatomic) IBOutlet UIView *phoneSeparatorLine;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumTitle;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;

@property (weak, nonatomic) IBOutlet UIStackView *codeContainer;
@property (weak, nonatomic) IBOutlet UILabel *codeTitle;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UILabel *codeCount;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@property (weak, nonatomic) IBOutlet UIStackView *passContainer;
@property (weak, nonatomic) IBOutlet UILabel *passTitle;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *showPassButton;

@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UIButton *passLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UILabel *thirdLoginTitle;
@property (weak, nonatomic) IBOutlet YYLabel *ruleLabel;

@property (nonatomic, copy) dispatch_block_t loginCompletion;
@property (strong, nonatomic) YCTLoginViewModel * viewModel;

@property (weak, nonatomic) IBOutlet UIButton *appleLogin;
@end

@implementation YCTLoginViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (BOOL)naviagtionBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestHelp];
    
    if (@available(iOS 13.0, *)) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    } else {
        //self.appleLogin.hidden=YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //    [[LiveStreamManager shared] initLivestream];
    //    [[LiveStreamManager shared] createLivestreamFromVC:<#(UIViewController * _Nonnull)#> title:<#(NSString * _Nonnull)#>];
}

#pragma mark- apple授权状态 更改通知
- (void)handleSignInWithAppleStateChanged:(NSNotification *)notification{
    NSLog(@"登录通知%@", notification.userInfo);
}
- (void)dealloc {
    if (@available(iOS 13.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
- (void)requestHelp {
    
    [[[YCTApiLoginType alloc] init] startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        
        NSDictionary *res=[self dictionaryWithJsonString:request.responseString];
        if(res==nil){
            return;
        }
        NSDictionary *data=[res objectForKey:@"data"];
        if(data==NULL){
            return;
        }
        NSString *allow=[data objectForKey:@"allow"];
        
        //        YCTCheckLoginModel * check= request.responseObject;
        if([allow isEqualToString:@"1"]){
            self.thirdLoginTitle.hidden=NO;
            UIButton *wxlogin = (UIButton *)[self.view viewWithTag:999];
            wxlogin.hidden=NO;
            //            UIButton *zlLogin = (UIButton *)[self.view viewWithTag:998];
            //            zlLogin.hidden=NO;
        }
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}
- (void)setupView {
    
    self.phoneArea.textColor = UIColor.mainTextColor;
    self.phoneArea.font = [UIFont PingFangSCMedium:16];
    self.phoneArea.text = @"+86";
    
    self.helloTitle.text = YCTLocalizedTableString(@"login.hello", @"Login");
    self.subTitle.text = YCTLocalizedTableString(@"login.helloSubTitle", @"Login");
    self.phoneNumTitle.text = YCTLocalizedTableString(@"login.phoneNum", @"Login");
    self.codeTitle.text = YCTLocalizedTableString(@"login.Captcha", @"Login");
    self.passTitle.text = YCTLocalizedTableString(@"login.Password", @"Login");
    self.thirdLoginTitle.text = YCTLocalizedTableString(@"login.third", @"Login");
    
    self.ruleLabel.text = YCTLocalizedTableString(@"login.rule", @"Login");
    self.ruleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
    self.ruleLabel.textColor = UIColor.subTextColor;
    self.ruleLabel.preferredMaxLayoutWidth = Iphone_Width - 62;
    
    self.phoneNumField.placeholder = YCTLocalizedTableString(@"login.placeHolder.phoneNum", @"Login");
    self.code.placeholder = YCTLocalizedTableString(@"login.placeHolder.Captcha", @"Login");
    self.password.placeholder = YCTLocalizedTableString(@"login.placeHolder.Password", @"Login");
    
    [self.codeButton setTitle:YCTLocalizedTableString(@"login.Obtain", @"Login") forState:UIControlStateNormal];
    
    [self.registerButton setTitle:YCTLocalizedTableString(@"login.SignUp", @"Login") forState:UIControlStateNormal];
    [self.forgetButton setTitle:YCTLocalizedTableString(@"login.SignUp", @"Login") forState:UIControlStateNormal];
    [self.forgetButton setTitle:YCTLocalizedTableString(@"login.forgetPass", @"Login") forState:UIControlStateSelected];
    [self.passLoginButton setTitle:YCTLocalizedTableString(@"login.PasswordLogin", @"Login") forState:UIControlStateNormal];
    [self.passLoginButton setTitle:YCTLocalizedTableString(@"login.CaptchaLogin", @"Login") forState:UIControlStateSelected];
    [self.loginButton setTitle:YCTLocalizedTableString(@"login.login", @"Login") forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = 25;
    self.registerButton.layer.cornerRadius = 25.f;
    
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
    
    //隐藏
    self.thirdLoginTitle.hidden=YES;
    UIButton *wxlogin = (UIButton *)[self.view viewWithTag:999];
    wxlogin.hidden=YES;
    UIButton *zlLogin = (UIButton *)[self.view viewWithTag:998];
    zlLogin.hidden=YES;
}

- (void)bindViewModel {
    @weakify(self);
    
    self.phoneArea.userInteractionEnabled = YES;
    [self.phoneArea addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        @strongify(self);
        [self choosePhoneArea];
    }]];
    
    RAC(self.viewModel, phoneNum) = self.phoneNumField.rac_textSignal;
    RAC(self.viewModel, verificationCode) = self.code.rac_textSignal;
    RAC(self.viewModel, passWord) = self.password.rac_textSignal;
    RAC(self.viewModel, isAgree) = RACObserve(self.confirmButton, selected);
    RAC(self.viewModel, isPassLogin) = RACObserve(self.passLoginButton, selected);
    RAC(self.viewModel, phoneAreaNo) = RACObserve(self.phoneArea, text);
    RAC(self.forgetButton, selected) = RACObserve(self.passLoginButton, selected);
    RAC(self.registerButton, hidden) = [RACObserve(self.passLoginButton, selected) map:^id _Nullable(id  _Nullable value) {
        return @(!self.passLoginButton.selected);
    }];
    self.loginButton.rac_command = self.viewModel.loginCommad;
    self.codeButton.rac_command = self.viewModel.codeCommad;
    
    
    RAC(self.phoneArea, hidden) = RACObserve(self.passLoginButton, selected);
    RAC(self.phoneSeparatorLine, hidden) = RACObserve(self.passLoginButton, selected);
    
    RAC(self.passContainer, hidden) = [RACObserve(self.passLoginButton, selected) map:^id(id value) {
        return @(![value boolValue]);
    }];
    
    RAC(self.codeCount, hidden) = [RACObserve(self.codeButton, selected) map:^id(id value) {
        return @(![value boolValue]);
    }];
    
    RAC(self.codeButton, hidden) = RACObserve(self.codeButton, selected);
    
    RAC(self.codeContainer, hidden) = RACObserve(self.passLoginButton, selected);
    
    RAC(self.password, secureTextEntry) = [RACObserve(self.showPassButton, selected) map:^id _Nullable(id  _Nullable value) {
        return @(![value boolValue]);
    }];
    
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
    
    [self.viewModel.loginCompletionSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:self.loginCompletion];
    }];
}

- (void)setLoginCompletiom:(dispatch_block_t)loginCompletion {
    _loginCompletion = loginCompletion;
}

- (IBAction)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)forgetButtonPressed:(UIButton *)sender {
    if (sender.selected) {
        YCTForgetPassViewController * vc = [YCTForgetPassViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        YCTRegisterViewController * vc = [YCTRegisterViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)registerButtonPressed:(UIButton *)sender {
    YCTRegisterViewController * vc = [YCTRegisterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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

- (IBAction)confirmButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)loginTypeButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)showPassWordButtonClick:(UIButton *)sender {
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

- (IBAction)weChatLoginPressed:(id)sender {
    [[YCTOpenPlatformManager defaultManager] authenticationWithPlatformType:(YCTOpenPlatformTypeWeChatSession) inViewController:self completion:^(id result, NSError *error) {
        if (error) {
            [[YCTHud sharedInstance] showDetailToastHud:error.localizedDescription];
        } else {
            [[YCTHud sharedInstance] showLoadingHud];
            YCTApiWeChatAccessToken *api = [[YCTApiWeChatAccessToken alloc] initWithAppId:kWxAppID secret:kWxSecret code:result];
            [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
                [self fetchWeChatInfoWithAccessToken:request.responseDataModel];
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedString(@"alert.loginFailed")];
            }];
        }
    }];
}

- (void)fetchWeChatInfoWithAccessToken:(YCTWeChatAccessTokenModel *)accessToken {
    YCTApiWeChatUserinfo *api = [[YCTApiWeChatUserinfo alloc] initWithAccessToken:accessToken.access_token openId:accessToken.openid];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [self requestWeChatLogin:request.responseDataModel];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedString(@"alert.loginFailed")];
    }];
}

- (void)requestWeChatLogin:(YCTWeChatUserinfoModel *)userInfoModel {
    YCTApiWeChatLogin *api = [[YCTApiWeChatLogin alloc] init];
    api.code = userInfoModel.unionid;
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        YCTWeChatLoginModel *model = request.responseDataModel;
        /// 需要绑定手机号
        if (model.needBind) {
            YCTWeChatLoginBindingViewModel *viewModel = [[YCTWeChatLoginBindingViewModel alloc] init];
            viewModel.unionId = userInfoModel.unionid;
            viewModel.avatar = userInfoModel.headimgurl;
            viewModel.nickName = userInfoModel.nickname;
            YCTOpenIDBindingViewController *vc = [[YCTOpenIDBindingViewController alloc] initWithViewModel:viewModel];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [[YCTUserManager sharedInstance] loginWithModel:model];
            [self dismissViewControllerAnimated:YES completion:self.loginCompletion];
        }
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (IBAction)zaloLoginPressed:(id)sender {
    [[YCTOpenPlatformManager defaultManager] authenticationWithPlatformType:(YCTOpenPlatformTypeZalo) inViewController:self completion:^(id result, NSError *error) {
        if (error) {
            [[YCTHud sharedInstance] showDetailToastHud:error.localizedDescription];
        } else {
            [self onAuthSuccess:@"feiqi" type:@"zalo" nickName:@"" email:@""];
        }
    }];
}
- (IBAction)faceBookLoginPressed:(id)sender {
    NSLog(@"点击facebook登录");
    FBSDKLoginManager * loginManager=[[FBSDKLoginManager alloc] init];
    
    //    loginManager.loginBehavior = FBSDKLoginBehaviorBrowser; // 优先客户端方式
    
    //    if(![[FBSDKAccessToken currentAccessToken] hasGranted:@"public_profile"]){
    //
    //    }else{
    //        [[YCTHud sharedInstance] showDetailToastHud:@"没有public_profile权限"];
    //    }
    [loginManager logInWithPermissions:@[@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        if(error)
        {
            [[YCTHud sharedInstance] showDetailToastHud:[NSString stringWithFormat:@"错误:%@",error.userInfo]];
            NSLog(@"error:%@",error);
        }else if(result.isCancelled)
        {
            [[YCTHud sharedInstance] showDetailToastHud:@"点击了取消"];
            NSLog(@"cancle");
            //            [self onAuthSuccess:@"ceshifbId" type:@"fb"];
        }else{
            [[YCTHud sharedInstance] showDetailToastHud:[NSString stringWithFormat:@"点击了同意，userId:%@",result.token.userID]];
            NSLog(@"result:%@",result.token.userID);
            NSString *userId=result.token.userID;
            [self onAuthSuccess:userId type:@"fb" nickName:@""  email:@""];
        }
    }];
    
    
}
- (IBAction)ggLoginPressed:(id)sender {
    NSLog(@"点击google登录");
    GIDSignIn*signIn = [GIDSignIn sharedInstance];
    GIDConfiguration *config=[[GIDConfiguration alloc] initWithClientID:@"626193180281-s2a4s57c8h08onuvhe8kng8rb37csgbi.apps.googleusercontent.com"];
    
    
    [signIn signInWithPresentingViewController:self completion:^(GIDSignInResult * _Nullable result, NSError * _Nullable error) {
        if(!error) {
            [self onAuthSuccess:result.user.userID type:@"google"  nickName:result.user.profile.name  email:result.user.profile.email];
        }
    }];
//    [signIn signInWithConfiguration:config presentingViewController:self callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
//        NSLog(@"调用回调:");
//        
//    }];
    
}
- (IBAction)appleLoginPressed:(id)sender {
    NSLog(@"点击apple登录");
    if (@available(iOS 13.0, *)) {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider * appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest * authAppleIDRequest = [appleIDProvider createRequest];
        // 在用户授权期间请求的联系信息
        //        authAppleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        //如果 KeyChain 里面也有登录信息的话，可以直接使用里面保存的用户名和密码进行登录。
        //        ASAuthorizationPasswordRequest * passwordRequest = [[[ASAuthorizationPasswordProvider alloc] init] createRequest];
        
        NSMutableArray <ASAuthorizationRequest *> * array = [NSMutableArray arrayWithCapacity:2];
        if (authAppleIDRequest) {
            [array addObject:authAppleIDRequest];
        }
        //        if (passwordRequest) {
        //            [array addObject:passwordRequest];
        //        }
        NSArray <ASAuthorizationRequest *> * requests = [array copy];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController * authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }
    
}


- (IBAction)loginLinePress:(id)sender {
    // Assuming you are in an Objective-C class
    [[LineLoginManager shared] loginFrom:self completion:^(NSString * _Nullable userID, NSString * _Nullable displayName, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error during LINE login: %@", error.localizedDescription);
        } else {
            NSLog(@"Login successful, UserID: %@, Display Name: %@", userID, displayName);
            // Pass the userID and displayName to your `onAuthSuccess` method
            [self onAuthSuccess:(userID) type:@"line" nickName:(displayName) email:@""];
        }
    }];
    
}

// 授权成功
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    NSLog(@"授权成功!");
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        
        ASAuthorizationAppleIDCredential * credential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        
        // 苹果用户唯一标识符，该值在同一个开发者账号下的所有 App 下是一样的，开发者可以用该唯一标识符与自己后台系统的账号体系绑定起来。
        NSString * userID = credential.user;
        // 获取苹果用户的姓名信息（仅首次授权获取，之后为nil）
        NSPersonNameComponents *fullName = credential.fullName;
        NSString *firstName = fullName.givenName ?: @"";
        NSString *lastName = fullName.familyName ?: @"";
        NSString *fullNameString = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        [self onAuthSuccess:userID type:@"apple"  nickName:fullNameString  email:@""];
        NSLog(@"1UID:%@",userID);
        //把用户的唯一标识 传给后台 判断该用户是否绑定手机号，如果绑定了直接登录，如果没绑定跳绑定手机号页面
        //        // 苹果用户信息 如果授权过，可能无法再次获取该信息
        
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 这个获取的是iCloud记录的账号密码，需要输入框支持iOS 12 记录账号密码的新特性，如果不支持，可以忽略
        // 用户登录使用现有的密码凭证
        ASPasswordCredential * passwordCredential = (ASPasswordCredential *)authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString * user = passwordCredential.user;
        NSLog(@"2UID:%@",user);
        [self onAuthSuccess:user type:@"apple"  nickName:@"" email:@"" ];
        //把用户的唯一标识 传给后台 判断该用户是否绑定手机号，如果绑定了直接登录，如果没绑定跳绑定手机号页面
        
        //        // 密码凭证对象的密码
        //        NSString * password = passwordCredential.password;
        //        NSLog(@"userID: %@", user);
        //        NSLog(@"password: %@", password);
        
    } else {
        
    }
}
// 授权失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    NSLog(@"授权失败%@", errorMsg);
}
#pragma mark- ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    return self.view.window;
}
/**
 type 1zalo  2fb 3谷歌 4苹果
 */
-(void)onAuthSuccess:(NSString *)userId type:(NSString *)type nickName:(NSString *)nickName email:(NSString *)email
{
    [[YCTHud sharedInstance] showLoadingHud];
    YCTApiWeChatLogin *api = [[YCTApiWeChatLogin alloc] init];
    api.code = userId;
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        YCTWeChatLoginModel *model = request.responseDataModel;
        /// 需要绑定手机号
        if (model.needBind) {
            YCTWeChatLoginBindingViewModel *viewModel = [[YCTWeChatLoginBindingViewModel alloc] init];
            viewModel.unionId = userId;
            viewModel.avatar = @"";
            viewModel.nickName = nickName;
            viewModel.loginType = type;
            if ([type  isEqual: @"google"] && ![email  isEqual: @""]) {
                viewModel.mobile = email;
                [self bindApiCall:(viewModel)];
            } else {
                [[YCTHud sharedInstance] hideHud];
                YCTOpenIDBindingViewController *vc = [[YCTOpenIDBindingViewController alloc] initWithViewModel:viewModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            [[YCTHud sharedInstance] hideHud];
            [[YCTUserManager sharedInstance] loginWithModel:model];
            [self dismissViewControllerAnimated:YES completion:self.loginCompletion];
        }
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

-(void)bindApiCall :(YCTWeChatLoginBindingViewModel *)data
{
    YCTApiWeChatLoginBinding *api = [[YCTApiWeChatLoginBinding alloc] init];
    api.mobile = data.mobile;
    api.unionId = data.unionId;
    api.avatar = data.avatar;
    api.nickName = data.nickName;
    api.loginType = data.loginType;
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        YCTOpenAuthLoginModel* resultData = api.responseDataModel;
        if (resultData.isReg) {
            [[YCTUserManager sharedInstance] loginWithModel:api.responseDataModel];
            [self dismissViewControllerAnimated:YES completion:self.loginCompletion];
        }
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] hideHud];
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}


-(void)uploadUserRegId{
    YCTApiUploadUserRegId * api=[[YCTApiUploadUserRegId alloc] init];
    api.reg_id=JPUSHService.registrationID;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
#pragma mark - getter

- (YCTLoginViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [YCTLoginViewModel new];
    }
    return _viewModel;
}
@end
