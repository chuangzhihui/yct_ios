//
//  YCTRequestConfig.m
//  YCT
//
//  Created by hua-cloud on 2021/12/25.
//

#import "YCTRequestConfig.h"
#import "YCTNavigationCoordinator.h"
#import <LEEAlert/LEEAlert.h>
#import "YCTDragPresentView.h"

@implementation YCTRequestConfig
/// 配置请求头参数
/// @param request 当前请求实例对象
- (NSDictionary *)configPublicRequestHeaderDicWithRequest:(YCTBaseRequest *)request{
    if ([YCTUserDataManager sharedInstance].isLogin) {
        NSLog(@"用户token: %@",[YCTUserDataManager sharedInstance].loginModel.token);
        return @{
            @"token" : [YCTUserDataManager sharedInstance].loginModel.token
        };
    }
    return @{};
}

/// 配置请求链接公参
/// @param argument 当前请求的参数
//- (NSDictionary *)configPublicRequestUrlArgumentWithArgument:(NSDictionary *)argument{
//    return @{@"langType":[[YCTSanboxTool getCurrentLanguage] isEqualToString:EN] ? @2 : @1};
//}

/// 配置请求公参
/// @param argument 当前请求的参数
- (NSDictionary *)configPublicRequestArgumentWithArgument:(NSDictionary *)argument{
    return @{@"langType":[[YCTSanboxTool getCurrentLanguage] isEqualToString:EN] ? @2 : @1};
}

/// 配置请求成功的全局toust
/// @param request 请求实例
- (void)showReuqestSuccessMessage:(YCTBaseRequest *)request{
    
}

/// 配置请求失败的全局toust
/// @param request 请求实例
- (void)showErrorMessageWithMessage:(YCTBaseRequest *)request{
    
}

/// 配置请求中的全局loading
- (void)showLoading{
    
}

/// 配置请求的json校验
/// @param request 请求实例
- (id)jsonValidatorWithReuqest:(YCTBaseRequest *)request{
    NSInteger code = [[request.responseJSONObject objectForKey:@"code"] integerValue];
    BOOL isSuccess = code == 1;
    BOOL isError = !isSuccess;
    if (code == 999) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[YCTDragPresentView sharePresentView] dismissWithCompletion:nil];
            [LEEAlert closeWithCompletionBlock:nil];
            [[YCTUserManager sharedInstance] logout];
            [YCTNavigationCoordinator login];
        });
    }
    if (!isSuccess) {
//        NSString *code = [request.responseJSONObject objectForKey:@"code"];
//        if ([code isEqualToString:@"AUTH_FAIL"]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//               [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_cookieExpired object:nil];
//            });
//        }
        
//        if ([code isEqualToString:@"NO_SERVICE"]) {
//            isError  = NO;
//        }
    }

    if (isError) {
        // 调用failure block
        return @{ @"thisExecuteFailureBlock":[NSObject class] };
    }

    return @{

    };
}

/// 配置请求数据层
/// @param resultDict 数据层的字典，方便转model
- (id)getParsedDataWithRequestResultDict:(NSDictionary *)resultDict{
    return resultDict[@"data"];
}

@end
