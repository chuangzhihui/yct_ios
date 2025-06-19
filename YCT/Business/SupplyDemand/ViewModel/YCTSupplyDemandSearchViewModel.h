//
//  YCTSupplyDemandSearchViewModel.h
//  YCT
//
//  Created by 木木木 on 2022/3/3.
//

#import "YCTBasePagedViewModel.h"
#import "YCTApiSupplyDemandList.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTSupplyDemandSearchViewModel : YCTBasePagedViewModel<YCTSupplyDemandItemModel *, YCTApiSupplyDemandList *>

@property (nonatomic, copy, readonly) NSArray<NSString *> *historyKeys;
@property (nonatomic, assign) BOOL isHistoryFold;
@property (nonatomic, copy) NSString *locationId;
@property (nonatomic, copy) NSString *locationName;

- (void)searchWithKeyword:(NSString *)keyword;
- (void)searchWithType:(int)type;
- (void)clearHistoryKeys;

@end

NS_ASSUME_NONNULL_END
