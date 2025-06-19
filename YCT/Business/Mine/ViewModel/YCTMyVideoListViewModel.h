//
//  YCTMyVideoListViewModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/1.
//

#import "YCTBasePagedViewModel.h"
#import "YCTApiMyVideoList.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTMyVideoListViewModel : YCTBasePagedViewModel<YCTVideoModel *, YCTApiMyVideoList *>

- (instancetype)initWithType:(YCTMyVideoListType)type;

@end

NS_ASSUME_NONNULL_END
