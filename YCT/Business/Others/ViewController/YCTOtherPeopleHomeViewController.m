//
//  YCTOtherPeopleHomeViewController.m
//  YCT
//
//  Created by 木木木 on 2022/1/5.
//

#import "YCTOtherPeopleHomeViewController.h"
#import <JXPagingView/JXPagerView.h>
#import "JXCategoryTitleView+Customization.h"
#import "YCTMineUserInfoView.h"
#import "YCTShareView.h"
#import "YCTShareFriendListView.h"
#import "YCTOtherPeopleHomeSubViewController.h"
#import "YCTApiOtherPeopleInfo.h"
#import "YCTChatViewController.h"
#import "YCTChatUtil.h"
#import "YCTOtherPeopleFansListViewController.h"
#import "YCTOtherPeopleFollowListViewController.h"
#import "YCTPhotoBrowser.h"
#import "YCTApiBlacklist.h"
#import "YCTWebviewURLProvider.h"
#import "YCTRootViewController.h"
#import "YCTFeedBackViewController.h"
#import "YCTNavigationCoordinator.h"
#import "YCTVendorInfoViewController.h"
#import "YCTMineEditInfoInputViewController.h"

#define kHeightForHeaderInSection 44

@interface YCTOtherPeopleHomeViewController ()<JXPagerViewDelegate, JXCategoryViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) YCTOtherPeopleInfoModel *model;
@property (nonatomic, assign) BOOL isStatusBarLight;

@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UILabel *navigationTitleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) YCTMineUserInfoView *userInfoView;
@property (nonatomic, strong) JXPagerView *pagingView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, copy) NSArray<NSString *> *titles;

@end

@implementation YCTOtherPeopleHomeViewController

+ (YCTOtherPeopleHomeViewController *)otherPeopleHomeWithUserId:(NSString *)userId {
    return [self otherPeopleHomeWithUserId:userId needGoMinePageIfNeeded:NO];
}

+ (YCTOtherPeopleHomeViewController *)otherPeopleHomeWithUserId:(NSString *)userId
                                         needGoMinePageIfNeeded:(BOOL)needGoMinePageIfNeeded {
    if (![YCTUserDataManager sharedInstance].isLogin) {
        [YCTNavigationCoordinator login];
        return nil;
    }
    
    if (needGoMinePageIfNeeded && [YCTUserDataManager sharedInstance].isLogin && [[YCTChatUtil unwrappedImID:[YCTUserDataManager sharedInstance].loginModel.IMName] isEqualToString:userId]) {
        [[YCTRootViewController sharedInstance] goToMine];
        return nil;
    }
    
    YCTOtherPeopleHomeViewController *vc = [[YCTOtherPeopleHomeViewController alloc] initWithUserId:userId];
    return vc;
}

- (instancetype)initWithUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        self.userId = userId;
        self.titles = @[
            YCTLocalizedTableString(@"mine.mine.works", @"Mine"),
            YCTLocalizedTableString(@"mine.mine.likes", @"Mine"),
        ];
        self.isStatusBarLight = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestOtherPeopleInfo];
}

