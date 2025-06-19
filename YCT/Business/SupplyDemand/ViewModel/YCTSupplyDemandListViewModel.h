//
//  YCTSupplyDemandListViewModel.h
//  YCT
//
//  Created by 木木木 on 2021/12/10.
//

#import "YCTBasePagedViewModel.h"
#import "YCTApiSupplyDemandList.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTSupplyDemandListViewModel : YCTBasePagedViewModel<YCTSupplyDemandItemModel *, YCTApiSupplyDemandList *>

- (instancetype)initWithType:(NSUInteger)type;

@end

NS_ASSUME_NONNULL_END
