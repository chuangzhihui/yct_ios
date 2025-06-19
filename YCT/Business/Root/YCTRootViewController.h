//
//  YCTRootViewController.h
//  YCT
//
//  Created by 木木木 on 2021/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YCTRootSubViewControllerProtocol <NSObject>

- (void)refreshWhenTapTabbarItem;

@end

@interface YCTRootViewController : UITabBarController

@property (nonatomic, strong, readonly) RACSubject * homeSelected;

+ (YCTRootViewController *)sharedInstance;

- (void)backToHome;

- (void)goToMine;

- (void)updateTabbarStyle:(BOOL)isLightStyle;

@end

NS_ASSUME_NONNULL_END