- (void)bindViewModel {
    @weakify(self);
    [[self.backButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.moreButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        if ([YCTUserDataManager sharedInstance].isLogin) {
            [self showShareView];
        } else {
            [YCTNavigationCoordinator loginIfNeededWithAction:^{
                [self requestOtherPeopleInfo];
            }];
        }
    }];
    
    self.userInfoView.avatarClickBlock = ^{
        @strongify(self);
        if (!self.model.avatar) {
            return;
        }
        [YCTPhotoBrowser showPhotoBrowerInVC:self photoCount:1 currentIndex:0 photoConfig:^(NSUInteger idx, NSURL *__autoreleasing *photoUrl, UIImageView *__autoreleasing *sourceImageView) {
            *photoUrl = [NSURL URLWithString:self.model.avatar];
            *sourceImageView = self.userInfoView.avatarImageView;
        }];
    };
    
    self.userInfoView.fansClickBlock = ^{
        @strongify(self);
        if (!self.model.showFansList) {
            [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"others.alert.fansListBlock", @"Mine")];
            return;
        }
        YCTOtherPeopleFansListViewController *vc = [[YCTOtherPeopleFansListViewController alloc] initWithUserId:self.userId];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    self.userInfoView.followClickBlock = ^{
        @strongify(self);
        if (!self.model.showFansList) {
            [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"others.alert.followListBlock", @"Mine")];
            return;
        }
        YCTOtherPeopleFollowListViewController *vc = [[YCTOtherPeopleFollowListViewController alloc] initWithUserId:self.userId];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    self.userInfoView.qrCodeClickBlock = ^{
        @strongify(self);
        if (self.model) {
            UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
            [pasteBoard setValue:self.model.userTag forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
            [[YCTHud sharedInstance] showToastHud:YCTLocalizedString(@"alert.paste")];
        }
    };
    
    self.userInfoView.editInfoClickBlock = ^{
        @strongify(self);
        if ([YCTUserDataManager sharedInstance].isLogin) {
            [self requestFollow];
        } else {
            [YCTNavigationCoordinator loginIfNeededWithAction:^{
                [self requestOtherPeopleInfo];
            }];
        }
    };
    
    self.userInfoView.addVendorClickBlock = ^{
        @strongify(self);
        if (!self.model) return;
        if ([YCTUserDataManager sharedInstance].isLogin) {
            if (!self.model.canChat) {
                [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"others.alert.blockwhispers", @"Mine")];
                return;
            }
            [YCTChatViewController goToChatWithUserId:self.model.userId title:self.model.nickName from:self.navigationController];
        } else {
            [YCTNavigationCoordinator loginIfNeededWithAction:^{
                [self requestOtherPeopleInfo];
            }];
        }
    };
    
    self.userInfoView.carouselView.clickItem = ^(NSInteger index) {
        @strongify(self);
        if (!self.model) return;
        NSArray *banners = self.model.banners;
        [YCTPhotoBrowser showPhotoBrowerInVC:self photoCount:banners.count currentIndex:index photoConfig:^(NSUInteger idx, NSURL *__autoreleasing *photoUrl, UIImageView *__autoreleasing *sourceImageView) {
            *photoUrl = [NSURL URLWithString:banners[idx]];
        }];
    };
    
    self.userInfoView.vendorInfoClickBlock = ^{
        @strongify(self);
        YCTVendorInfoViewController *vc = [[YCTVendorInfoViewController alloc] initWithOtherPeople:self.model];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    [[RACObserve(self, model.isFollow) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (x.boolValue) {
            [self.userInfoView.leftButton
             setGrayStyleWithTitle:YCTLocalizedTableString(@"others.followed", @"Mine")
             fontSize:15
             cornerRadius:22
             imageName:nil];
            self.userInfoView.leftButton.backgroundColor = UIColor.selectedButtonBgColor;
            [self.userInfoView.leftButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        } else {
            [self.userInfoView.leftButton
             setMainThemeStyleWithTitle:YCTLocalizedTableString(@"others.follow", @"Mine")
             fontSize:15
             cornerRadius:22
             imageName:@"others_add"];
        }
    }];
    
    RAC(self.userInfoView.vipImageView, hidden) = [RACObserve(self, model.isauthentication) map:^id _Nullable(NSNumber * _Nullable value) {
        if (value) {
            return @(!value.boolValue);
        } else {
            return @(YES);
        }
    }];
    
    RAC(self.userInfoView.vipLabel, text) = [RACObserve(self, model.authentication) ignore:nil];
    
    [[RACObserve(self, model.avatar) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x) {
            [self.userInfoView.avatarImageView loadImageGraduallyWithURL:[NSURL URLWithString:x] placeholderImageName:kDefaultAvatarImageName];
        } else {
            self.userInfoView.avatarImageView.image = [UIImage imageNamed:kDefaultAvatarImageName];
        }
    }]; 
    
    [[RACObserve(self, model.userBg) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x) {
            [self.userInfoView.bgImageView loadImageGraduallyWithURL:[NSURL URLWithString:x] placeholderImageName:@"mine_mine_bg"];
        } else {
            self.userInfoView.bgImageView.image = [UIImage imageNamed:@"mine_mine_bg"];
        }
    }];
    
    RAC(self.userInfoView.nameLabel, text) = RACObserve(self, model.nickName);
    
    RAC(self.userInfoView.idValueLabel, text) = RACObserve(self, model.userTag);
    
//    [[RACObserve(self, model.userTags) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
//        @strongify(self);
//        NSLog(@"setUserTags:%@",x);
//        [self.userInfoView setUserTags:x];
//    }];
    [[RACObserve(self, model.userTags) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSArray<NSString *>*  _Nullable x) {
        NSString *tags=[x componentsJoinedByString:@","];
        NSLog(@"setUserTags:%@",x);
        [self.userInfoView setUserTags:tags];
    }];
    [[RACSignal combineLatest:@[[RACObserve(self, model.userType) skip:1], [RACObserve(self, model.interduce) skip:1]]] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        [self.userInfoView setBriefIntro:x.second isBusiness:((NSNumber *)x.first).intValue == 2];
        [self updateHeader];
    }];
    
    RAC(self.userInfoView.vendorInfoView.nameLabel, text) = [RACObserve(self, model.companyContact) ignore:nil];
    RAC(self.userInfoView.vendorInfoView.phoneLabel, text) = [RACObserve(self, model.companyPhone) ignore:nil];
    RAC(self.userInfoView.vendorInfoView.websiteLabel, text) = [RACObserve(self, model.companyWebSite) ignore:nil];
    RAC(self.userInfoView.vendorInfoView.siteLabel, text) = [RACObserve(self, model.companyAddress) ignore:nil];
    RAC(self.userInfoView.vendorInfoView.mainProductLabel, text) = [RACObserve(self, model.companytype) ignore:nil];
    RAC(self.userInfoView.vendorInfoView.companyNameLabel, text) = [RACObserve(self, model.companyName) ignore:nil];
    RAC(self.userInfoView.vendorInfoView.socialcodeLabel, text) = [RACObserve(self, model.socialcode) ignore:nil];
    RAC(self.userInfoView.vendorInfoView.emailLabel, text) = [RACObserve(self, model.companyEmail) ignore:nil];
    RAC(self.userInfoView.vendorInfoView.businessTimeLabel, text) = [[RACSignal combineLatest:@[RACObserve(self, model.businessstart), RACObserve(self, model.businessterm)]] map:^id _Nullable(RACTuple * _Nullable value) {
        NSString *businessstart = value.first ?: @"";
        NSString *businessterm = value.second ?: @"";
        return [NSString stringWithFormat:@"%@-%@", businessstart, businessterm];
    }];
    RAC(self.userInfoView.vendorInfoViewNew.companyNameLine.cont,text)=[RACObserve(self, model.companyName) ignore:nil];
    RAC(self.userInfoView.vendorInfoViewNew.companyDescLine.cont,text)=[RACObserve(self, model.interduce) ignore:nil];
    RAC(self.userInfoView.vendorInfoViewNew.mainProduct.cont,text)=[RACObserve(self, model.direction) ignore:nil];
