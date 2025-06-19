//
//  YCTMineViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/12.
//

#import "YCTMineViewController.h"
#import <JXPagingView/JXPagerView.h>
#import "JXCategoryTitleView+Customization.h"
#import "YCTMineUserInfoView.h"
#import "YCTMineVideoSubViewController.h"
#import "YCTVendorInfoViewController.h"

#import "YCTMyQRCodeViewController.h"
#import "YCTMineEditLabelViewController.h"
#import "YCTMineEditInfoViewController.h"
#import "YCTMyMoreViewController.h"
#import "YCTMineEditIntroViewController.h"
#import "YCTAddFriendsViewController.h"
#import "YCTPhotoBrowser.h"
#import "YCTFansViewController.h"
#import "YCTMyFollowViewController.h"
#import "YCTMineEditCarouselViewController.h"
#import "YCTMineEditBgImageViewController.h"
#import "YCTUpgradeToVendorViewController.h"
#import "YCTBecomeCompanyViewController.h"
#define kHeightForHeaderInSection 44
#import "YCTPublishSettingBottomView.h"
#import "YCTApiAuthPay.h"
#import "YCTAuthPayModel.h"
#import "YCTPaypalViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "YCTApiPayPalDoPay.h"
#import "YCTBecomeCompanyAuditListVC.h"
#import "YCTRootViewController.h"
#import "CompanyAuditApi.h"
#import "YCTInteractiveMsgViewController.h"
@interface YCTMineViewController ()<JXPagerViewDelegate, JXCategoryViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, assign) BOOL isStatusBarLight;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UILabel *navigationTitleLabel;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) YCTMineUserInfoView *userInfoView;
@property (nonatomic, strong) JXPagerView *pagingView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, copy) NSArray<NSString *> *titles;
@property (nonatomic, copy) NSArray<NSNumber *> *subVCTypes;

@end

@implementation YCTMineViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isStatusBarLight = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAuthPaySuccess) name:@"alipaySuccess" object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"alipaySuccess" object:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"页面显示");
    [self updateMineInfo];
    
}

