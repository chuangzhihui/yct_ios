//
//  YTCBaseViewController.h
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTBaseViewController : UIViewController

#pragma mark -- by override
///加载配置视图
- (void)setupView;
///绑定viewModel
- (void)bindViewModel;

- (void)configBackButton;

#pragma mark -- navigation
///是否隐藏导航控制器
- (BOOL)naviagtionBarHidden;

- (void)onBack:(UIButton *)sender;

#pragma mark - othoer
///快捷添加子控制器
- (void)addChildVC:(UIViewController *)vc;
@end

NS_ASSUME_NONNULL_END
