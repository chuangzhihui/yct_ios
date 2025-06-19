//
//  YCTSearchSubViewController.h
//  YCT
//
//  Created by hua-cloud on 2021/12/23.
//

#import "YCTBaseViewController.h"
#import "YCTSearchViewModel.h"
#import <JXCategoryView/JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTSearchSubViewController : YCTBaseViewController<JXCategoryListContentViewDelegate>

- (instancetype)initWithType:(YCTSearchResultType)type
                     keyword:(NSString *)keyword
                  locationId:(NSString *)locationId;
@end

NS_ASSUME_NONNULL_END
