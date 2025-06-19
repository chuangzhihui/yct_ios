//
//  SCUrlArgumentsFilter.h
//  SamClub
//
//  Created by zoyagzhou on 2019/12/19.
//  Copyright © 2019 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKNetworkConfig.h"
#import "YTKBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN

/// 给url追加arguments，用于全局参数，比如AppVersion, ApiVersion等
@interface YCTUrlArgumentsFilter : NSObject<YTKUrlFilterProtocol>

+ (YCTUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments;

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request;

@end

NS_ASSUME_NONNULL_END
