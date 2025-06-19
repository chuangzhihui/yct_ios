//
//  YCTRootViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/8.
//

#import "YCTRootViewController.h"
#import "YCTTabbar.h"
#import "ViewController.h"
#import "YCTHomeViewController.h"
#import "YCTPostViewController.h"
#import "YCTChatListViewController.h"
#import "YCTMineViewController.h"
#import "YCTPublishBottomView.h"
#import "YCTNavigationCoordinator.h"
#if DEBUG
#import <FLEX/FLEXManager.h>
#endif
#import "UITabBar+Badge.h"
#import "YCTChatUtil.h"
#import "YCT-Swift.h"
#import "DraggableView.h"
#import "YCTBecomeCompanyViewController.h"

#define kHomeTabbarIndex 0
#define kPostTababrIndex 1
#define kChatTabbarIndex 3
#define kMineTabbarIndex 4

@interface YCTRootViewController ()<UITabBarControllerDelegate>
@property (nonatomic, strong, readwrite) RACSubject * homeSelected;
@property (nonatomic, assign) BOOL isFirstLight;
@end

@implementation YCTRootViewController

+ (YCTRootViewController *)sharedInstance {
    UIViewController *vc = [[UIApplication sharedApplication].delegate window].rootViewController;
    if ([vc isKindOfClass:YCTRootViewController.class]) {
        return (YCTRootViewController *)vc;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    if ([self respondsToSelector:@selector(tabBar)]) {
        [self setValue:[YCTTabbar new] forKey:@"tabBar"];
    }
    
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [self tabBarAppearance];
        self.tabBar.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = appearance;
        }
    } else {
        self.tabBar.shadowImage = [[UIImage alloc] init];
        self.tabBar.backgroundColor = UIColor.blackColor;
    }
    self.tabBar.translucent = NO;
    self.delegate = self;
    
    [self addChildVC:({
        YCTHomeViewController * home =[YCTHomeViewController new];
        home.hidesBottomBarWhenPushed = NO;
        
        home;
    }) title:YCTLocalizedString(@"tabHome") titleColor:UIColor.tabbarTitleColorDark selectedTitleColor:UIColor.tabbarTitleColorDarkSelected];
    
    [self addChildVC:({
        YCTPostViewController *postVC = [[YCTPostViewController alloc] init];
        postVC.hidesBottomBarWhenPushed = NO;
        postVC;
    }) title:YCTLocalizedString(@"tabPost") titleColor:UIColor.tabbarTitleColorLight selectedTitleColor:UIColor.tabbarTitleColorLightSelected];
    
    [self addChildVC:[UIViewController new] title:@"" titleColor:UIColor.tabbarTitleColorLight selectedTitleColor:UIColor.tabbarTitleColorLightSelected];
    
    
    LiveEventListViewController *vc = [[LiveEventListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = NO;
    [self addChildVC:vc
               title:YCTLocalizedString(@"tabNews")
          titleColor:UIColor.tabbarTitleColorLight
  selectedTitleColor:UIColor.tabbarTitleColorLightSelected];
    
//    [self addChildVC:({
//        YCTChatListViewController *postVC = [[YCTChatListViewController alloc] init];
//        postVC.hidesBottomBarWhenPushed = NO;
//        postVC;
//    }) title:YCTLocalizedString(@"tabNews") titleColor:UIColor.tabbarTitleColorLight selectedTitleColor:UIColor.tabbarTitleColorLightSelected];
    
    [self addChildVC:({
        YCTMineViewController *postVC = [[YCTMineViewController alloc] init];
        postVC.hidesBottomBarWhenPushed = NO;
        postVC;
    }) title:YCTLocalizedString(@"tabMine") titleColor:UIColor.tabbarTitleColorLight selectedTitleColor:UIColor.tabbarTitleColorLightSelected];
    
    [[YCTUserManager sharedInstance] autoLoginFetchUserInfo];
    
    YCTTabbar *tabbar = (YCTTabbar *)self.tabBar;
    [tabbar.middleButton addTarget:self action:@selector(middleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self bindViewModel];
    
    // Create and add the draggable view
    //    DraggableView *draggable = [[DraggableView alloc] initWithFrame:CGRectMake(50, 100, 140, 140) showLabelAndBackground:YES];
    //
    //    [self.view addSubview:draggable];
    
}

- (void)bindViewModel {
    [[[NSNotificationCenter.defaultCenter rac_addObserverForName:kYCTChatUtilUnreadMsgChangedNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        NSNumber *unreadCount = x.object[kYCTChatUtilUnreadMsgCountKey];
        int _unreadCount = 0;
        if (unreadCount) {
            _unreadCount = unreadCount.intValue;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_unreadCount == 0) {
                [self.tabBar hideBadgeOnItemIndex:kChatTabbarIndex];
            } else {
                [self.tabBar showBadgeOnItemIndex:kChatTabbarIndex];
            }
        });
    }];
    
    [[[NSNotificationCenter.defaultCenter rac_addObserverForName:kYCTChatUtilLogoutSuccessNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tabBar hideBadgeOnItemIndex:kChatTabbarIndex];
        });
    }];
}