- (void)bindViewModel {
    @weakify(self);
    [[self.settingButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        if ([YCTUserDataManager sharedInstance].isLogin) {
            YCTMyMoreViewController *vc = [[YCTMyMoreViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    self.userInfoView.bgImageClickBlock = ^{
        @strongify(self);
        if ([YCTUserDataManager sharedInstance].isLogin) {
            YCTMineEditBgImageViewController *vc = [[YCTMineEditBgImageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    self.userInfoView.avatarClickBlock = ^{
        @strongify(self);
        if ([YCTUserDataManager sharedInstance].isLogin) {
            YCTMineEditInfoViewController *vc = [[YCTMineEditInfoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
//        if (![YCTUserDataManager sharedInstance].isLogin) {
//            return;
//        }
//        [YCTPhotoBrowser showPhotoBrowerInVC:self photoCount:1 currentIndex:0 photoConfig:^(NSUInteger idx, NSURL *__autoreleasing *photoUrl, UIImageView *__autoreleasing *sourceImageView) {
//            *photoUrl = [NSURL URLWithString:[YCTUserDataManager sharedInstance].userInfoModel.avatar];
//            *sourceImageView = self.userInfoView.avatarImageView;
//        }];
    };
    
    self.userInfoView.likesClickBlock  = ^{
        @strongify(self);
        if ([YCTUserDataManager sharedInstance].isLogin) {
            YCTInteractiveMsgViewController *vc = [[YCTInteractiveMsgViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    self.userInfoView.fansClickBlock = ^{
        @strongify(self);
        if ([YCTUserDataManager sharedInstance].isLogin) {
            YCTFansViewController *vc = [[YCTFansViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    self.userInfoView.followClickBlock = ^{
        @strongify(self);
        if ([YCTUserDataManager sharedInstance].isLogin) {
            YCTMyFollowViewController *vc = [[YCTMyFollowViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    self.userInfoView.briefIntroClickBlock = ^{
        @strongify(self);
        if ([YCTUserDataManager sharedInstance].isLogin) {
            YCTMineEditIntroViewController *vc = [[YCTMineEditIntroViewController alloc] init];
            vc.originalValue = [YCTUserDataManager sharedInstance].userInfoModel.introduce;
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    self.userInfoView.qrCodeClickBlock = ^{
        @strongify(self);
        if ([YCTUserDataManager sharedInstance].isLogin) {
            YCTMyQRCodeViewController *vc = [[YCTMyQRCodeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    self.userInfoView.addTagClickBlock = ^{
        @strongify(self);
        if ([YCTUserDataManager sharedInstance].isLogin) {
            YCTMineEditLabelViewController *vc = [[YCTMineEditLabelViewController alloc] init];
        
            if ([YCTUserDataManager sharedInstance].userInfoModel.userTags.length == 0) {
                vc.orginalLabels = nil;
            } else {
                vc.orginalLabels = [[YCTUserDataManager sharedInstance].userInfoModel.userTags componentsSeparatedByString:@","];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    self.userInfoView.editInfoClickBlock = ^{
        @strongify(self);
        if ([YCTUserDataManager sharedInstance].isLogin) {
           // MARK: - Payment Method
            /*
            CompanyAuditApi * api = [[CompanyAuditApi alloc] init];
            @weakify(self);
            [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                @strongify(self);
                CompanyAuditModel *model = api.responseDataModel;
//                if([YCTUserDataManager sharedInstance].userInfoModel.status==0){
                if(model.isPay==true){
                //                [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.upgradeToVendor.submit.buyunxu", @"Mine")];
                    //弹窗选择支付方式
                    NSArray *titles = @[
    //                                @"微信支付",
                                    YCTLocalizedTableString(@"mine.payment.alipay", @"Mine"),@"PayPal"];
                    NSArray *subtitles = @[
    //                    @"",
                        @"",@""];
                    NSArray *subIcons = @[
    //                    @"wx_icon",
                        @"ali_icon",@"paypal_icon"];
                    NSInteger * index = 3;
                    YCTPublishSettingBottomView *view = [YCTPublishSettingBottomView settingViewIconWithDefaultIndex:index title:YCTLocalizedTableString(@"mine.payment.place", @"Mine") titles:titles icons:subIcons subtitles:subtitles  selectedHandler:^(NSString * _Nullable title, NSInteger index) {
                        NSLog(@"回调:%ld",index);
                        YCTApiAuthPay *api=[[YCTApiAuthPay alloc] initWithType:[NSString stringWithFormat:@"%ld",(long)index+1]];
                        [[YCTHud sharedInstance] showLoadingHud];
                        [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
                            [[YCTHud sharedInstance] hideHud];
                            YCTAuthPayModel * model=request.responseDataModel;
                            NSLog(@"url:%@",model.url);
                            if(index==1)
                            {
                                //paypal
                                YCTPaypalViewController *vc=[[YCTPaypalViewController alloc] init];
                                vc.url=[NSURL URLWithString:model.url];
                                vc.onAuthSuccesss = ^(NSString * _Nonnull result) {
                                    //授权成功
                                    YCTApiPayPalDoPay * doPayApi=[[YCTApiPayPalDoPay  alloc] init];
                                    doPayApi.order_sn=model.order_sn;
                                    [[YCTHud sharedInstance] showLoadingHud];
                                    [doPayApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                                        [[YCTHud sharedInstance] hideHud];
                                        [self onAuthPaySuccess];
                                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                                        [[YCTHud sharedInstance] showToastHud:YCTLocalizedTableString(@"mine.payment.faile", @"Mine")];
                                        
                                    }];
                                };
    // /xunji/credits
                                [self.navigationController pushViewController:vc animated:YES];
                            } else if(index==0) {
                                //支付宝
                                [[AlipaySDK defaultService] payOrder:model.url fromScheme:@"yct" callback:^(NSDictionary *resultDic) {
                                    dispatch_async(dispatch_get_main_queue(), ^(void){
                                      NSLog(@"支付结果:%@",resultDic);
                                        NSString *status=[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
                                        NSLog(@"status:%@",[resultDic objectForKey:@"resultStatus"]);
                                      if ([status isEqualToString:@"9000"]) {
                                          [self onAuthPaySuccess];
                                      }

                                    });
                                }];
                            }
                        } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
                            NSLog(@"请求失败:%@%@",request.requestUrl,[request getError]);
                            [[YCTHud sharedInstance] hideHud];
                            [[YCTHud sharedInstance] showToastHud:@"获取支付失败"];
                        }];
    //                    if(index==0)
    //                    {
    //                        //支付宝
    //                    }
                    }];
                    [view yct_show];
                    return;
                }
                
                [[YCTHud sharedInstance] hideHud];
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                NSLog(@"请求主页数据失败：%@",request.requestUrl);
                NSLog(@"请求主页数据失败：%@",request.responseString);
                [[YCTHud sharedInstance] hideHud];
            }];
            */
            
            YCTMineUserInfoModel *userInfoModel = [YCTUserDataManager sharedInstance].userInfoModel;
            if(userInfoModel.status == 0) {
                if ([userInfoModel.companyName isEqualToString:@""] ||  userInfoModel.companyName == nil) {
                    YCTBecomeCompanyViewController *vc = [[YCTBecomeCompanyViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    YCTBecomeCompanyAuditListVC *vc = [[YCTBecomeCompanyAuditListVC alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else if (userInfoModel.status == 1)  {
                if (userInfoModel.userType == YCTMineUserTypeBusiness) {
                    YCTBecomeCompanyAuditListVC *vc = [[YCTBecomeCompanyAuditListVC alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    YCTBecomeCompanyViewController *vc = [[YCTBecomeCompanyViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                YCTBecomeCompanyViewController *vc = [[YCTBecomeCompanyViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
        }
    };
    
    self.userInfoView.addVendorClickBlock = ^{
        @strongify(self);
        if ([YCTUserDataManager sharedInstance].isLogin) {
            YCTAddFriendsViewController *vc = [[YCTAddFriendsViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    self.userInfoView.carouselView.clickItem = ^(NSInteger index) {
        @strongify(self);
        if ([YCTUserDataManager sharedInstance].isLogin) {
            NSArray *banners = [[YCTUserDataManager sharedInstance].userInfoModel.banners valueForKey:@"url"];
            [YCTPhotoBrowser showPhotoBrowerInVC:self photoCount:banners.count currentIndex:index photoConfig:^(NSUInteger idx, NSURL *__autoreleasing *photoUrl, UIImageView *__autoreleasing *sourceImageView) {
                *photoUrl = [NSURL URLWithString:banners[idx]];
            }];
        }
    };
    
    self.userInfoView.vendorInfoClickBlock = ^{
        @strongify(self);
        if ([YCTUserDataManager sharedInstance].isLogin) {
            YCTVendorInfoViewController *vc = [[YCTVendorInfoViewController alloc] initWithMine];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    RAC(self.userInfoView.vipImageView, hidden) = [RACObserve([YCTUserDataManager sharedInstance], userInfoModel.isauthentication) map:^id _Nullable(NSNumber * _Nullable value) {
        if (value) {
            return @(!value.boolValue);
        } else {
            return @(YES);
        }
    }];
    
    RAC(self.userInfoView.vipLabel, text) = [RACObserve([YCTUserDataManager sharedInstance], userInfoModel.authentication) ignore:nil];
    
    [[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.avatar) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x) {
            [self.userInfoView.avatarImageView loadImageGraduallyWithURL:[NSURL URLWithString:x] placeholderImageName:kDefaultAvatarImageName];
        } else {
            self.userInfoView.avatarImageView.image = [UIImage imageNamed:kDefaultAvatarImageName];
        }
    }];
    /*
    [[RACSignal combineLatest:@[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.status), RACObserve([YCTUserDataManager sharedInstance], userInfoModel.audit_price)]] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        NSLog(@"status和price:%@--%@",x.first,x.last);
        if(((NSNumber *)x.first).intValue==0)
        {
            NSNumber * money=x.last;
            [self.userInfoView.leftButton setDarkStyleWithTitle:[NSString stringWithFormat:@"%@￥%@",YCTLocalizedTableString(@"mine.payToAuth", @"Mine"),money]
                               fontSize:15
                           cornerRadius:44 / 2
                              imageName:@"pay_money"];
        }else{
                        [self.userInfoView.leftButton setDarkStyleWithTitle:YCTLocalizedTableString(@"mine.editInformation", @"Mine")
                                           fontSize:15
                                       cornerRadius:44 / 2
                                          imageName:@"mine_mine_edit"];
        }
//        [self.userInfoView setBriefIntro:x.second isBusiness:((NSNumber *)x.first).intValue == 2];
//        [self updateHeader];
    }];
    */
    
//    [[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.status) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
//        @strongify(self);
//        NSLog(@"status状态:%@",x);
//        if([x isEqual:@"0"])
//        {
//            [self.userInfoView.leftButton setDarkStyleWithTitle:[NSString stringWithFormat:@"%@￥%@",YCTLocalizedTableString(@"mine.payToAuth", @"Mine"),[YCTUserDataManager sharedInstance].userInfoModel.audit_price]
//                               fontSize:15
//                           cornerRadius:44 / 2
//                              imageName:@"pay_money"];
//
//        }else{
//            [self.userInfoView.leftButton setDarkStyleWithTitle:YCTLocalizedTableString(@"mine.editInformation", @"Mine")
//                               fontSize:15
//                           cornerRadius:44 / 2
//                              imageName:@"mine_mine_edit"];
//        }
//    }];
//    [self.userInfoView.leftButton setTitle:@"哈哈哈" forState:UIControlStateNormal];
    [[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.userBg) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x) {
            [self.userInfoView.bgImageView loadImageGraduallyWithURL:[NSURL URLWithString:x] placeholderImageName:@"mine_mine_bg"];
        } else {
            self.userInfoView.bgImageView.image = [UIImage imageNamed:@"mine_mine_bg"];
        }
    }];
    
    RAC(self.userInfoView.nameLabel, text) = RACObserve([YCTUserDataManager sharedInstance], userInfoModel.nickName);
    
    RAC(self.userInfoView.idValueLabel, text) = RACObserve([YCTUserDataManager sharedInstance], userInfoModel.userTag);
    
    [[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.userTags) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        [self.userInfoView setUserTags:x];
        [self updateHeader];
    }];
    
    [[RACSignal combineLatest:@[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.userType), RACObserve([YCTUserDataManager sharedInstance], userInfoModel.introduce)]] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        [self.userInfoView setBriefIntro:x.second isBusiness:((NSNumber *)x.first).intValue == 2];
        [self updateHeader];
    }];
    
    RAC(self.userInfoView.vendorInfoView.nameLabel, text) = [RACObserve([YCTUserDataManager sharedInstance], userInfoModel.companyContact) ignore:nil];
//    RAC(self.userInfoView.vendorInfoView.phoneLabel, text) = [RACObserve([YCTUserDataManager sharedInstance], userInfoModel.companyPhone) ignore:nil];
    RAC(self.userInfoView.vendorInfoView.websiteLabel, text) = [RACObserve([YCTUserDataManager sharedInstance], userInfoModel.companyWebSite) ignore:nil];
    RAC(self.userInfoView.vendorInfoView.siteLabel, text) = [RACObserve([YCTUserDataManager sharedInstance], userInfoModel.companyAddress) ignore:nil];
    RAC(self.userInfoView.vendorInfoView.mainProductLabel, text) = [RACObserve([YCTUserDataManager sharedInstance], userInfoModel.companytype) ignore:nil];
    RAC(self.userInfoView.vendorInfoView.companyNameLabel, text) = [RACObserve([YCTUserDataManager sharedInstance], userInfoModel.companyName) ignore:nil];
    RAC(self.userInfoView.vendorInfoView.socialcodeLabel, text) = [RACObserve([YCTUserDataManager sharedInstance], userInfoModel.socialcode) ignore:nil];
    RAC(self.userInfoView.vendorInfoView.emailLabel, text) = [RACObserve([YCTUserDataManager sharedInstance], userInfoModel.companyEmail) ignore:nil];
    RAC(self.userInfoView.vendorInfoView.businessTimeLabel, text) = [[RACSignal combineLatest:@[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.businessstart), RACObserve([YCTUserDataManager sharedInstance], userInfoModel.businessterm)]] map:^id _Nullable(RACTuple * _Nullable value) {
        NSString *businessstart = value.first ?: @"";
        NSString *businessterm = value.second ?: @"";
        return [NSString stringWithFormat:@"%@-%@", businessstart, businessterm];
    }];
    
    RAC(self.userInfoView.vendorInfoViewNew.companyNameLine.cont,text)=[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.companyName) ignore:nil];
    RAC(self.userInfoView.vendorInfoViewNew.companyDescLine.cont,text)=[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.introduce) ignore:nil];
    RAC(self.userInfoView.vendorInfoViewNew.mainProduct.cont,text)=[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.direction) ignore:nil];
    RAC(self.userInfoView.vendorInfoViewNew.industry.cont,text)=[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.goodstypef) ignore:nil];
//    RAC(self.userInfoView.vendorInfoViewNew.nameLabel, text) = [RACObserve([YCTUserDataManager sharedInstance], userInfoModel.companyContact) ignore:nil];
    
    
    [[RACSignal combineLatest:@[RACObserve([YCTUserDataManager sharedInstance], userInfoModel.userType), RACObserve([YCTUserDataManager sharedInstance], userInfoModel.banners)]] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        NSNumber *userType = x.first;
        if (userType.intValue == 1) {
            [self.userInfoView setBanners:nil];
        } else {
            NSArray<YCTUserBannerItemModel *> *banners = x.second;
            [self.userInfoView setBanners:[banners valueForKey:@"url"]];
        }
        [self updateHeader];
    }];
    
    RAC(self.userInfoView.likeCountLabel, text) = [RACObserve([YCTUserDataManager sharedInstance], userInfoModel.zanNum) map:^id _Nullable(NSNumber * _Nullable value) {

        return [value stringValue];
    }];
    
    RAC(self.userInfoView.attentionCountLabel, text) = [RACObserve([YCTUserDataManager sharedInstance], userInfoModel.fllowNum) map:^id _Nullable(NSNumber * _Nullable value) {
        return [value stringValue];
    }];
    
    RAC(self.userInfoView.fansCountLabel, text) = [RACObserve([YCTUserDataManager sharedInstance], userInfoModel.fansNum) map:^id _Nullable(NSNumber * _Nullable value) {
        return [value stringValue];
    }];
    
    [[RACObserve([YCTUserDataManager sharedInstance], userInfoModel) distinctUntilChanged] subscribeNext:^(YCTMineUserInfoModel * _Nullable x) {
        @strongify(self);
        /// 登录了
        if (x) {
            /// 普通用户
//            if (x.userType == YCTMineUserTypeNormal) {
//                [self updateTitles:@[
//                    YCTLocalizedTableString(@"mine.mine.likes", @"Mine"),
//                    YCTLocalizedTableString(@"mine.mine.collected", @"Mine"),
//                ] subVCTypes:@[@1, @2]];
//            }
//            /// 厂商用户
//            else {
//                [self updateTitles:@[
//                    YCTLocalizedTableString(@"mine.mine.works", @"Mine"),
//                    YCTLocalizedTableString(@"mine.mine.likes", @"Mine"),
//                    YCTLocalizedTableString(@"mine.mine.collected", @"Mine"),
//                    YCTLocalizedTableString(@"mine.mine.audit", @"Mine"),
//                    YCTLocalizedTableString(@"mine.mine.drafts", @"Mine"),
//                ] subVCTypes:@[@0, @1, @2, @3, @4]];
//            }
            [self updateTitles:@[
                YCTLocalizedTableString(@"mine.mine.works", @"Mine"),
                YCTLocalizedTableString(@"mine.mine.likes", @"Mine"),
                YCTLocalizedTableString(@"mine.mine.collected", @"Mine"),
                YCTLocalizedTableString(@"mine.mine.audit", @"Mine"),
                YCTLocalizedTableString(@"mine.mine.drafts", @"Mine"),
            ] subVCTypes:@[@0, @1, @2, @3, @4]];
        }
        /// 退出登录
        else {
            [self updateTitles:@[] subVCTypes:@[]];
        }
    }];
}

- (void)setupView {
    [self.view addSubview:self.navigationBarView];
    [self.navigationBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kNavigationBarHeight);
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.navigationBarView addSubview:self.navigationTitleLabel];
    [self.navigationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(kStatusBarHeight / 2);
    }];
    
    [self.view addSubview:self.settingButton];
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(27);
        make.top.mas_equalTo(((kNavigationBarHeight - kStatusBarHeight) - 27) / 2 + kStatusBarHeight);
        make.right.mas_equalTo(-15);
    }];
    
    self.pagingView.pinSectionHeaderVerticalOffset = kNavigationBarHeight;//self.userInfoView.contentHeight + 10;
    [self.view addSubview:self.pagingView];

    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagingView.frame = self.view.bounds;
    [self.view bringSubviewToFront:self.navigationBarView];
    [self.view bringSubviewToFront:self.settingButton];
}

- (BOOL)naviagtionBarHidden {
    return YES;
}

#pragma mark - Private

- (void)updateHeader {
    [self.userInfoView updateContentHeight];
    [self.pagingView resizeTableHeaderViewHeightWithAnimatable:NO duration:0 curve:(UIViewAnimationCurveLinear)];
}
-(void) onAuthPaySuccess{
    NSLog(@"支付成功同志");
    [[YCTHud sharedInstance] showSuccessHud:@"success"];
    [[YCTRootViewController sharedInstance] backToHome];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BecomeCompanyPaySuccess" object:nil];
   //重载数据;
    [self updateMineInfo];
    
}
- (void)updateTitles:(NSArray *)titles
          subVCTypes:(NSArray *)subVCTypes {
    self.titles = titles;
    self.subVCTypes = subVCTypes;
    self.categoryView.defaultSelectedIndex = 0;
    if (titles.count == 2) {
        self.categoryView.cellSpacing = 0;
        self.categoryView.contentEdgeInsetLeft = 0;
        self.categoryView.contentEdgeInsetRight = 0;
        self.categoryView.averageCellSpacingEnabled = NO;
        self.categoryView.cellWidth = Iphone_Width / 2;
    } else {
        self.categoryView.averageCellSpacingEnabled = YES;
        self.categoryView.cellSpacing = 0;
        self.categoryView.contentEdgeInsetLeft = 16;
        self.categoryView.contentEdgeInsetRight = 16;
        self.categoryView.cellWidth = JXCategoryViewAutomaticDimension;
    }
    self.categoryView.titles = self.titles;
    [self.categoryView reloadData];
    [self.pagingView reloadData];
}

- (void)updateMineInfo {
    [[YCTUserManager sharedInstance] updateUserInfo];
    [self getIsPayData];
}
- (void)getIsPayData {
    // 检查是否付费
    CompanyAuditApi * api = [[CompanyAuditApi alloc] init];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        CompanyAuditModel *model = api.responseDataModel;
        if (model.isPay) {
//            [YCTUserDataManager sharedInstance], userInfoModel.status), RACObserve([YCTUserDataManager sharedInstance], userInfoModel.audit_price
            YCTMineUserInfoModel *user = [YCTUserDataManager sharedInstance].userInfoModel;
            if(user.status==0) {
                NSNumber * money=user.audit_price;
                [self.userInfoView.leftButton setDarkStyleWithTitle:[NSString stringWithFormat:@"%@$%@",YCTLocalizedTableString(@"mine.payToAuth", @"Mine"),money]
                                   fontSize:15
                               cornerRadius:44 / 2
                                  imageName:@"pay_money"];
            } else {
                [self.userInfoView.leftButton setDarkStyleWithTitle:YCTLocalizedTableString(@"mine.editInformation", @"Mine")
                                               fontSize:15
                                           cornerRadius:44 / 2
                                              imageName:@"mine_mine_edit"];
            }
        } else {
            [self.userInfoView.leftButton setDarkStyleWithTitle:YCTLocalizedTableString(@"mine.editInformation", @"Mine")
                                           fontSize:15
                                       cornerRadius:44 / 2
                                          imageName:@"mine_mine_edit"];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求主页数据失败：%@",request.requestUrl);
        NSLog(@"请求主页数据失败：%@",request.responseString);
    }];
}

#pragma mark - JXPagingViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.userInfoView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.userInfoView.contentHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return kHeightForHeaderInSection;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    YCTMineVideoSubViewController *list = [[YCTMineVideoSubViewController alloc] initWithType:[self.subVCTypes[index] intValue]];
    return list;
}

- (void)pagerView:(JXPagerView *)pagerView mainTableViewDidScroll:(UIScrollView *)scrollView {
    [self.userInfoView scrollViewDidScroll:scrollView.contentOffset.y];
    CGFloat alpha;
//    NSLog(@"🐷 = %@", @(scrollView.contentOffset.y));
    if (scrollView.contentOffset.y > 0) {
        alpha = MIN(scrollView.contentOffset.y / (self.userInfoView.contentHeight - kNavigationBarHeight), 1);
    } else {
        alpha = 0;
    }
    
    CGFloat factor = 0.8;
    
    if (alpha > 0.99 && self.isStatusBarLight) {
        self.isStatusBarLight = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    } else if (alpha < 0.99 && !self.isStatusBarLight) {
        self.isStatusBarLight = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    if (alpha < factor) {
        self.navigationBarView.userInteractionEnabled = NO;
        self.navigationTitleLabel.alpha = 0;
    } else {
        self.navigationBarView.userInteractionEnabled = YES;
        self.navigationTitleLabel.alpha = (alpha - 0.8) / (1 - factor);
    }
    self.navigationBarView.alpha = alpha;
//    self.settingButton.backgroundColor = UIColorFromRGBA(0x000000, 0.1 * (1 - alpha));
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view.superview.superview isKindOfClass:NSClassFromString(@"YCTCarouselView")]) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

#pragma mark - Getter

- (UIView *)navigationBarView {
    if (!_navigationBarView) {
        _navigationBarView = [UIView new];
        _navigationBarView.backgroundColor = UIColor.whiteColor;
        _navigationBarView.userInteractionEnabled = NO;
        _navigationBarView.alpha = 0;
    }
    return _navigationBarView;
}

- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = ({
            UIButton *view = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [view setImage:[UIImage imageNamed:@"others_more"] forState:(UIControlStateNormal)];
//            view.backgroundColor = UIColorFromRGBA(0x000000, 0.1);
//            view.layer.cornerRadius = 6;
//            view.tintColor = UIColor.mainTextColor;
            view;
        });
    }
    return _settingButton;
}

- (UILabel *)navigationTitleLabel {
    if (!_navigationTitleLabel) {
        _navigationTitleLabel = ({
            UILabel *titleLabel = [UILabel new];
            titleLabel.text = YCTLocalizedTableString(@"mine.title.mine", @"Mine");
            titleLabel.alpha = 0;
            titleLabel.font = [UIFont PingFangSCBold:17];
            titleLabel.textColor = UIColor.navigationBarTitleColor;
            titleLabel;
        });
    }
    return _navigationTitleLabel;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = ({
            JXCategoryTitleView *categoryView = [JXCategoryTitleView normalCategoryTitleView];
            categoryView.bounds = CGRectMake(0, 0, Iphone_Width, kHeightForHeaderInSection);
            categoryView.cellSpacing = 0;
            categoryView.backgroundColor = UIColor.whiteColor;
            categoryView.delegate = self;
            categoryView;
        });
    }
    return _categoryView;
}

-  (JXPagerView *)pagingView {
    if (!_pagingView) {
        _pagingView = ({
            JXPagerView *pagingView = [[JXPagerView alloc] initWithDelegate:self];
            pagingView.backgroundColor = self.view.backgroundColor;
            pagingView.mainTableView.gestureDelegate = self;
            pagingView.mainTableView.backgroundColor = self.view.backgroundColor;
            pagingView.automaticallyDisplayListVerticalScrollIndicator = NO;
            pagingView;
        });
    }
    return _pagingView;
}

- (YCTMineUserInfoView *)userInfoView {
    if (!_userInfoView) {
        _userInfoView = [[YCTMineUserInfoView alloc] init];
    }
    return _userInfoView;
}

#pragma mark - Override

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.isStatusBarLight;
}

@end
