//
//  YCTGetGoodsTypeListViewController.h
//  YCT
//
//  Created by 木木木 on 2022/5/9.
//

#import "YCTBaseViewController.h"
#import "YCTMintGetLocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YCTGetGoodsTypeListViewControllerDelegate <NSObject>

@optional
- (void)goodsTypeDidSelectWithAll:(NSArray<YCTMintGetLocationModel *> *)locations
                         lastPrev:(YCTMintGetLocationModel *)lastPrev
                             last:(YCTMintGetLocationModel *)last;

@end

@interface YCTGetGoodsTypeListViewController : YCTBaseViewController

- (instancetype)initWithDelegate:(id<YCTGetGoodsTypeListViewControllerDelegate>)delegate;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
