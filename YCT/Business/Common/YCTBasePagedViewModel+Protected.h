//
//  YCTBasePagedViewModel+Protected.h
//  YCT
//
//  Created by 木木木 on 2021/12/31.
//

#import "YCTBasePagedViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTBasePagedViewModel (Protected)
@property (assign) NSUInteger page;
@property (strong) NSMutableArray<__kindof YCTBaseModel *> *modelsM;
@property (copy, readwrite) NSArray<__kindof YCTBaseModel *> *models;
@property (strong, readwrite) RACSubject *hasMoreDataSubject;
@end

NS_ASSUME_NONNULL_END
