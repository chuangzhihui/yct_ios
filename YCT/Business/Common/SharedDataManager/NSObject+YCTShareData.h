//
//  NSObject+YCTShareData.h
//  YCT
//
//  Created by 木木木 on 2022/1/13.
//

#import <Foundation/Foundation.h>
#import "YCTSharedDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YCTShareData)

- (BOOL)canPerformKeyPath:(NSString *)keyPath;
- (void)sendValue:(id)value keyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
