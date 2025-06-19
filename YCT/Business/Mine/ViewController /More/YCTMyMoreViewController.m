//
//  YCTMyMoreViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/27.
//

#import "YCTMyMoreViewController.h"
#import "YCTMineEditInfoViewController.h"
#import "YCTTableViewCell.h"
#import "AppDelegate.h"
#import "YCTUserManager.h"
#import "YCTLanguageManager.h"
#import "YCTApiCancelAccount.h"
#import "YCTChatViewController.h"
#import "YCTMyQRCodeViewController.h"
#import "YCTMyPostViewController.h"
#import "YCTMyViewingHistoryViewController.h"
#import "YCTGuideViewController.h"
#import "YCTChangePasswordViewController.h"
#import "YCTPrivacySettingViewController.h"
#import "YCTHelpViewController.h"
#import "YCTWebviewURLProvider.h"
#import "YCTWebViewController.h"
#import "YCTUpgradeToVendorViewController.h"
#import "YCTChangeMobileViewController.h"
#import "YCTBecomeCompanyViewController.h"
#define kMargin 30
#define kTitle YCTLocalizedTableString(@"mine.title.more", @"Mine")

#define kPostTitle YCTLocalizedTableString(@"mine.more.myPost", @"Mine")
#define kHistoryTitle YCTLocalizedTableString(@"mine.more.viewingHistory", @"Mine")
#define kChartsTitle YCTLocalizedTableString(@"mine.more.dataBoard", @"Mine")
#define kServiceTitle YCTLocalizedTableString(@"mine.more.myService", @"Mine")
#define kQRCodeTitle YCTLocalizedTableString(@"mine.more.myQRCode", @"Mine")
#define kLangTitle YCTLocalizedTableString(@"mine.more.changeLanguage", @"Mine")

#define kPasswordTitle YCTLocalizedTableString(@"mine.more.changePassword", @"Mine")
#define kChangeMobileTitle YCTLocalizedTableString(@"mine.more.changeMobile", @"Mine")
#define kCancelAccountTitle YCTLocalizedTableString(@"mine.more.cancelAccount", @"Mine")
#define kPrivateSettingTitle YCTLocalizedTableString(@"mine.more.privacySettings", @"Mine")
#define kUpgradeToVendorTitle YCTLocalizedTableString(@"mine.more.upgradeToVendor", @"Mine")

#define kFeedbackTitle YCTLocalizedTableString(@"mine.more.feedback", @"Mine")
#define kAgreementTitle YCTLocalizedTableString(@"mine.more.userAgreement", @"Mine")
#define kPolicyTitle YCTLocalizedTableString(@"mine.more.privacyPolicy", @"Mine")
#define kPactTitle YCTLocalizedTableString(@"mine.more.pact", @"Mine")
#define kAboutTitle YCTLocalizedTableString(@"mine.more.aboutUs", @"Mine")
#define kClearTitle YCTLocalizedTableString(@"mine.more.clearCache", @"Mine")
#define kLogoutTitle YCTLocalizedTableString(@"mine.more.logout", @"Mine")
#define myAccount YCTLocalizedTableString(@"mine.more.myAccount", @"Mine")
#define ServicePhone YCTLocalizedTableString(@"mine.more.myServiceMobile", @"Mine")

@interface YCTMyMoreViewController ()<UITableViewDelegate, UITableViewDataSource, YCTGuideViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSString *> *sectionTitles;
@property (nonatomic, copy) NSArray<NSArray *> *infosSection;
@property (nonatomic, copy) NSArray<NSArray *> *images;
@end

@implementation YCTMyMoreViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.sectionTitles = @[
        YCTLocalizedTableString(@"mine.more.section.basic", @"Mine"),
        YCTLocalizedTableString(@"mine.more.section.account", @"Mine"),
        YCTLocalizedTableString(@"mine.more.section.about", @"Mine")
    ];
    
    NSMutableArray *infosSection2 = @[
        myAccount,
        kPasswordTitle,
//        kChangeMobileTitle,
        kCancelAccountTitle,
        kPrivateSettingTitle,
    ].mutableCopy;
    NSMutableArray *images2 = @[
        @"mine_userinfo_vendor_name",
        @"mine_more_changePassword",
//        @"mine_more_changeMobile",
        @"mine_more_cancelAccount",
        @"mine_more_privacySettings",
    ].mutableCopy;
    [infosSection2 addObject:kUpgradeToVendorTitle];
    [images2 addObject:@"mine_more_updateToVendor"];
