//
//  YCTGetLocationViewController.h
//  YCT
//
//  Created by 木木木 on 2021/12/26.
//

#import "YCTBaseViewController.h"
#import "YCTMintGetLocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YCTGetLocationViewControllerDelegate <NSObject>

@optional
- (void)locationDidSelectWithAll:(NSArray<YCTMintGetLocationModel *> *)locations
                        lastPrev:(YCTMintGetLocationModel *)lastPrev
                            last:(YCTMintGetLocationModel *)last;

@end

@interface YCTGetLocationViewController : YCTBaseViewController

- (instancetype)initWithDelegate:(id<YCTGetLocationViewControllerDelegate>)delegate;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
