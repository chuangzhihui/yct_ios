//
//  YCTMineEditIntroViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import "YCTMineEditIntroViewController.h"
#import "YCTTextView.h"
#import "YCTApiUpdateUserInfo.h"
#import "YCTUserDataManager+Update.h"

@interface YCTMineEditIntroViewController ()
@property (strong, nonatomic) YCTTextView *textView;
@property (strong, nonatomic) UIBarButtonItem *saveItem;
@end

@implementation YCTMineEditIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = YCTLocalizedTableString(@"mine.title.modifyBriefIntro", @"Mine");
    
    self.textView.textView.text = self.originalValue;
}

- (void)bindViewModel {
    @weakify(self);
    
    RAC(self.saveItem, enabled) = [self.textView.textView.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        @strongify(self);
        return @((![value isEqualToString:self.originalValue] && value.length != 0));
    }];
}

- (void)setupView {
    self.textView = ({
        YCTTextView *view = [[YCTTextView alloc] init];
        view.textView.placeholder = YCTLocalizedTableString(@"mine.modify.briefIntro", @"Mine");
        view.limitLength = [YCTUserDataManager sharedInstance].userInfoModel.userType == YCTMineUserTypeNormal ? 100 : 1000;
        view;
    });
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20 + kNavigationBarHeight);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(200);
    }];
    
    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:YCTLocalizedTableString(@"mine.save", @"Mine") style:(UIBarButtonItemStylePlain) target:self action:@selector(saveClick)];
        [item setTitleTextAttributes:@{
            NSFontAttributeName: [UIFont PingFangSCMedium:16],
            NSForegroundColorAttributeName: UIColor.mainThemeColor
        } forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{
            NSFontAttributeName: [UIFont PingFangSCMedium:16],
            NSForegroundColorAttributeName: UIColor.mainThemeColorLight
        } forState:UIControlStateDisabled];
        self.saveItem = item;
        item;
    });
}

- (void)saveClick {
    [self.view endEditing:YES];
    
    NSString *newValue = self.textView.textView.text;
    YCTApiUpdateUserInfo *api = [[YCTApiUpdateUserInfo alloc] initWithType:(YCTApiUpdateUserInfoBriefIntro) value:newValue];
    [[YCTHud sharedInstance] showLoadingHud];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTUserDataManager sharedInstance] updateBriefIntro:newValue];
        [[YCTHud sharedInstance] hideHud];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

@end
