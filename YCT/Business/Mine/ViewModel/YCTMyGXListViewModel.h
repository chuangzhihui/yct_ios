//
//  YCTMyGXListViewModel.h
//  YCT
//
//  Created by 木木木 on 2021/12/31.
//

#import "YCTBasePagedViewModel.h"
#import "YCTApiGetMyGXList.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTMyGXListViewModel : YCTBasePagedViewModel<YCTMyGXListModel *, YCTApiGetMyGXList *>

- (instancetype)initWithType:(YCTMyGXListType)type;

@end

NS_ASSUME_NONNULL_END