- (void)addChildVC:(UIViewController *)vc
             title:(NSString *)title
        titleColor:(UIColor *)titleColor
selectedTitleColor:(UIColor *)selectedTitleColor {
    
    NSDictionary *textAttributes = @{
        NSForegroundColorAttributeName: titleColor,
        NSFontAttributeName: [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)]
    };
    NSDictionary *selectedTextAttributes = @{
        NSForegroundColorAttributeName: selectedTitleColor,
        NSFontAttributeName: [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)]
    };
    
    // Check if the view controller is already a UINavigationController
    UINavigationController *nav;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)vc;
    } else {
        nav = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    
    nav.tabBarItem.title = title;
    [nav.tabBarItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -15);
    
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [self tabBarAppearance];
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = textAttributes;
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedTextAttributes;
        nav.tabBarItem.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            nav.tabBarItem.scrollEdgeAppearance = appearance;
        }
    }
    
    [self addChildViewController:nav];
}


- (UITabBarAppearance *)tabBarAppearance API_AVAILABLE(ios(13.0)) {
    UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = UIColor.blackColor;
    appearance.shadowImage = [[UIImage alloc] init];
    appearance.shadowColor = UIColor.clearColor;
    NSDictionary *textAttributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)]
    };
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = textAttributes;
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = textAttributes;
    appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffsetMake(0, -15);
    appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffsetMake(0, -15);
    return appearance;
}

#if DEBUG
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [[FLEXManager sharedManager] showExplorer];
    }
}
#endif

#pragma mark - Response

- (void)middleButtonPressed:(UIButton *)sender {
    YCTPublishBottomView * bottomView = [YCTPublishBottomView new];
    bottomView.onButtonClick = ^{
        [self pushSwiftViewController];
    };
    
    bottomView.moveToProfileAdd = ^{
        [self pushToBecomeCompany];
    };
    [bottomView yct_show];
}


- (void)pushToBecomeCompany {
    NSLog(@"Push to Become Company");
    
    // Get the currently selected view controller
    UIViewController *selectedVC = self.selectedViewController;
    
    // Check if the selected view controller is embedded in a UINavigationController
    UINavigationController *navigationController = nil;
    if ([selectedVC isKindOfClass:[UINavigationController class]]) {
        navigationController = (UINavigationController *)selectedVC;
    } else if ([selectedVC isKindOfClass:[UIViewController class]]) {
        navigationController = selectedVC.navigationController;
    }
    
    if (navigationController) {
        // Create an instance of YCTBecomeCompanyViewController
        YCTBecomeCompanyViewController *vc = [YCTBecomeCompanyViewController new];
        // Push the view controller onto the navigation stack
        [navigationController pushViewController:vc animated:YES];
    } else {
        NSLog(@"Error: The current selected view controller is not embedded in a UINavigationController.");
    }
}



- (void)pushSwiftViewController {
    NSLog(@"Button pressed1111");
    //        普通用户需去完善资料
    
    // Get the topmost view controller
    UIViewController *topViewController = [self topViewController];
    
    // Check if the top view controller is in a UINavigationController
    UINavigationController *navigationController = nil;
    if ([topViewController isKindOfClass:[UINavigationController class]]) {
        navigationController = (UINavigationController *)topViewController;
    } else if ([topViewController.navigationController isKindOfClass:[UINavigationController class]]) {
        navigationController = topViewController.navigationController;
    }
    
    if (navigationController) {
        if ([YCTUserDataManager sharedInstance].userInfoModel.userType == YCTMineUserTypeNormal) {
    //        YCTUpgradeToVendorViewController *vc = [[YCTUpgradeToVendorViewController alloc] init];
            YCTBecomeCompanyViewController *vc = [[YCTBecomeCompanyViewController alloc] init];
            [navigationController pushViewController:vc animated:YES];
            
            return;
        }
        // Load the storyboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AIChatBot" bundle:nil];
        
        // Instantiate the ChatBotViewController from the storyboard
        GenerateVideoViewController *chatBotVC = [storyboard instantiateViewControllerWithIdentifier:@"GenerateVideoViewController"];
        
        // Configure the view controller
        chatBotVC.hidesBottomBarWhenPushed = YES;
        
        // Push the new view controller onto the navigation stack
        [navigationController pushViewController:chatBotVC animated:YES];
    } else {
        NSLog(@"Error: Top view controller is not embedded in a UINavigationController.");
    }
}

// Helper method to get the topmost view controller
- (UIViewController *)topViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topController = rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}


#pragma mark - Public

- (void)backToHome {
    [self goToIndex:kHomeTabbarIndex];
}

- (void)goToMine {
    if ([YCTUserDataManager sharedInstance].isLogin) {
        [self goToIndex:kMineTabbarIndex];
    }
}

