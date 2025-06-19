//
//  YTCPostSubViewController.h
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import "YCTBaseViewController.h"
#import <JXCategoryView/JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTPostSubViewController : YCTBaseViewController<JXCategoryListContentViewDelegate>

- (instancetype)initWithType:(NSUInteger)type;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
