//
//  YCTBlacklistViewModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/9.
//

#import "YCTBasePagedViewModel.h"
#import "YCTApiBlacklist.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTBlacklistViewModel : YCTBasePagedViewModel<YCTBlacklistItemModel *, YCTApiBlacklist *>

@end

NS_ASSUME_NONNULL_END
