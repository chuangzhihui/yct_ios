//
//  YTCBaseViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import "YCTBaseViewController.h"

@interface YCTBaseViewController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation YCTBaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.view.backgroundColor = UIColor.whiteColor;
    self.view.backgroundColor = UIColor.whiteColor;
    [self configBackButton];
    [self setupView];
    [self bindViewModel];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
#pragma mark  -- by override
- (void)setupView{
    
}

- (void)bindViewModel{
    
}

#pragma mark  -- navigation

- (BOOL)naviagtionBarHidden{
    return NO;
}

- (void)onBack:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configBackButton
{
    if ([self.navigationController.viewControllers indexOfObject:self] == 0) {
        return;
    }
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeSystem];
    barButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [barButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [barButton setFrame:CGRectMake(0, 0, 40, 40)];
    [barButton addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.leftBarButtonItems = @[backitem];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        BOOL oneMore = ([self.navigationController.viewControllers count] > 1);
        BOOL notFirst = ([self.navigationController.viewControllers firstObject] != self);
        return (oneMore && notFirst);
    }
    return YES;
}

#pragma mark - naviagtionDelegate
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[YCTBaseViewController class]] && [viewController respondsToSelector:@selector(naviagtionBarHidden)] && [(YCTBaseViewController *)viewController naviagtionBarHidden]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark - other
///快捷添加子控制器
- (void)addChildVC:(UIViewController *)vc{
    [vc beginAppearanceTransition:YES animated:NO];
    [self.view addSubview:vc.view];
    [vc endAppearanceTransition];
    [vc didMoveToParentViewController:self];
}

#pragma mark - Override

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
