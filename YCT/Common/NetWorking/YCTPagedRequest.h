//
//  YCTPagedRequest.h
//  YCT
//
//  Created by 木木木 on 2021/12/29.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTPagedRequest : YCTBaseRequest

@property (assign) NSUInteger page;
@property (assign) NSUInteger size;

@end

NS_ASSUME_NONNULL_END
