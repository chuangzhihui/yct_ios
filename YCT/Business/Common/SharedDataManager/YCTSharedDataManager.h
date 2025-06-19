//
//  YCTSharedDataManager.h
//  YCT
//
//  Created by 木木木 on 2022/1/13.
//

#import <Foundation/Foundation.h>
#import "YCTSharedDataProtocol.h"
#import "NSObject+YCTShareData.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTSharedDataManager : NSObject

YCT_SINGLETON_DEF

- (void)addObject:(id<YCTSharedDataProtocol>)obj;
- (void)sendValue:(id)value keyPath:(NSString *)keyPath type:(NSString *)type id:(NSString *)id;

@end

NS_ASSUME_NONNULL_END
