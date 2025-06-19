//
//  YCTMineVideoSubViewController.h
//  YCT
//
//  Created by 木木木 on 2021/12/12.
//

#import "YCTBaseViewController.h"
#import <JXPagingView/JXPagerView.h>
#import "YCTMyVideoListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTMineVideoSubViewController : YCTBaseViewController<JXPagerViewListViewDelegate>

- (instancetype)initWithType:(YCTMyVideoListType)type;

@end

NS_ASSUME_NONNULL_END