//    RAC(self.userInfoView.vendorInfoViewNew.industry.cont,text)=[NSString stringWithFormat:@"%@/%@",[RACObserve(self, model.goodstypef) ignore:nil],[RACObserve(self, model.goodstypes) ignore:nil]];
    RAC(self.userInfoView.vendorInfoViewNew.industry.cont,text)=[[RACSignal combineLatest:@[RACObserve(self, model.goodstypef), RACObserve(self, model.goodstypes)]] map:^id _Nullable(RACTuple * _Nullable value) {
        NSString *goodstypef = value.first ?: @"-";
        NSString *goodstypes = value.second ?: @"-";
        if([goodstypef isEqual:@""]){
            goodstypef=@"-";
        }
        if([goodstypes isEqual:@""]){
            goodstypes=@"-";
        }
        if([goodstypef isEqual:@"-"]){
            return goodstypes;
        }else{
            if([goodstypes isEqual:@"-"]){
                return goodstypef;
            }
        }
        return [NSString stringWithFormat:@"%@/%@", goodstypef, goodstypes];
    }];
    [[RACSignal combineLatest:@[RACObserve(self, model.userType), RACObserve(self, model.banners)]] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        NSNumber *userType = x.first;
        if (userType.intValue == 1) {
            [self.userInfoView setBanners:nil];
        } else {
            [self.userInfoView setBanners:x.second];
        }
    }];
    
    RAC(self.userInfoView.likeCountLabel, text) = [RACObserve(self, model.zanNum) map:^id _Nullable(NSNumber * _Nullable value) {
        return [value stringValue];
    }];
    
    RAC(self.userInfoView.attentionCountLabel, text) = [RACObserve(self, model.floowNum) map:^id _Nullable(NSNumber * _Nullable value) {
        return [value stringValue];
    }];
    
    RAC(self.userInfoView.fansCountLabel, text) = [RACObserve(self, model.fansNum) map:^id _Nullable(NSNumber * _Nullable value) {
        return [value stringValue];
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
    
    [self.view addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(27);
        make.top.mas_equalTo(((kNavigationBarHeight - kStatusBarHeight) - 27) / 2 + kStatusBarHeight);
        make.right.mas_equalTo(-15);
    }];
    
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(27);
        make.top.mas_equalTo(((kNavigationBarHeight - kStatusBarHeight) - 27) / 2 + kStatusBarHeight);
        make.left.mas_equalTo(15);
    }];
    
    self.userInfoView = [[YCTMineUserInfoView alloc] init];
    [self.userInfoView setOtherPeopleStyle];
    [self.userInfoView.leftButton
     setMainThemeStyleWithTitle:YCTLocalizedTableString(@"others.follow", @"Mine")
     fontSize:15
     cornerRadius:22
     imageName:@"others_add"];
    [self.userInfoView.rightButton
     setGrayStyleWithTitle:YCTLocalizedTableString(@"others.message", @"Mine")
     fontSize:15
     cornerRadius:22
     imageName:@"others_message"];
    self.userInfoView.idCodeImageView.image = [UIImage imageNamed:@"others_copy"];
    
    self.categoryView.titles = self.titles;
    self.categoryView.bounds = CGRectMake(0, 0, Iphone_Width, kHeightForHeaderInSection);
    
    self.pagingView.pinSectionHeaderVerticalOffset = kNavigationBarHeight;//self.userInfoView.contentHeight + 10;
    [self.view addSubview:self.pagingView];

    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagingView.frame = self.view.bounds;
    [self.view bringSubviewToFront:self.navigationBarView];
    [self.view bringSubviewToFront:self.moreButton];
    [self.view bringSubviewToFront:self.backButton];
}