//    if ([YCTUserDataManager sharedInstance].userInfoModel.userType == YCTMineUserTypeNormal) {
//        [infosSection2 addObject:kUpgradeToVendorTitle];
//        [images2 addObject:@"mine_more_updateToVendor"];
//    }
    
    self.infosSection = @[
        @[
            kPostTitle,
            kHistoryTitle,
            kChartsTitle,
//            kServiceTitle,
//            kQRCodeTitle,
            kLangTitle,
        ],
        infosSection2.copy,
        @[
           
            kFeedbackTitle,
            kServiceTitle,//我的客服
            ServicePhone,//客服电话
            kAgreementTitle,
            kPolicyTitle,
            kPactTitle,
            kAboutTitle,
            kClearTitle,
            kLogoutTitle,
        ],
    ];
    
    self.images = @[
        @[
            @"mine_more_myPost",
            @"mine_more_watchHistory",
            @"mine_more_charts",
//            @"mine_more_service",
//            @"mine_more_myQRCode",
            @"mine_more_changeLang",
        ],
        images2.copy,
        @[
        
            @"mine_more_feedback",
            @"mine_more_service",//我的客服icon
            @"mine_userinfo_vendor_phone",//客服电话icon
            @"mine_more_userAgreement",
            @"mine_more_privacyPolicy",
            @"mine_more_self-discipline",
            @"mine_more_aboutUs",
            @"mine_more_cleanCache",
            @"mine_more_logout",
        ],
    ];
}

- (void)setupView {
    self.view.backgroundColor = UIColor.whiteColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.infosSection.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infosSection[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.infosSection[indexPath.section][indexPath.row];
    
    YCTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YCTTableViewCell.cellReuseIdentifier];
    
    cell.textLabel.font = [UIFont PingFangSCMedium:16];
    cell.detailTextLabel.font = [UIFont PingFangSCMedium:16];
    cell.detailTextLabel.textColor = UIColor.mainGrayTextColor;
    
    cell.imageView.image = [UIImage imageNamed:self.images[indexPath.section][indexPath.row]];
    [cell setMargin:kMargin spacing:10];
    
    if ([title isEqualToString:kClearTitle]) {
        double size = ((double)(SDImageCache.sharedImageCache.totalDiskSize)) / (1024.0 * 1024.0);
        cell.textLabel.text = [NSString stringWithFormat:@"%@（%.1fMB）", title, size];
        
        @weakify(self);
        UIButton *clearButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        clearButton.bounds = CGRectMake(0, 0, 60, 24);
        clearButton.layer.cornerRadius = 12;
        clearButton.titleLabel.font = [UIFont PingFangSCMedium:12];
        clearButton.backgroundColor = UIColor.grayButtonBgColor;
        [clearButton setTitleColor:UIColor.mainTextColor forState:(UIControlStateNormal)];
        [clearButton setTitle:YCTLocalizedTableString(@"mine.more.clearCacheButton", @"Mine") forState:(UIControlStateNormal)];
        [[[clearButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [[YCTHud sharedInstance] showLoadingHud];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [[YCTHud sharedInstance] hideHud];
                [self.tableView reloadData];
            }];
        }];
        cell.accessoryView = clearButton;
    }
    else {
        cell.textLabel.text = title;
        cell.accessoryView = [cell yct_accessoryView];
    }
    
    if ([title isEqualToString:kLangTitle]) {
        cell.detailTextLabel.text = kLanguageIsEnglish ? @"English" : @"中文";
    }
    else if ([title isEqualToString:kPasswordTitle]) {
        RAC(cell.detailTextLabel, text) =
        [[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.isSetPwd) takeUntil:cell.rac_prepareForReuseSignal] map:^id _Nullable(NSNumber * _Nullable value) {
            if (value.boolValue) {
                return @"";
            } else {
                return YCTLocalizedTableString(@"mine.more.notSetPsw", @"Mine");
            }
        }];
    }
    else {
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
#define TEXT_TAG 1
    static NSString *headerViewId = @"HeaderView";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewId];
        headerView.backgroundView = ({
            UIView *view = [UIView new];
            view.backgroundColor = tableView.backgroundColor;
            view;
        });
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.tag = TEXT_TAG;
        textLabel.font = [UIFont PingFangSCMedium:12];
        textLabel.textColor = UIColor.mainGrayTextColor;
        [headerView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kMargin);
            make.centerY.mas_equalTo(0);
        }];
    }
    UILabel *label = [headerView viewWithTag:TEXT_TAG];
    label.text = self.sectionTitles[section];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 42;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:kPostTitle]) {
        YCTMyPostViewController *vc = [YCTMyPostViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
        
    else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:kHistoryTitle]) {
        YCTMyViewingHistoryViewController *vc = [YCTMyViewingHistoryViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:myAccount]) {
        YCTMineEditInfoViewController *vc = [YCTMineEditInfoViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:kChartsTitle]) {
        YCTWebViewController *vc = [[YCTWebViewController alloc] init];
        vc.url = [YCTWebviewURLProvider dataChartsUrl];
        vc.title = self.infosSection[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
        
    else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:kServiceTitle]) {
        NSLog(@"点击了我的客服");
        NSString *phoneStr = @"mailto://1887405@139.com";
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr] options:@{} completionHandler:nil];
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
        }