- (void)goToIndex:(NSUInteger)index {
    
    UINavigationController *currentNavi = self.selectedViewController;
    void (^completion)(void) = ^ {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setSelectedIndex:index];
            [self tabBarController:self didSelectViewController:self.viewControllers[index]];
            [currentNavi popToRootViewControllerAnimated:YES];
        });
    };
    if (currentNavi.presentedViewController) {
        [currentNavi.presentedViewController dismissViewControllerAnimated:YES completion:completion];
    } else {
        completion();
    }
}

- (void)updateTabbarStyle:(BOOL)isLightStyle {
    self.isFirstLight = isLightStyle;
    [self updateTabbarSelectedTitleColor:self.isFirstLight ? UIColor.tabbarTitleColorLightSelected : UIColor.tabbarTitleColorDarkSelected];
    [UIView transitionWithView:self.tabBar duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut animations:^{
        [self updateTabbarBackgroundColor:self.isFirstLight ? UIColor.whiteColor : UIColor.blackColor];
    } completion:NULL];
}

#pragma mark - Private

- (void)updateTabbarBackgroundColor:(UIColor *)bgColor {
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = self.tabBar.standardAppearance;
        appearance.backgroundColor = bgColor;
        self.tabBar.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = appearance;
        }
        [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UITabBarAppearance *appearance = obj.tabBarItem.standardAppearance;
            appearance.backgroundColor = bgColor;
            obj.tabBarItem.standardAppearance = appearance;
            if (@available(iOS 15.0, *)) {
                obj.tabBarItem.scrollEdgeAppearance = appearance;
            }
        }];
    } else {
        self.tabBar.translucent = NO;
        self.tabBar.backgroundColor = bgColor;
    }
}

- (void)updateTabbarSelectedTitleColor:(UIColor *)selectedTitleColor {
    NSDictionary *textAttributes = @{
        NSForegroundColorAttributeName: UIColor.tabbarTitleColorDark,
        NSFontAttributeName: [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)]
    };
    NSDictionary *selectedTextAttributes = @{
        NSForegroundColorAttributeName: selectedTitleColor,
        NSFontAttributeName: [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)]
    };
    
    UINavigationController *nav = self.selectedViewController;
    [nav.tabBarItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -15);
    
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [self tabBarAppearance];
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = textAttributes;
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedTextAttributes;
        nav.tabBarItem.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            nav.tabBarItem.scrollEdgeAppearance = appearance;
        }
    }
}


#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    // MARK: - Added if Index is Already selected do not let it select again.
    if (viewController == self.selectedViewController) {
        return NO;
    }
    
    if (viewController == self.viewControllers[2]) {
        return NO;
    }
    
    if (viewController == self.selectedViewController) {
        UIViewController *vc = ((UINavigationController *)self.selectedViewController).viewControllers.firstObject;
        if ([vc respondsToSelector:@selector(refreshWhenTapTabbarItem)]) {
            [vc performSelector:@selector(refreshWhenTapTabbarItem)];
        }
    }
    
    if (
        viewController == self.viewControllers[kChatTabbarIndex]
        || viewController == self.viewControllers[kMineTabbarIndex]
        ) {
            [YCTNavigationCoordinator loginIfNeededWithAction:^{
                self.selectedIndex = [self.viewControllers indexOfObject:viewController];
                [self tabBarController:self didSelectViewController:viewController];
            }];
            return NO;
        } else if (viewController == self.viewControllers[kPostTababrIndex]) {
            self.selectedIndex = [self.viewControllers indexOfObject:viewController];
            [self tabBarController:self didSelectViewController:viewController];
        }
    
    NSInteger targeIndex = [tabBarController.viewControllers indexOfObject:viewController];
    if (self.selectedIndex == targeIndex) {
        if (targeIndex == 0) {
            [self.homeSelected sendNext:@""];
        }
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    [self updateTabbarSelectedTitleColor:(index == 0 && self.isFirstLight) || index != 0 ? UIColor.tabbarTitleColorLightSelected : UIColor.tabbarTitleColorDarkSelected];
    [UIView transitionWithView:self.tabBar duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut animations:^{
        [self updateTabbarBackgroundColor:(index == 0 && self.isFirstLight) || index != 0 ? UIColor.whiteColor : UIColor.blackColor];
    } completion:NULL];
}

#pragma mark - Override

- (UIViewController *)childViewControllerForStatusBarHidden {
    if ([self.selectedViewController isKindOfClass:UINavigationController.class]) {
        return ((UINavigationController *)self.selectedViewController).topViewController;
    }
    return self.selectedViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    if ([self.selectedViewController isKindOfClass:UINavigationController.class]) {
        return ((UINavigationController *)self.selectedViewController).topViewController;
    }
    return self.selectedViewController;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (RACSubject *)homeSelected{
    if (!_homeSelected) {
        _homeSelected = [RACSubject subject];
    }
    return _homeSelected;
}
@end
