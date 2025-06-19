//
//  YCTMyPostSubViewController.h
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import "YCTBaseViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "YCTMyGXListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTMyPostSubViewController : YCTBaseViewController<JXCategoryListContentViewDelegate>

- (instancetype)initWithType:(NSUInteger)type;

@end

NS_ASSUME_NONNULL_END
