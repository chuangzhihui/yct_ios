//
//  YCTMyWatchHistoryViewModel.h
//  YCT
//
//  Created by 木木木 on 2021/12/31.
//

#import "YCTBasePagedViewModel.h"
#import "YCTApiMyWatchHistory.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTMyWatchHistoryViewModel : YCTBasePagedViewModel<YCTVideoModel *, YCTApiMyWatchHistory *>

- (void)requestClearHistory;

@end

NS_ASSUME_NONNULL_END
