//
//  SRMRequestAgent.h
//  SRMNetworking
//
//  Created by 李佳宏 on 2020/11/6.
//

#import <Foundation/Foundation.h>
#import "YCTRequestConfigDelegate.h"
#import "YCTUrlArgumentsFilter.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTBaseRequestAgent : NSObject

/// 网络请求baseUrl
@property (nonatomic, copy)NSString * baseUrl;

/// 网络请求cdnUrl
@property (nonatomic, copy)NSString * cdnUrl;

/// 网络状态监听
@property (nonatomic, assign)AFNetworkReachabilityStatus netWorkStatus;

@property (strong, nonatomic) id <YCTRequestConfigDelegate> config;

- (void)addPublicArgumentWithRequestArgument:(NSDictionary*)argument;

+ (instancetype)sharedAgent;
@end

NS_ASSUME_NONNULL_END