//        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//        UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:YCTLocalizedTableString(@"mine.scan.cancle", @"Mine") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                NSLog(@"取消");
//            }];
//            //添加确定
//        UIAlertAction *kefu1 = [UIAlertAction actionWithTitle:YCTLocalizedTableString(@"mine.service.s1", @"Mine") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull   action) {
//            [YCTChatViewController goToChatWithUserId:@"64" title:YCTLocalizedTableString(@"mine.service.s1", @"Mine") from:self.navigationController];
//          }];
//        UIAlertAction *kefu2 = [UIAlertAction actionWithTitle:YCTLocalizedTableString(@"mine.service.s2", @"Mine") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull   action) {
//            [YCTChatViewController goToChatWithUserId:@"61" title:YCTLocalizedTableString(@"mine.service.s2", @"Mine") from:self.navigationController];
//          }];
//         //将action添加到控制器
//        [alertVc addAction:cancelBtn];
//        [alertVc addAction :kefu1];
//        [alertVc addAction :kefu2];
//            //展示
//        [self presentViewController:alertVc animated:YES completion:nil];
    } else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:ServicePhone]) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
        UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:YCTLocalizedTableString(@"mine.scan.cancle", @"Mine") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
            }];
            //添加确定
        UIAlertAction *kefu1 = [UIAlertAction actionWithTitle:@"15730183869" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull   action) {
                NSString *phoneStr = @"tel://15730183869";
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr] options:@{} completionHandler:nil];
                } else {
                    // Fallback on earlier versions
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
                }
          }];
        UIAlertAction *kefu2 = [UIAlertAction actionWithTitle:@"18581494298" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull   action) {
            NSString *phoneStr = @"tel://18581494298";
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr] options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
            }
          }];
        UIAlertAction *kefu3 = [UIAlertAction actionWithTitle:@"15730183869" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull   action) {
            NSString *phoneStr = @"tel://15730183869";
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr] options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
            }
          }];
        UIAlertAction *kefu4 = [UIAlertAction actionWithTitle:@"02368652859" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull   action) {
            NSString *phoneStr = @"tel://02368652859";
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr] options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
            }
          }];
        UIAlertAction *kefu5 = [UIAlertAction actionWithTitle:@"15730183869" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull   action) {
            NSString *phoneStr = @"tel://15730183869";
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr] options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
            }
          }];
         //将action添加到控制器
        [alertVc addAction:cancelBtn];
        [alertVc addAction :kefu1];
        [alertVc addAction :kefu2];
        [alertVc addAction :kefu3];
        [alertVc addAction :kefu4];
        [alertVc addAction :kefu5];
            //展示
        [self presentViewController:alertVc animated:YES completion:nil];
    }
        
    else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:kQRCodeTitle]) {
        YCTMyQRCodeViewController *vc = [YCTMyQRCodeViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
         
    else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:kLangTitle]) {
        YCTGuideViewController *vc = [YCTGuideViewController new];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
        
    else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:kPasswordTitle]) {
        YCTChangePasswordViewController *vc = [[YCTChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:kChangeMobileTitle]) {
        YCTChangeMobileViewController *vc = [[YCTChangeMobileViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:kCancelAccountTitle]) {
        [UIView showAlertSheetWith:YCTLocalizedTableString(@"mine.tips.cancelAccount", @"Mine") clickAction:^{
            [[YCTHud sharedInstance] showLoadingHud];
            YCTApiCancelAccount *api = [[YCTApiCancelAccount alloc] init];
            [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
                [[YCTHud sharedInstance] showSuccessHud:request.getMsg];
                [[YCTHud sharedInstance] hideHudAfterDelay:kDefaultDelayTimeInterval completion:^{
                    [[YCTUserManager sharedInstance] logout];
                }];
            } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
                [[YCTHud sharedInstance] showDetailToastHud:request.getError];
            }];
        }];
    }
        
    else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:kPrivateSettingTitle]) {
        YCTPrivacySettingViewController *vc = [[YCTPrivacySettingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:kUpgradeToVendorTitle]) {
//        YCTUpgradeToVendorViewController *vc = [[YCTUpgradeToVendorViewController alloc] init];
        YCTBecomeCompanyViewController *vc=[[YCTBecomeCompanyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
        
    else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:kFeedbackTitle]) {
        YCTHelpViewController *vc = [[YCTHelpViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
        
    else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:kAgreementTitle]) {
        YCTWebViewController *vc = [[YCTWebViewController alloc] init];
        vc.url = [YCTWebviewURLProvider h5WithType:(YCTWebviewURLTypeUserAgreement)];
        vc.title = self.infosSection[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
        
    else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:kPolicyTitle]) {
        YCTWebViewController *vc = [[YCTWebViewController alloc] init];
        vc.url = [YCTWebviewURLProvider h5WithType:(YCTWebviewURLTypePrivacyPolicy)];
        vc.title = self.infosSection[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:kPactTitle]) {
        YCTWebViewController *vc = [[YCTWebViewController alloc] init];
        vc.url = [YCTWebviewURLProvider h5WithType:(YCTWebviewURLTypePact)];
        vc.title = self.infosSection[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
        
    else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:kAboutTitle]) {
        YCTWebViewController *vc = [[YCTWebViewController alloc] init];
        vc.url = [YCTWebviewURLProvider h5WithType:(YCTWebviewURLTypeAboutUs)];
        vc.title = self.infosSection[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
        
    else if ([self.infosSection[indexPath.section][indexPath.row] isEqualToString:kLogoutTitle]) {
        [UIAlertController showAlertInViewController:self withTitle:nil message:YCTLocalizedString(@"alert.logout") cancelButtonTitle:YCTLocalizedString(@"action.cancel") destructiveButtonTitle:nil otherButtonTitles:@[YCTLocalizedString(@"action.confirm")] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex != controller.cancelButtonIndex) {
                [[YCTUserManager sharedInstance] logout];
            }
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 38) {
        if (![self.title isEqualToString:kTitle]) {
            self.title = kTitle;
        }
    } else {
        if (![self.title isEqualToString:@""]) {
            self.title = @"";
        }
    }
}

#pragma mark - YCTGuideViewControllerDelegate

- (void)guideDidSelectLanguage:(NSString *)language {
    if (![[YCTSanboxTool getCurrentLanguage] isEqualToString:language]) {
        [YCTLanguageManager setLanguage:language];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate switchToNewRootVC];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 48;
        _tableView.rowHeight = 48;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.view.backgroundColor;
        [_tableView registerClass:YCTTableViewCell.class
           forCellReuseIdentifier:YCTTableViewCell.cellReuseIdentifier];
        _tableView.tableHeaderView = ({
            UIView *header = [UIView new];
            header.frame = CGRectMake(0, 0, self.view.bounds.size.width, 58);
            header.backgroundColor = self.view.backgroundColor;
            UILabel *titleLabel = ({
                UILabel *view = [[UILabel alloc] init];
                view.frame = CGRectMake(kMargin, 5, 100, 33);
                view.textColor = UIColor.mainTextColor;
                view.font = [UIFont PingFangSCBold:24];
                view.text = kTitle;
                view;
            });
            [header addSubview:titleLabel];
            header;
        });
        _tableView.tableFooterView = ({
            UIView *header = [UIView new];
            header.frame = CGRectMake(0, 0, self.view.bounds.size.width, 110);
            header.backgroundColor = self.view.backgroundColor;
            UILabel *titleLabel = ({
                UILabel *view = [[UILabel alloc] init];
                view.textColor = UIColor.subTextColor;
                view.font = [UIFont PingFangSCMedium:14];
                view.text = [NSString stringWithFormat:@"%@ version%@", YCTLocalizedTableString(@"CFBundleDisplayName", @"InfoPlist"), kLocalVersion];
                view;
            });
            [header addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.mas_equalTo(0);
            }];
            header;
        });
    }
    return _tableView;
}

@end