- (BOOL)naviagtionBarHidden {
    return YES;
}

#pragma mark - Private

- (void)updateHeader {
    [self.userInfoView updateContentHeight];
    [self.pagingView resizeTableHeaderViewHeightWithAnimatable:NO duration:0 curve:(UIViewAnimationCurveLinear)];
}

- (void)requestOtherPeopleInfo {
    [[YCTHud sharedInstance] showLoadingHud];
    YCTApiOtherPeopleInfo *api = [[YCTApiOtherPeopleInfo alloc] initWithUserId:self.userId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        NSLog(@"res:%@",request.responseString);
        self.model = request.responseDataModel;
        self.model.userId = self.userId;
        if ([YCTUserDataManager sharedInstance].isLogin && [[YCTChatUtil unwrappedImID:[YCTUserDataManager sharedInstance].loginModel.IMName] isEqualToString:self.model.userId]) {
            [self.userInfoView hideContactButton];
        }
        [self updateHeader];
        
        [[YCTHud sharedInstance] hideHud];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (void)requestFollow {
    if (!self.model) {
        return;
    }
    
    [[YCTUserFollowHelper sharedInstance] handleFollowStateWithUser:self.model];
}

- (void)showShareView {
    YCTShareView *view = [YCTShareView new];
    YCTShareType types = (YCTShareUser | YCTSharePrivateMessage | YCTShareWeChatTimeLine | YCTShareWeChat | YCTShareZalo);
    
    if (![YCTUserDataManager sharedInstance].isLogin || ![[YCTChatUtil unwrappedImID:[YCTUserDataManager sharedInstance].loginModel.IMName] isEqualToString:self.model.userId]) {
        types |= YCTShareReport | YCTShareBlacklist | YCTShareRemark;
    }
    
    [view setShareTypes:types shareBlock:^(YCTShareType shareType, YCTShareResultModel * _Nullable resultModel) {
        if (shareType == YCTShareUser) {
            [resultModel.userIds enumerateObjectsUsingBlock:^(NSString * _Nonnull userId, NSUInteger idx, BOOL * _Nonnull stop) {
                [YCTChatUtil sendFollowMsg:self.model.nickName avatarUrl:self.model.avatar followUserId:self.userId userId:userId remark:resultModel.note];
            }];
            [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedString(@"alert.sendSuccess")];
        }
        else if (shareType == YCTShareBlacklist) {
            [[YCTHud sharedInstance] showLoadingHud];
            YCTApiHandleBlacklist *api = [[YCTApiHandleBlacklist alloc] initWithType:YCTHandleBlacklistTypeAdd userId:self.userId];
            [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
                [[YCTHud sharedInstance] showDetailToastHud:request.getMsg];
            } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
                [[YCTHud sharedInstance] showDetailToastHud:request.getError];
            }];
        }
        else if (shareType == YCTShareWeChat || shareType == YCTShareWeChatTimeLine || shareType == YCTShareZalo || shareType == YCTShareFB) {
            YCTOpenPlatformType type = YCTOpenPlatformTypeZalo;
            if (shareType == YCTShareWeChatTimeLine) {
                type = YCTOpenPlatformTypeWeChatTimeLine;
            } else if (shareType == YCTShareWeChat) {
                type = YCTOpenPlatformTypeWeChatSession;
            }else if(shareType==YCTShareFB){
                type=YCTOpenPlatformTypeFaceBook;
            }
            
            YCTShareWebpageItem *webpageItem = [YCTShareWebpageItem new];
            webpageItem.webpageUrl = [YCTWebviewURLProvider sharedUserHomePageUrlWithId:self.userId].absoluteString;
            webpageItem.desc = self.model.nickName;
            webpageItem.thumbImage = self.model.avatar;
            YCTOpenMessageObject *msg = [YCTOpenMessageObject new];
            msg.shareObject = webpageItem;
            [[YCTOpenPlatformManager defaultManager] sendMessage:msg toPlatform:type completion:^(BOOL isSuccess, NSString * _Nullable error) {
                if (isSuccess) {
                    [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedString(@"alert.shareSuccess")];
                } else {
                    [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedString(@"alert.shareFailed")];
                }
            }];
        }
        else if (shareType == YCTShareReport) {
            YCTFeedBackViewController * report = [[YCTFeedBackViewController alloc] initWithReportType:YCTReportTypeUser reportId:self.model.userId];
            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:report];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [[UIViewController currentViewController] presentViewController:nav animated:YES completion:nil];
        }
        else if  (shareType == YCTShareRemark) {
            YCTMineEditInfoInputViewController *vc = [[YCTMineEditInfoInputViewController alloc] init];
//            vc.originalValue = self.friendProfile.friendRemark;
            vc.title = YCTLocalizedTableString(@"chat.title.setAlias", @"Chat");
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [view show];
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
    BOOL isBlock = (index == 1 && !self.model.showZanList);
    YCTOtherPeopleHomeSubViewController *list = [[YCTOtherPeopleHomeSubViewController alloc] initWithType:index userId:self.userId isBlock:isBlock];
    return list;
}

- (void)pagerView:(JXPagerView *)pagerView mainTableViewDidScroll:(UIScrollView *)scrollView {
    [self.userInfoView scrollViewDidScroll:scrollView.contentOffset.y];
    CGFloat alpha;

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
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.navigationController.interactivePopGestureRecognizer == otherGestureRecognizer) {
        return NO;
    }
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

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = ({
            UIButton *view = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [view setImage:[UIImage imageNamed:@"others_more"] forState:(UIControlStateNormal)];
            view;
        });
    }
    return _moreButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = ({
            UIButton *view = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [view setImage:[UIImage imageNamed:@"others_back"] forState:(UIControlStateNormal)];
            view;
        });
    }
    return _backButton;
}

- (UILabel *)navigationTitleLabel {
    if (!_navigationTitleLabel) {
        _navigationTitleLabel = ({
            UILabel *titleLabel = [UILabel new];
            titleLabel.text = @"";
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
            categoryView.backgroundColor = UIColor.whiteColor;
            categoryView.delegate = self;
            categoryView.cellSpacing = 0;
            categoryView.contentEdgeInsetLeft = 0;
            categoryView.contentEdgeInsetRight = 0;
            categoryView.averageCellSpacingEnabled = NO;
            categoryView.cellWidth = Iphone_Width / 2;
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
            [pagingView.listContainerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
            pagingView;
        });
    }
    return _pagingView;
}

#pragma mark - Override

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.isStatusBarLight;
}

@end
