//
//  YCTHomeVideoViewController.h
//  YCT
//
//  Created by hua-cloud on 2021/12/12.
//

#import "YCTBaseViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "YCTVideoModel.h"
#import "YCTVideoDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTVideoViewController : YCTBaseViewController

- (instancetype)initWithVideoModels:(NSArray<YCTVideoModel *> *)videoModels
                              index:(NSInteger)index
                               type:(YCTVideoType)type;

- (void)onWillAppear;

- (void)onWillDisappear;

- (void)updateModels:(NSArray<YCTVideoModel *> *)models refresh:(BOOL)refresh;

- (void)handleWithHeaderRefershCallback:(dispatch_block_t)callBack;

- (void)handleWithFooerRefershCallback:(dispatch_block_t)callBack;

- (void)endRefreshWithHasMore:(BOOL)hasMore;

- (void)handlerWhenIndexChange:(void(^)(NSInteger index))handler;

@property (nonatomic, strong) NSIndexPath *targetIndexPath; // Property to store index path


@end

NS_ASSUME_NONNULL_END
