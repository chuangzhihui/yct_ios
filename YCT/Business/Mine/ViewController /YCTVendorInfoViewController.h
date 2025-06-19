//
//  YCTVendorInfoViewController.h
//  YCT
//
//  Created by 木木木 on 2022/5/8.
//

#import "YCTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class YCTOtherPeopleInfoModel;

@interface YCTVendorInfoViewController : YCTBaseViewController

- (instancetype)initWithOtherPeople:(YCTOtherPeopleInfoModel *)model;
- (instancetype)initWithMine;

@end

NS_ASSUME_NONNULL_END
