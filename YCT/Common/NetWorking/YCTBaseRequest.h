//
//  SRMBaseRequest.h
//  SRMNetworking
//
//  Created by 李佳宏 on 2020/11/5.
//

#import <YTKNetwork/YTKNetwork.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const YCTRequestErrorDomain;

extern NSInteger const YCTRequestErrorCode;

@interface YCTBaseRequest : YTKBaseRequest

/// 请求过程中显示全局loading （需要在config文件配置）
@property (nonatomic, assign) BOOL isShowLoading;

/// 请求失败显示错误toust（需要在config文件配置）
@property (nonatomic, assign) BOOL isShowErrorToust;

/// 请求成功显成功toust（需要在config文件配置）
@property (nonatomic, assign) BOOL isShowSuccessToust;

/// 请求成功模型
@property (nonatomic, strong, readonly, nullable) id responseDataModel;

/// overload 返回接口数据模型
- (Class)dataModelClass;

- (NSDictionary *)yct_requestArgument;

- (NSString *)getMsg;

- (NSString *)getError;

@end

NS_ASSUME_NONNULL_END
