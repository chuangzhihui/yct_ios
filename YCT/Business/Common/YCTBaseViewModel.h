//
//  YCTBaseViewModel.h
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTBaseViewModel : NSObject
///网络请求时的加载转子
@property (nonatomic, strong, readonly) RACSubject * loadingSubject;
///提示框
@property (nonatomic, strong, readonly) RACSubject * toastSubject;
///缺省页
@property (nonatomic, strong, readonly) RACSubject * noDataSubject;
///网络错误
@property (nonatomic, strong, readonly) RACSubject * netWorkErrorSubject;
///加载完全部数据
@property (nonatomic, strong, readonly) RACSubject * loadAllDataSubject;

@end

NS_ASSUME_NONNULL_END
