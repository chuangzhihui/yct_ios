//
//  YCTGetGoodsTypeListViewModel.h
//  YCT
//
//  Created by 木木木 on 2022/5/9.
//

#import "YCTBaseViewModel.h"
#import "YCTMintGetLocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTGetGoodsTypeListViewModel : YCTBaseViewModel

- (instancetype)initWithPid:(NSString *)pid;

- (void)requestData;

@property (readonly) NSDictionary<NSString *, NSArray<YCTMintGetLocationModel *> *> *dataDict;

@property (readonly) NSArray *groupList;

@end

NS_ASSUME_NONNULL_END
