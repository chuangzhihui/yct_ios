//
//  YCTBasePagedViewModel.h
//  YCT
//
//  Created by 木木木 on 2021/12/29.
//

#import "YCTBaseViewModel.h"
#import "YCTPagedRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTBasePagedViewModel<T: YCTBaseModel *, E: YCTPagedRequest *> : YCTBaseViewModel

@property (strong) E request;

@property (copy, readonly) NSArray<T> *models;

@property (strong, readonly) RACSubject *hasMoreDataSubject;

- (void)requestData;
- (void)requestAllData;

- (void)resetRequestData;

- (void)refreshRequestData;

- (void)handleNewPageData:(NSArray<YCTBaseModel *> *)data;

- (NSUInteger)size;

@end

NS_ASSUME_NONNULL_END
