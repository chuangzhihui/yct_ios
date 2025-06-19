//
//  SRMRequestConfig.h
//  SRMNetworking
//
//  Created by 李佳宏 on 2020/11/5.
//


#import "YCTBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN

@protocol YCTRequestConfigDelegate <NSObject>

@optional

/// 配置请求头参数
/// @param request 当前请求实例对象
- (NSDictionary *)configPublicRequestHeaderDicWithRequest:(YCTBaseRequest *)request;

/// 配置请求链接公参
/// @param argument 当前请求的参数
- (NSDictionary *)configPublicRequestUrlArgumentWithArgument:(NSDictionary *)argument;

/// 配置请求公参
/// @param argument 当前请求的参数
- (NSDictionary *)configPublicRequestArgumentWithArgument:(NSDictionary *)argument;

/// 配置请求成功的全局toust
/// @param request 请求实例
- (void)showReuqestSuccessMessage:(YCTBaseRequest *)request;

/// 配置请求失败的全局toust
/// @param request 请求实例
- (void)showErrorMessageWithMessage:(YCTBaseRequest *)request;

/// 配置请求中的全局loading
- (void)showLoading;

/// 配置请求的json校验
/// @param request 请求实例
- (id)jsonValidatorWithReuqest:(YCTBaseRequest *)request;

/// 配置请求数据层
/// @param resultDict 数据层的字典，方便转model
- (id)getParsedDataWithRequestResultDict:(NSDictionary *)resultDict;

@end

NS_ASSUME_NONNULL_END
