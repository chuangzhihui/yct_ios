//
//  YCTSystemMsgViewModel.h
//  YCT
//
//  Created by 木木木 on 2021/12/29.
//

#import "YCTBasePagedViewModel.h"
#import "YCTApiSystemMsg.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTSystemMsgViewModel : YCTBasePagedViewModel<YCTSystemMsgModel *, YCTApiSystemMsg *>

@property (assign, nonatomic) BOOL isLoadingData;

@property (assign, nonatomic) BOOL isNoMoreData;

- (void)requestDataWithCompletion:(void (^)(BOOL isFirstLoad, BOOL isNoMoreData, NSArray<YCTSystemMsgModel *> *newData))succeedBlock
                        failBlock:(void (^)(NSString *error))failBlock;

- (CGFloat)getCellHeightAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
