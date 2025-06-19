//
//  SRMRequestAgent.m
//  SRMNetworking
//
//  Created by 李佳宏 on 2020/11/6.
//

#import "YCTBaseRequestAgent.h"
#import "YCTRequestConfigDelegate.h"
#import "YCTBaseRequestConfig.h"

@interface YCTBaseRequestAgent ()

@end

@implementation YCTBaseRequestAgent

#pragma mark - Singleton
+ (instancetype)sharedAgent {
    static YCTBaseRequestAgent *_sharedAgent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
  
        _sharedAgent = [[super allocWithZone:NULL] init];
    });
    return _sharedAgent;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [YCTBaseRequestAgent sharedAgent];
}

#pragma mark - lifeCycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self monitorNetworking];
        self.config = [YCTBaseRequestConfig new];
    }
    return self;
}

- (void)setBaseUrl:(NSString *)baseUrl
{
    _baseUrl = baseUrl;
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = baseUrl;
}

- (void)setCdnUrl:(NSString *)cdnUrl
{
    _cdnUrl = cdnUrl;
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.cdnUrl = cdnUrl;
}



- (void)addPublicArgumentWithRequestArgument:(NSDictionary*)argument{
    if (argument.count >0) {
        [[YTKNetworkConfig sharedConfig] clearUrlFilter];
        [[YTKNetworkConfig sharedConfig] addUrlFilter:[YCTUrlArgumentsFilter filterWithArguments:argument]];
    }
}

- (void)monitorNetworking
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.netWorkStatus = status;
    }];
}
@end
